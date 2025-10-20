#!/bin/bash
# Post-create script - runs after container is created

set -e

echo "🚀 Running post-create setup..."

# Ensure workspace permissions
sudo chown -R vscode:vscode /workspace

# Load configuration (handles extensions, Continue, environment, etc.)
if [ -f "/workspace/.devcontainer/scripts/load-config.sh" ]; then
    bash /workspace/.devcontainer/scripts/load-config.sh
fi

# Install Python dependencies if requirements.txt exists
if [ -f "/workspace/requirements.txt" ]; then
    echo "📦 Installing Python dependencies..."
    pip install --user -r /workspace/requirements.txt
fi

# Set up git configuration helpers
if [ ! -f ~/.gitconfig ]; then
    echo "🔧 Setting up git configuration..."
    git config --global --add safe.directory /workspace
fi

# Create helpful aliases
if ! grep -q "# DevContainer aliases" ~/.zshrc 2>/dev/null; then
    echo "🔗 Adding helpful aliases..."
    cat >> ~/.zshrc << 'EOF'

# DevContainer aliases
alias ll='ls -lah'
alias gs='git status'
alias gp='git pull'
alias gc='git commit'
alias gd='git diff'
alias python=python3
alias pip=pip3

# AI Backend helpers
alias start-ai='cd /workspace && python -m uvicorn backend.app.main:app --reload --host 0.0.0.0 --port 8000'
alias check-ai='curl http://ai-backend:8000/health'
alias logs-ai='docker logs ai-backend -f'

# Configuration helpers
alias reload-config='bash /workspace/.devcontainer/scripts/load-config.sh'
alias show-config='cat /workspace/.devcontainer/configs/*.config.json | jq'

EOF
fi

echo "✅ Post-create setup complete!"