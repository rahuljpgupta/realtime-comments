#!/bin/zsh

# Real-time Comments Application - Complete Setup & Test Script
# For macOS with zsh shell

set -e  # Exit on any error

echo "🚀 Real-time Comments Application Setup"
echo "========================================"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a port is in use
port_in_use() {
    lsof -i:$1 >/dev/null 2>&1
}

echo "🔍 Checking prerequisites..."

# Check for nvm
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "✅ nvm found"
    source "$HOME/.nvm/nvm.sh"
    
    echo "🔄 Switching to Node.js 18..."
    nvm use 18
    
    NODE_VERSION=$(node --version)
    echo "✅ Using Node.js: $NODE_VERSION"
    
    if [[ ! "$NODE_VERSION" =~ ^v18\. ]]; then
        echo "⚠️  Warning: Node.js 18 recommended, but found $NODE_VERSION"
        echo "   The application may still work, but some features might not function correctly."
    fi
else
    echo "⚠️  nvm not found, using system Node.js"
    NODE_VERSION=$(node --version)
    echo "   Current version: $NODE_VERSION"
    
    if [[ ! "$NODE_VERSION" =~ ^v1[8-9]\.|^v[2-9][0-9]\. ]]; then
        echo "❌ Node.js 18+ required. Please install a newer version."
        echo "   You can install Node.js from: https://nodejs.org"
        exit 1
    fi
fi

echo ""
echo "🧹 Cleaning up existing processes..."

# Clean up any existing processes on our ports
if port_in_use 3001; then
    echo "🛑 Stopping existing backend server on port 3001..."
    lsof -ti:3001 | xargs kill -9 2>/dev/null || true
    sleep 2
fi

if port_in_use 3000; then
    echo "🛑 Stopping existing frontend server on port 3000..."
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    sleep 2
fi

echo ""
echo "📦 Setting up backend..."
cd backend

if [ ! -d "node_modules" ]; then
    echo "📥 Installing backend dependencies..."
    npm install --silent
else
    echo "✅ Backend dependencies already installed"
fi

echo "🖥️  Starting backend server on port 3001..."
npm start > /dev/null 2>&1 &
BACKEND_PID=$!

echo "⏳ Waiting for backend server to start..."
sleep 3

# Check if backend is running
if port_in_use 3001; then
    echo "✅ Backend server started successfully"
else
    echo "❌ Failed to start backend server"
    exit 1
fi

cd ..

echo ""
echo "🌐 Setting up demo application..."

# Check if test-app.html exists
if [ ! -f "test-app.html" ]; then
    echo "❌ test-app.html not found"
    exit 1
fi

echo "✅ Demo application ready"

echo ""
echo "🎉 Application Setup Complete!"
echo "==============================="
echo ""
echo "📱 Demo Application: file://$(pwd)/test-app.html"
echo "🖥️  Backend Server: http://localhost:3001"
echo ""
echo "🧪 Testing Real-time Features:"
echo "1. Open the demo in multiple browser tabs"
echo "2. Use different names in each tab"
echo "3. Test these features:"
echo "   • Real-time commenting"
echo "   • Typing indicators" 
echo "   • Unread comment counters"
echo "   • Auto-scroll to new comments"
echo "   • Mark comments as read by scrolling"
echo ""

# Open the demo application
if command_exists open; then
    echo "🌐 Opening demo in your default browser..."
    open "test-app.html"
else
    echo "📱 Please manually open 'test-app.html' in your browser"
fi

echo ""
echo "📊 Server Status:"
echo "Backend PID: $BACKEND_PID"
echo ""
echo "🛑 To stop the application:"
echo "   Press Ctrl+C or run: kill $BACKEND_PID"
echo ""
echo "📋 Server logs will appear below:"
echo "================================="

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🧹 Cleaning up..."
    kill $BACKEND_PID 2>/dev/null || true
    echo "✅ Application stopped"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Wait for the backend process and show its output
wait $BACKEND_PID
