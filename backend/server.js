const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const server = http.createServer(app);

// Configure CORS for Socket.io
const io = socketIo(server, {
  cors: {
    origin: ["http://localhost:3000", "http://localhost:3002", "file://"],
    methods: ["GET", "POST"],
    credentials: true
  }
});

// Middleware
app.use(cors());
app.use(express.json());

// In-memory storage (in production, use a database)
let comments = [];
let userSessions = new Map(); // Track user sessions and their unread counts

// Mock initial comments for testing
comments = [
  {
    id: uuidv4(),
    author: 'Alice',
    text: 'This looks great! Nice work on the implementation.',
    timestamp: new Date(Date.now() - 60000).toISOString(),
    isRead: false
  },
  {
    id: uuidv4(),
    author: 'Bob',
    text: 'I have a few suggestions for optimization.',
    timestamp: new Date(Date.now() - 30000).toISOString(),
    isRead: false
  },
  {
    id: uuidv4(),
    author: 'Carol',
    text: 'Could you add some unit tests for this feature?',
    timestamp: new Date(Date.now() - 15000).toISOString(),
    isRead: false
  }
];

// REST API endpoints
app.get('/api/comments', (req, res) => {
  res.json(comments);
});

app.get('/api/unread-count/:userId', (req, res) => {
  const userId = req.params.userId;
  const userSession = userSessions.get(userId);
  const unreadCount = userSession ? userSession.unreadCount : comments.filter(c => !c.isRead).length;
  res.json({ unreadCount });
});

app.post('/api/comments/:commentId/read/:userId', (req, res) => {
  const { commentId, userId } = req.params;
  
  // Mark comment as read for this user
  const userSession = userSessions.get(userId);
  if (userSession) {
    if (!userSession.readComments.includes(commentId)) {
      userSession.readComments.push(commentId);
      userSession.unreadCount = Math.max(0, userSession.unreadCount - 1);
    }
  }
  
  res.json({ success: true });
});

// Socket.io connection handling
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);
  
  // Initialize user session
  const userId = socket.handshake.query.userId || socket.id;
  if (!userSessions.has(userId)) {
    userSessions.set(userId, {
      socketId: socket.id,
      unreadCount: comments.filter(c => !c.isRead).length,
      readComments: []
    });
  } else {
    // Update socket ID for existing user
    const userSession = userSessions.get(userId);
    userSession.socketId = socket.id;
  }
  
  // Send initial data
  socket.emit('initial_comments', comments);
  socket.emit('unread_count', userSessions.get(userId).unreadCount);
  
  // Handle new comment
  socket.on('new_comment', (commentData) => {
    const newComment = {
      id: uuidv4(),
      author: commentData.author,
      text: commentData.text,
      timestamp: new Date().toISOString(),
      isRead: false
    };
    
    comments.push(newComment);
    
    // Increment unread count for all connected users except the sender
    userSessions.forEach((session, sessionUserId) => {
      if (sessionUserId !== userId) {
        session.unreadCount++;
        // Emit to specific user's socket
        const userSocket = [...io.sockets.sockets.values()].find(s => s.id === session.socketId);
        if (userSocket) {
          userSocket.emit('unread_count', session.unreadCount);
        }
      }
    });
    
    // Broadcast new comment to all connected clients
    io.emit('comment_added', newComment);
  });
  
  // Handle comment read
  socket.on('mark_comment_read', (commentId) => {
    const userSession = userSessions.get(userId);
    if (userSession && !userSession.readComments.includes(commentId)) {
      userSession.readComments.push(commentId);
      userSession.unreadCount = Math.max(0, userSession.unreadCount - 1);
      socket.emit('unread_count', userSession.unreadCount);
    }
  });
  
  // Handle typing indicator
  socket.on('typing_start', (data) => {
    socket.broadcast.emit('user_typing', { user: data.user, isTyping: true });
  });
  
  socket.on('typing_stop', (data) => {
    socket.broadcast.emit('user_typing', { user: data.user, isTyping: false });
  });
  
  // Handle disconnect
  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
    // Note: We keep the user session for when they reconnect
  });
});

const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
