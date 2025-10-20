# DevContainer Configuration System

## Overview

This DevContainer uses a **flexible, configuration-driven approach** that allows you to:
- Choose different development environments (Python, Node.js, Full Stack, etc.)
- Automatically configure Continue AI extension
- Enable/disable features like logging, linting, testing
- Reuse common patterns across all your projects

## 🎯 Key Features

### 1. **Continue Integration (Always Enabled)**
- Automatically configures Continue extension
- Connects to your self-hosted AI backend
- Pre-configured custom commands (/test, /optimize, /security, etc.)
- Works with any configuration

### 2. **Logging (Enabled by Default)**
- Structured logging with appropriate libraries (Loguru for Python, Winston for Node.js)
- Configurable log levels (DEBUG, INFO, WARNING, ERROR)
- Log rotation and retention
- Console and file outputs

### 3. **Linting & Formatting (Enabled by Default)**
- Auto-format on save
- Language-specific linters (flake8, pylint, eslint, etc.)
- Consistent code style enforcement

### 4. **Additional Features**
- Testing frameworks (pytest, jest)
- Git hooks and automation
- Security scanning
- Documentation generation
- And more!

## 📁 Configuration Files

Located in `.devcontainer/configs/`:

- **`base.config.json`** - Foundation for all environments (Continue, logging, linting, etc.)
- **`python.config.json`** - Python development (extends base)
- **`nodejs.config.json`** - Node.js/TypeScript development (extends base)
- **`fullstack.config.json`** - Full stack development (extends base)

## 🚀 Quick Start

### Choose Your Configuration

#### Option 1: Using Environment Variable (Recommended)

**Windows:**
```powershell
$env:DEVCONTAINER_CONFIG_FILE = "d:\Repos\ai-devcontainer\.devcontainer\configs\python.config.json"
code .
```

**Linux/Mac:**
```bash
export DEVCONTAINER_CONFIG_FILE=/workspace/.devcontainer/configs/python.config.json
code .
```

#### Option 2: Edit devcontainer.json

Change the default config in `.devcontainer/devcontainer.json`:
```json
{
  "containerEnv": {
    "CONFIG_FILE": "${containerWorkspaceFolder}/.devcontainer/configs/fullstack.config.json"
  }
}
```

### Reload Configuration

If you change configs while the container is running:
```bash
reload-config
```

## 🔧 Creating Custom Configurations

### Example: Custom Data Science Config

Create `.devcontainer/configs/datascience.config.json`:

```json
{
  "extends": "base.config.json",
  "name": "Data Science Configuration",
  
  "extensions": {
    "additional": [
      "ms-toolsai.jupyter",
      "ms-python.vscode-pylance",
      "quarto.quarto"
    ]
  },

  "features": {
    "logging": {
      "enabled": true,
      "library": "loguru",
      "level": "DEBUG"
    },
    "linting": {
      "enabled": true,
      "tools": {
        "python": ["black", "isort"]
      }
    }
  },

  "environment": {
    "JUPYTER_ENABLE_LAB": "yes",
    "PYTHON_VERSION": "3.11"
  }
}
```

## 📋 Configuration Schema

### Structure

```json
{
  "extends": "base.config.json",  // Optional: inherit from another config
  "name": "My Config",
  "description": "Description here",
  
  "extensions": {
    "required": [],      // Must be installed
    "recommended": [],   // Should be installed
    "additional": []     // Extends parent config
  },

  "continueConfig": {
    "enabled": true,     // Always true to ensure Continue works
    "apiBase": "http://ai-backend:8000/v1",
    "model": "microsoft/DialoGPT-medium",
    "customCommands": {
      "commandName": "Prompt for AI"
    }
  },

  "features": {
    "logging": {
      "enabled": true,
      "level": "INFO",   // DEBUG, INFO, WARNING, ERROR
      "library": "loguru",  // Or "winston" for Node.js
      "format": "structured",
      "rotation": "10MB",
      "retention": "7 days"
    },
    "linting": {
      "enabled": true,
      "formatOnSave": true,
      "tools": {
        "python": ["flake8", "black", "isort"],
        "javascript": ["eslint", "prettier"]
      }
    },
    "testing": {
      "enabled": true,
      "framework": "pytest",  // Or "jest", "auto-detect"
      "coverage": true
    },
    "git": {
      "enabled": true,
      "hooks": ["pre-commit"]
    },
    "security": {
      "enabled": true,
      "scanDependencies": true
    }
  },

  "environment": {
    "KEY": "value"
  },

  "vscode": {
    "settings": {
      // VS Code settings to apply
    }
  }
}
```

## 💡 Common Patterns Included

### 1. Continue AI Integration
**Every configuration includes:**
- Continue extension auto-install
- Connection to self-hosted AI backend
- Custom commands for common tasks
- Context providers (code, docs, terminal, etc.)

### 2. Logging
**Standard logging setup:**
- Python: Loguru with structured logging
- Node.js: Winston with JSON format
- Configurable log levels and rotation
- Both console and file outputs

### 3. Linting & Formatting
**Consistent code quality:**
- Auto-format on save
- Language-specific tools
- Pre-commit hooks (optional)

### 4. Testing
**Testing infrastructure:**
- Framework auto-detection
- Coverage reporting
- Test discovery

### 5. Git Integration
**Version control helpers:**
- Auto-fetch enabled
- Git hooks support
- Aliases for common commands

### 6. Security
**Security best practices:**
- Dependency scanning
- Secret detection
- Input validation reminders

## 🛠️ Advanced Usage

### Multiple Configurations Per Project

You can switch between configs for different tasks:

```bash
# Data exploration
CONFIG_FILE=/workspace/.devcontainer/configs/datascience.config.json reload-config

# Backend development
CONFIG_FILE=/workspace/.devcontainer/configs/python.config.json reload-config

# Frontend work
CONFIG_FILE=/workspace/.devcontainer/configs/nodejs.config.json reload-config
```

### Sharing Configs Across Projects

1. Create a central config repository
2. Mount it as a volume in docker-compose.yml
3. Reference configs from the shared location

## 📊 What Else Might You Need?

Consider adding to your configs:

- **Performance Monitoring**: Profilers, debuggers
- **Database Tools**: SQL formatters, ORMs
- **API Development**: Postman/Insomnia, OpenAPI tools
- **Cloud Integration**: AWS/GCP/Azure extensions
- **Collaboration**: Live Share, comments
- **Accessibility**: Screen reader support, color themes
- **Internationalization**: i18n tools
- **CI/CD Integration**: GitHub Actions, GitLab CI
- **Container Management**: Kubernetes, Docker extensions
- **Documentation**: Diagram tools, Markdown preview

Let me know what you'd like to add!