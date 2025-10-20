#!/bin/bash
# Configuration loader for DevContainer
# Reads config files and applies settings dynamically

set -e

CONFIG_DIR="/workspace/.devcontainer/configs"
BASE_CONFIG="$CONFIG_DIR/base.config.json"
APP_CONFIG="${CONFIG_FILE:-$CONFIG_DIR/python.config.json}"  # Default to python

echo "🔧 Loading DevContainer Configuration..."
echo "   Base: $BASE_CONFIG"
echo "   App:  $APP_CONFIG"

# Install jq if not present
if ! command -v jq &> /dev/null; then
    echo "📦 Installing jq..."
    sudo apt-get update -qq && sudo apt-get install -y -qq jq
fi

# Function to merge configs
merge_configs() {
    local base=$1
    local override=$2
    
    # If override extends base, merge them
    if [ -f "$override" ] && jq -e '.extends' "$override" > /dev/null 2>&1; then
        jq -s '.[0] * .[1]' "$base" "$override"
    elif [ -f "$override" ]; then
        cat "$override"
    else
        cat "$base"
    fi
}

# Merge configurations
MERGED_CONFIG=$(merge_configs "$BASE_CONFIG" "$APP_CONFIG")

# Extract and install extensions
echo "📦 Installing VS Code Extensions..."
echo "$MERGED_CONFIG" | jq -r '.extensions.required[]?, .extensions.recommended[]?, .extensions.additional[]?' 2>/dev/null | while read -r ext; do
    if [ -n "$ext" ]; then
        echo "   Installing: $ext"
        code --install-extension "$ext" --force 2>/dev/null || true
    fi
done

# Set up environment variables
echo "🌍 Setting up environment variables..."
ENV_FILE="/home/vscode/.devcontainer_env"
echo "$MERGED_CONFIG" | jq -r '.environment | to_entries[] | "export \(.key)=\"\(.value)\""' > "$ENV_FILE"

# Source in shell profiles
for profile in ~/.bashrc ~/.zshrc; do
    if [ -f "$profile" ] && ! grep -q "source $ENV_FILE" "$profile"; then
        echo "source $ENV_FILE" >> "$profile"
    fi
done

# Configure Continue extension
if echo "$MERGED_CONFIG" | jq -e '.continueConfig.enabled == true' > /dev/null 2>&1; then
    echo "⚙️  Configuring Continue extension..."
    
    CONTINUE_DIR="/home/vscode/.continue"
    mkdir -p "$CONTINUE_DIR"
    
    # Extract Continue config
    API_BASE=$(echo "$MERGED_CONFIG" | jq -r '.continueConfig.apiBase // "http://ai-backend:8000/v1"')
    MODEL=$(echo "$MERGED_CONFIG" | jq -r '.continueConfig.model // "microsoft/DialoGPT-medium"')
    
    # Generate Continue config from template
    cat > "$CONTINUE_DIR/config.json" <<EOF
{
  "models": [
    {
      "title": "Self-Hosted AI",
      "provider": "openai",
      "model": "$MODEL",
      "apiKey": "not-required",
      "apiBase": "$API_BASE"
    }
  ],
  "contextProviders": $(echo "$MERGED_CONFIG" | jq '.continueConfig.contextProviders // ["code", "docs", "diff"]'),
  "customCommands": $(echo "$MERGED_CONFIG" | jq '.continueConfig.customCommands // {}' | jq 'to_entries | map({name: .key, prompt: .value, description: .value}) // []'),
  "allowAnonymousTelemetry": false
}
EOF
    
    echo "   ✅ Continue configured with backend: $API_BASE"
fi

# Set up logging
if echo "$MERGED_CONFIG" | jq -e '.features.logging.enabled == true' > /dev/null 2>&1; then
    echo "📝 Logging enabled"
    LOG_LEVEL=$(echo "$MERGED_CONFIG" | jq -r '.features.logging.level // "INFO"')
    export LOG_LEVEL
fi

# Set up git hooks if enabled
if echo "$MERGED_CONFIG" | jq -e '.features.git.enabled == true' > /dev/null 2>&1; then
    echo "🔗 Setting up git hooks..."
    if command -v pre-commit &> /dev/null; then
        pre-commit install 2>/dev/null || true
    fi
fi

# Apply VS Code settings
echo "⚙️  Applying VS Code settings..."
VSCODE_SETTINGS="/workspace/.vscode/settings.json"
mkdir -p "$(dirname "$VSCODE_SETTINGS")"

# Merge VS Code settings
EXISTING_SETTINGS="{}"
if [ -f "$VSCODE_SETTINGS" ]; then
    EXISTING_SETTINGS=$(cat "$VSCODE_SETTINGS")
fi

echo "$MERGED_CONFIG" | jq '.vscode.settings // {}' | jq -s ".[0] * .[1]" "$VSCODE_SETTINGS" - > "$VSCODE_SETTINGS.tmp" 2>/dev/null || true
if [ -f "$VSCODE_SETTINGS.tmp" ]; then
    mv "$VSCODE_SETTINGS.tmp" "$VSCODE_SETTINGS"
fi

echo "✅ Configuration loaded successfully!"
echo ""
echo "📋 Active Configuration Summary:"
echo "$MERGED_CONFIG" | jq '{
    name: .name,
    continueEnabled: .continueConfig.enabled,
    logging: .features.logging.enabled,
    linting: .features.linting.enabled,
    testing: .features.testing.enabled
}'
echo ""