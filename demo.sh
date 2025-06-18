#!/bin/bash

# Real-time Comments Demo Script
echo "🚀 Starting Real-time Comments Application Demo"
echo "================================================"

# Switch to Node.js 18
echo "📦 Switching to Node.js 18..."
source ~/.nvm/nvm.sh
nvm use 18

# Check if backend server is running
if ! lsof -i:3001 > /dev/null 2>&1; then
    echo "⚠️  Backend server not running on port 3001"
    echo "📂 Starting backend server..."
    
    cd backend
    if [ ! -d "node_modules" ]; then
        echo "📦 Installing backend dependencies..."
        npm install
    fi
    
    echo "🖥️  Starting server on http://localhost:3001"
    npm start &
    BACKEND_PID=$!
    
    # Wait for server to start
    echo "⏳ Waiting for server to start..."
    sleep 3
    
    cd ..
else
    echo "✅ Backend server already running on port 3001"
fi

echo ""
echo "🌐 Opening demo application..."
echo ""
echo "📋 DEMO INSTRUCTIONS:"
echo "1. The HTML demo will open in your default browser"
echo "2. Open additional browser tabs/windows to test real-time features"
echo "3. Use different names in each tab to simulate multiple users"
echo "4. Try these features:"
echo "   • Type to see typing indicators"
echo "   • Post comments to see real-time updates"
echo "   • Watch unread counters update automatically" 
echo "   • Scroll to mark comments as read"
echo ""

# Open the demo HTML file
if command -v open > /dev/null 2>&1; then
    # macOS
    open test-app.html
elif command -v xdg-open > /dev/null 2>&1; then
    # Linux
    xdg-open test-app.html
elif command -v start > /dev/null 2>&1; then
    # Windows
    start test-app.html
else
    echo "📱 Please manually open 'test-app.html' in your browser"
fi

echo ""
echo "🎉 Demo is ready!"
echo "💡 Server logs will appear below (Ctrl+C to stop):"
echo "================================================"

# If we started the backend, wait for it and show logs
if [ ! -z "$BACKEND_PID" ]; then
    wait $BACKEND_PID
fi