#!/bin/zsh

# Real-time Comments Application - Quick Test
echo "🧪 Testing Real-time Comments Application"
echo "========================================"

# Switch to Node.js 18
nvm use 18

echo "✅ Node.js version: $(node --version)"
echo ""

# Test backend connection
echo "🔍 Testing backend connection..."
if curl -s http://localhost:3001/api/comments > /dev/null; then
    echo "✅ Backend server is responding"
    
    # Get comments count
    COMMENTS_COUNT=$(curl -s http://localhost:3001/api/comments | jq length 2>/dev/null || echo "unknown")
    echo "📊 Current comments in database: $COMMENTS_COUNT"
else
    echo "❌ Backend server not responding on port 3001"
    echo "💡 Make sure to run: cd backend && npm start"
    exit 1
fi

echo ""
echo "🌐 Testing demo application..."

# Check if HTML demo exists
if [ -f "test-app.html" ]; then
    echo "✅ HTML demo found"
    
    # Open demo
    echo "🚀 Opening demo in browser..."
    open test-app.html
    
    echo ""
    echo "🎉 Application Test Complete!"
    echo "=========================="
    echo ""
    echo "📋 Next Steps:"
    echo "1. The demo should now be open in your browser"
    echo "2. Open additional browser tabs to test real-time features"
    echo "3. Use different names in each tab"
    echo "4. Try typing, commenting, and scrolling"
    echo ""
    echo "✨ Features to test:"
    echo "   • Real-time commenting"
    echo "   • Typing indicators"
    echo "   • Unread counters"
    echo "   • Auto-scroll to new comments"
    echo "   • Mark as read when scrolling"
    echo ""
    echo "🎯 Expected behavior:"
    echo "   • Comments appear instantly in all tabs"
    echo "   • Typing indicators show with animated dots"
    echo "   • Unread counters update automatically"
    echo "   • Connection status shows as connected"
    
else
    echo "❌ HTML demo not found"
    echo "💡 Make sure you're in the correct directory"
    exit 1
fi
