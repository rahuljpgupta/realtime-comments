# Real-time Comments Application

A GitHub PR-style real-time commenting system built with React.js, Node.js, and Socket.io.

## Features

✅ **Real-time Communication**: Comments appear instantly without page refresh  
✅ **Unread Counter**: Shows number of unread comments on load  
✅ **Read Status Tracking**: Automatically marks comments as read when viewed  
✅ **Typing Indicators**: Shows when users are typing  
✅ **Persistent User Sessions**: Remembers user across browser sessions  
✅ **Modern UI**: GitHub-inspired design with animations  
✅ **Responsive Design**: Works on desktop and mobile  

## Architecture

- **Backend**: Node.js + Express + Socket.io
- **Frontend**: React.js + TypeScript + Socket.io-client
- **Demo**: Pure HTML/JS version for quick testing

## Prerequisites

- **Node.js 18+** (required for modern JavaScript features)
- **npm** (comes with Node.js)

⚠️ **Important**: If you're using nvm and your terminal defaults to an older Node.js version, run `nvm use 18` before starting the servers.

## Quick Start

### 1. Switch to Node.js 18 (if using nvm)

```bash
nvm use 18
```

### 2. Start the Backend Server

```bash
cd backend
npm install
npm start
```

The server will run on `http://localhost:3001`

### 2. Option A: HTML Demo (Recommended for testing)

Open `test-app.html` in your browser:

```bash
open test-app.html
```

### 2. Option B: React Application

```bash
cd frontend
npm install
npm start
```

The React app will run on `http://localhost:3000`

## Testing Real-time Features

1. **Open multiple browser tabs/windows** to `test-app.html`
2. **Enter different names** in each tab
3. **Start typing** - you'll see typing indicators in other tabs
4. **Post comments** - they appear instantly in all tabs
5. **Watch unread counters** update automatically
6. **Scroll to comments** to mark them as read

## Project Structure

```
realtime-comments/
├── backend/              # Node.js server
│   ├── package.json
│   └── server.js        # Socket.io server with comment logic
├── frontend/            # React.js application
│   ├── src/
│   │   ├── App.tsx      # Main React component
│   │   ├── socketService.ts    # Socket.io client service
│   │   ├── types.ts     # TypeScript interfaces
│   │   └── components/  # React components
│   └── package.json
├── test-app.html        # Standalone HTML demo
└── README.md           # This file
```

## Key Features Explained

### Unread Comment Tracking
- Comments start as "unread" for all users except the author
- Uses Intersection Observer API to detect when comments are viewed
- Backend tracks read status per user session
- Unread counter updates in real-time

### Real-time Communication
- Socket.io for bidirectional communication
- Comments broadcast to all connected clients instantly
- Connection status indicator
- Automatic reconnection handling

### Typing Indicators
- Shows when users are actively typing
- 2-second timeout after stopping typing
- Displays multiple users typing simultaneously

### User Sessions
- Generates unique user IDs stored in localStorage
- Persistent across browser sessions
- Tracks individual read/unread status per user

## API Endpoints

### Socket Events

**Client → Server:**
- `new_comment` - Send a new comment
- `mark_comment_read` - Mark comment as read
- `typing_start` - Start typing indicator
- `typing_stop` - Stop typing indicator

**Server → Client:**
- `initial_comments` - Initial comment list on connect
- `comment_added` - New comment broadcast
- `unread_count` - Updated unread count
- `user_typing` - Typing indicator update

### REST API
- `GET /api/comments` - Get all comments
- `GET /api/unread-count/:userId` - Get unread count for user
- `POST /api/comments/:commentId/read/:userId` - Mark comment as read

## Browser Compatibility

- Chrome/Edge: Full support
- Firefox: Full support
- Safari: Full support
- Mobile browsers: Full support

## Demo Instructions

1. **Start the backend server** (`npm start` in `backend/`)
2. **Open `test-app.html`** in multiple browser tabs
3. **Use different names** in each tab to simulate different users
4. **Test real-time features**:
   - Type in one tab, see typing indicator in others
   - Post comments, see them appear instantly
   - Watch unread counters update
   - Scroll to mark comments as read

## Development Notes

The React version has some Node.js compatibility issues with the current environment. The HTML demo provides full functionality and is recommended for testing the real-time features.

## Technologies Used

- **Node.js** - Server runtime
- **Express.js** - Web framework
- **Socket.io** - Real-time communication
- **React.js** - Frontend framework (TypeScript)
- **HTML/CSS/JS** - Demo application
- **UUID** - Unique ID generation