#!/bin/bash

# Quick start script for real-time comments app
echo "🚀 Real-time Comments - Quick Start"
echo "===================================="

# Load nvm if available
if [ -f ~/.nvm/nvm.sh ]; then
    echo "📦 Loading nvm..."
    source ~/.nvm/nvm.sh
    
    echo "🔄 Switching to Node.js 18..."
    nvm use 18
    
    echo "✅ Node.js version: $(node --version)"
else
    echo "ℹ️  nvm not found, using system Node.js: $(node --version)"
fi

echo ""
echo "🖥️  Starting backend server..."
cd backend

# Kill any existing server on port 3001
lsof -ti:3001 | xargs kill -9 2>/dev/null || true

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing backend dependencies..."
    npm install
fi

# Start server
npm start &
BACKEND_PID=$!

echo "⏳ Waiting for server to start..."
sleep 3

cd ..

echo ""
echo "🌐 Opening demo application..."
if command -v open > /dev/null 2>&1; then
    open test-app.html
else
    echo "📱 Please open 'test-app.html' in your browser"
fi

echo ""
echo "✅ Application is ready!"
echo "📋 To test real-time features:"
echo "   1. Open multiple browser tabs to test-app.html"
echo "   2. Use different names in each tab"
echo "   3. Try typing, commenting, and scrolling"
echo ""
echo "🛑 Press Ctrl+C to stop the server"
echo "===================================="

# Wait for the backend process
wait $BACKEND_PID
