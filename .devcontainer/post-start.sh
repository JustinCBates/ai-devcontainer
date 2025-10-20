#!/bin/bash
# Post-start script - runs after container starts

set -e

echo "🎯 Running post-start checks..."

# Wait for AI backend to be ready
echo "⏳ Waiting for AI Backend to be ready..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if curl -sf http://ai-backend:8000/health > /dev/null 2>&1; then
        echo "✅ AI Backend is ready!"
        break
    fi
    attempt=$((attempt + 1))
    if [ $attempt -eq $max_attempts ]; then
        echo "⚠️  AI Backend is not responding yet. You may need to start it manually."
        echo "   Run: docker-compose up ai-backend"
    fi
    sleep 2
done

# Display helpful information
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         AI-Powered Development Container Ready! 🎉         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📍 Services:"
echo "   • AI Backend API:  http://localhost:8000"
echo "   • API Docs:        http://localhost:8000/docs"
echo "   • Health Check:    http://localhost:8000/health"
echo ""
echo "🎮 Quick Commands:"
echo "   • check-ai      - Check AI backend status"
echo "   • logs-ai       - View AI backend logs"
echo "   • start-ai      - Start AI backend in this container"
echo ""
echo "💡 Continue Extension:"
echo "   • Press Ctrl+I (Cmd+I on Mac) to open Continue chat"
echo "   • Use /edit, /test, /comment commands"
echo ""
echo "Happy coding with AI assistance! 🚀"
echo ""