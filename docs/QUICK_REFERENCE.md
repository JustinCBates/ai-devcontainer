# Quick Reference Card

## 🚀 Getting Started

```bash
# 1. Set your config (Windows)
$env:DEVCONTAINER_CONFIG_FILE = ".devcontainer/configs/python.config.json"

# 2. Open in VS Code
code .

# 3. Reopen in Container
# Click "Reopen in Container" when prompted
```

## 🎯 Continue AI Commands

| Command | Description |
|---------|-------------|
| `Ctrl+I` / `Cmd+I` | Open Continue chat |
| `/test` | Generate comprehensive tests |
| `/optimize` | Optimize code for performance |
| `/security` | Security vulnerability analysis |
| `/refactor` | Refactor using best practices |
| `/explain` | Explain code in detail |
| `/docker` | Generate Dockerfile |
| `/edit` | Edit selected code |
| `/comment` | Add comments to code |

## 🛠️ Shell Aliases

| Alias | Command |
|-------|---------|
| `ll` | `ls -lah` |
| `gs` | `git status` |
| `gp` | `git pull` |
| `gc` | `git commit` |
| `gd` | `git diff` |
| `check-ai` | Check AI backend status |
| `logs-ai` | View AI backend logs |
| `reload-config` | Reload configuration |
| `show-config` | Display active config |

## 📦 Available Configurations

| Config | Use Case |
|--------|----------|
| `base.config.json` | Minimal setup (Continue, logging, linting) |
| `python.config.json` | Python development |
| `nodejs.config.json` | Node.js/TypeScript |
| `fullstack.config.json` | Python + Node.js |

## 🔧 Python Development

```bash
# Format code
black .
isort .

# Lint code
flake8 .
pylint *.py

# Run tests
pytest
pytest --cov=.

# Install dependencies
pip install -r requirements.txt
```

## 🔧 Node.js Development

```bash
# Format code
npx prettier --write .

# Lint code
npx eslint .

# Run tests
npm test

# Install dependencies
npm install
```

## 📝 Logging

```python
# Python (Loguru)
from loguru import logger

logger.debug("Debug message")
logger.info("Info message")
logger.warning("Warning")
logger.error("Error")
```

```javascript
// Node.js (Winston)
const logger = require('./logger');

logger.debug('Debug message');
logger.info('Info message');
logger.warn('Warning');
logger.error('Error');
```

## 🔍 Common Tasks

### Switch Configuration
```bash
CONFIG_FILE=.devcontainer/configs/nodejs.config.json reload-config
```

### Check AI Backend
```bash
curl http://ai-backend:8000/health
```

### View Logs
```bash
# AI backend logs
docker logs ai-backend -f

# Application logs
tail -f logs/app.log
```

### Debug in VS Code
1. Set breakpoints
2. Press `F5`
3. Choose "Python: FastAPI" or "Python: Current File"

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| Continue not working | Check `check-ai` alias |
| Extensions missing | Run `reload-config` |
| Port already in use | Change port in docker-compose.yml |
| Permission errors | Run `sudo chown -R vscode:vscode /workspace` |

## 📚 Documentation

- [CONFIG_GUIDE.md](CONFIG_GUIDE.md) - Full configuration guide
- [DESIGN.md](DESIGN.md) - Architecture and design decisions
- [README.md](README.md) - Main documentation

## 🔗 Useful Links

- Continue Docs: https://continue.dev/docs
- VS Code DevContainers: https://containers.dev/
- Docker Compose: https://docs.docker.com/compose/