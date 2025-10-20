# AI DevContainer: Configuration-Driven Development

This repository provides a **portable, configurable, containerized development environment** for AI-powered coding with the Continue extension and your self-hosted AI backend.

## 🚀 Features
- **Configuration-Driven**: Choose Python, Node.js, Full Stack, or create custom configs
- **Continue AI Integration**: Automatically configured in every environment
- **Standard Patterns**: Logging, linting, testing, security built-in
- **Flexible & Reusable**: One config for all your projects
- **Docker Compose orchestration** with your AI backend
- Works with local or remote VS Code

## 📋 Available Configurations

- **`base.config.json`** - Core features (Continue, logging, linting) for all environments
- **`python.config.json`** - Python development with pytest, black, isort
- **`nodejs.config.json`** - Node.js/TypeScript with jest, eslint, prettier
- **`fullstack.config.json`** - Full stack with both Python and Node.js tools

See [docs/CONFIG_GUIDE.md](docs/CONFIG_GUIDE.md) for detailed configuration documentation.

## 🏗️ Structure
```
ai-devcontainer/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── post-create.sh
│   ├── post-start.sh
│   ├── requirements-dev.txt
│   └── continue-config.json
├── .vscode/
│   ├── settings.json
│   └── launch.json
├── workspace/           # Place your code here
└── scripts/             # Optional helper scripts
```

## 🧑‍💻 Quick Start

### 1. Clone Both Repos

```bash
git clone <your-self-hosted-ai-backend-repo>
git clone <this-ai-devcontainer-repo>
```

### 2. Choose Your Configuration

**Option 1: Set environment variable (Windows)**
```powershell
$env:DEVCONTAINER_CONFIG_FILE = "d:\Repos\ai-devcontainer\.devcontainer\configs\python.config.json"
```

**Option 2: Edit `.devcontainer/devcontainer.json`**
Change the `CONFIG_FILE` to your desired config.

### 3. Build AI Backend Image

```bash
cd <your-self-hosted-ai-backend-repo>
docker build -f docker/Dockerfile -t self-hosted-ai .
```

### 4. Open DevContainer in VS Code
- Open the `ai-devcontainer` folder in VS Code
- Click "Reopen in Container" when prompted
- Wait for configuration to load and extensions to install

### 5. Start Coding with AI!
- Press `Ctrl+I` (or `Cmd+I` on Mac) to open Continue chat
- Use `/test`, `/optimize`, `/security`, `/refactor` commands
- AI backend automatically connects at `http://ai-backend:8000`

## ⚙️ Customization
- Add your code to the `workspace/` directory
- Update `.devcontainer/continue-config.json` for custom models or endpoints
- Add more extensions in `devcontainer.json` as needed

## 📚 Documentation
- [CONFIG_GUIDE.md](docs/CONFIG_GUIDE.md) - Complete configuration reference
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - System architecture and diagrams
- [DESIGN.md](docs/DESIGN.md) - Design decisions and patterns
- [QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md) - Commands and shortcuts
- [UNIVERSAL_TOOLS.md](docs/UNIVERSAL_TOOLS.md) - Essential tools for all developers
- [SUMMARY.md](docs/SUMMARY.md) - Project summary
- [BACKLOG.md](BACKLOG.md) - Future features and enhancements

## �📝 Notes
- You can still use your local VS Code and connect to the container
- The AI backend can run locally or in the container
- All settings are portable and reproducible

## 🆘 Troubleshooting
- If the AI backend is not responding, check logs with `docker logs ai-backend`
- Ensure ports 8000 and 3000 are not in use
- For extension issues, reload VS Code window

## 📚 References
- [Continue Extension](https://continue.dev/)
- [VS Code DevContainers](https://containers.dev/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Project Documentation](docs/)
