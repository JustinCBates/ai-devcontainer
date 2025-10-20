# AI DevContainer Launch Guide

## Quick Start

### Option 1: Interactive Launcher (Recommended)

```powershell
cd d:\Repos\ai-devcontainer
.\launch-devcontainer.ps1
```

Follow the interactive menu to select your configuration and launch VS Code.

### Option 2: Manual Launch

```powershell
cd d:\Repos\ai-devcontainer
code .
# Then: F1 -> "Dev Containers: Reopen in Container"
```

---

## Interactive Launcher Features

The `launch-devcontainer.ps1` script provides:

- **Prerequisites Check** - Verifies Docker and VS Code are available
- **Interactive Menu** - Choose from 5 configuration options
- **Configuration Preview** - See what you're getting before building
- **Automatic Setup** - Sets environment variables and launches VS Code
- **Next Steps Guide** - Clear instructions for what to do after launch

---

## Configuration Options

### [1] Base Configuration
**Best for:** Minimal setup, scripting, configuration files

**Includes:**
- 24 universal extensions
- Git, linting, testing tools
- Continue AI assistance
- Docker-in-Docker support

**Build Time:** 5-7 minutes  
**Container Size:** ~2 GB

---

### [2] Python Configuration (RECOMMENDED for AI work)
**Best for:** AI/ML development, backend, data science

**Includes:**
- Everything from Base (24 extensions)
- 7 Python-specific extensions
- Python 3.11
- pytest, Jupyter, Loguru
- Black, isort, flake8, pylint

**Build Time:** 8-10 minutes  
**Container Size:** ~3 GB

---

### [3] Node.js Configuration
**Best for:** Web development, React, API development

**Includes:**
- Everything from Base (24 extensions)
- 5 Node.js-specific extensions
- Node.js 20 LTS
- Jest, ESLint, Prettier
- npm, yarn, pnpm

**Build Time:** 8-10 minutes  
**Container Size:** ~3 GB

---

### [4] Full Stack Configuration
**Best for:** Full stack applications, microservices

**Includes:**
- Everything from Base (24 extensions)
- All Python extensions (7)
- All Node.js extensions (5)
- Python 3.11 + Node.js 20
- All development tools

**Build Time:** 12-15 minutes  
**Container Size:** ~4 GB

---

### [5] Custom Configuration
**Best for:** Advanced users with specific requirements

Allows you to specify your own configuration file path.

---

## Step-by-Step Walkthrough

### 1. Run the Launcher

```powershell
cd d:\Repos\ai-devcontainer
.\launch-devcontainer.ps1
```

### 2. Select Configuration

```
Select your DevContainer configuration:

  [1] Base Configuration
  [2] Python Configuration (RECOMMENDED for AI work)
  [3] Node.js Configuration
  [4] Full Stack Configuration
  [5] Custom Configuration

Enter your choice [1-5]: 2
```

### 3. Confirm Selection

```
You selected: Python Configuration

Configuration: Python 3.11 with AI/ML tools
Extensions: 31 extensions
Build time: 8-10 minutes (first time)

This will:
  - Build Ubuntu 22.04 container
  - Install Python 3.11
  - Install 31 VS Code extensions
  - Configure Continue AI
  - Set up development tools

Continue? [Y/n]: y
```

### 4. VS Code Opens Automatically

The script launches VS Code with the correct configuration.

### 5. Reopen in Container

When VS Code opens, you'll see a notification:

> **"Folder contains a Dev Container configuration file. Reopen folder to develop in a container"**

**Click "Reopen in Container"** or press `F1` and type `Dev Containers: Reopen in Container`

### 6. Wait for Build

First build takes 8-15 minutes depending on configuration.

**Click "show log"** to watch progress:
- Downloading base image
- Installing system packages
- Installing language tools
- Installing VS Code extensions
- Running post-create scripts

### 7. Container Ready!

When complete, you'll see:
- Bottom-left corner: **"Dev Container: AI DevContainer"** (green badge)
- Terminal opens to Ubuntu bash
- Extensions loaded

### 8. Test the Container

```bash
# Check OS
cat /etc/os-release

# Check Python (if Python/Full Stack config)
python3 --version
which pytest black pip

# Check Node.js (if Node.js/Full Stack config)
node --version
which npm eslint prettier

# Check Continue AI
code --list-extensions | grep continue
```

---

## Troubleshooting

### Build Fails

**Problem:** Container build fails with error

**Solutions:**
1. Check Docker Desktop is running
2. View build logs (click "show log")
3. Rebuild: `F1` -> `Dev Containers: Rebuild Container`
4. Clean build: `F1` -> `Dev Containers: Rebuild Container Without Cache`

### Docker Not Running

**Problem:** "Docker is not running" error

**Solution:**
1. Start Docker Desktop
2. Wait for Docker to fully start
3. Run script again

### VS Code Not Found

**Problem:** "VS Code not found in PATH" error

**Solution:**
1. Ensure VS Code is installed
2. Add VS Code to PATH:
   - Open VS Code
   - `F1` -> "Shell Command: Install 'code' command in PATH"
3. Restart PowerShell
4. Run script again

### Port Already in Use

**Problem:** Port 8000 already in use (for AI backend connection)

**Solution:**
```powershell
# Find what's using port 8000
netstat -ano | findstr :8000

# Stop the process or change port in config
```

### Container Won't Start

**Problem:** Container builds but won't start

**Solutions:**
1. Check Docker resources (Settings -> Resources)
   - Memory: 8 GB minimum
   - Disk: 20 GB minimum
2. Restart Docker Desktop
3. Clean up old containers:
   ```powershell
   docker container prune
   docker volume prune
   ```

### Extensions Not Loading

**Problem:** VS Code extensions not installed in container

**Solutions:**
1. Wait - extensions install after container starts (takes a few minutes)
2. Check extension logs: View -> Output -> select "Dev Containers"
3. Manually install: Extensions sidebar -> search and install
4. Rebuild container: `F1` -> `Dev Containers: Rebuild Container`

---

## Advanced Usage

### Using Environment Variables

Instead of the launcher, you can manually set the config:

```powershell
# Set config before opening VS Code
$env:DEVCONTAINER_CONFIG_FILE = ".devcontainer/configs/python.config.json"
code d:\Repos\ai-devcontainer

# Then: F1 -> "Reopen in Container"
```

### Switching Configurations

To switch to a different configuration:

1. Exit container: `F1` -> `Dev Containers: Reopen Folder Locally`
2. Close VS Code
3. Run launcher again with new choice
4. Or manually set new config:
   ```powershell
   $env:DEVCONTAINER_CONFIG_FILE = ".devcontainer/configs/fullstack.config.json"
   code d:\Repos\ai-devcontainer
   ```

### Custom Configuration File

Create your own config in `.devcontainer/configs/`:

```powershell
# In launcher, choose option 5
Enter your choice [1-5]: 5
Enter config file path: configs/mycustom.config.json
```

### Rebuild Container

When you change configuration or Dockerfile:

```
F1 -> Dev Containers: Rebuild Container
```

Options:
- **Rebuild** - Use cached layers (faster)
- **Rebuild Without Cache** - Fresh build (slower, ensures clean state)

---

## Configuration Files Reference

| Config File | Extensions | Languages | Use Case |
|------------|-----------|-----------|----------|
| `base.config.json` | 24 | None | Minimal, universal tools |
| `python.config.json` | 31 | Python 3.11 | AI/ML, backend, data science |
| `nodejs.config.json` | 29 | Node.js 20 | Web apps, frontend, API |
| `fullstack.config.json` | 36 | Python + Node.js | Full stack, microservices |

---

## What Gets Installed

### Base (All Configurations)

**Extensions (24):**
- Continue AI (`continue.continue`)
- GitLens, Git Graph
- Error Lens, TODO Tree
- SonarLint, Code Metrics
- Test Explorer, Coverage Gutters
- Markdown tools
- And more...

**Tools:**
- Git 2.x
- Docker-in-Docker
- curl, wget, jq
- vim, nano

### Python Configuration Adds

**Extensions (7):**
- Python, Pylance
- Black, isort, flake8
- Jupyter
- Ruff

**Tools:**
- Python 3.11
- pip, pytest
- black, isort, pylint
- mypy, loguru

### Node.js Configuration Adds

**Extensions (5):**
- ESLint, Prettier
- npm IntelliSense
- npm Scripts
- TypeScript

**Tools:**
- Node.js 20 LTS
- npm, yarn, pnpm
- Jest, ESLint, Prettier
- TypeScript, ts-node

### Full Stack Includes

Everything from Python + Node.js configurations.

---

## Performance Tips

### First Build

- **Be patient** - First build downloads images and installs everything
- **Watch logs** - Click "show log" to see progress
- **Don't cancel** - Let it complete, even if it seems stuck

### Subsequent Builds

- Use cached layers when possible
- Only rebuild without cache when needed
- Keep Docker resources sufficient (8 GB RAM, 20+ GB disk)

### Resource Allocation

Ensure Docker has enough resources in Docker Desktop settings:

- **Memory:** 8 GB minimum, 16 GB recommended
- **CPUs:** 4 cores minimum, 8 recommended
- **Disk:** 20 GB minimum, 50+ GB recommended

---

## Next Steps After Launch

1. **Test the environment**
   ```bash
   python3 --version
   node --version
   code --list-extensions
   ```

2. **Clone your project**
   ```bash
   git clone https://github.com/YourUsername/your-repo.git
   cd your-repo
   ```

3. **Install dependencies**
   ```bash
   # Python
   pip install -r requirements.txt
   
   # Node.js
   npm install
   ```

4. **Start developing with Continue AI**
   - Press `Ctrl+I` for inline suggestions
   - Select code and ask Continue questions
   - Use slash commands: `/test`, `/optimize`, `/refactor`

5. **Connect to self-hosted AI backend**
   - Ensure backend is running (see self-hosted-ai-continue repo)
   - Continue will automatically connect to `http://ai-backend:8000/v1`

---

## FAQ

**Q: How long does the first build take?**  
A: 8-15 minutes depending on configuration. Subsequent rebuilds are faster (2-5 minutes).

**Q: Can I use multiple configurations?**  
A: You can switch configurations by closing VS Code and running the launcher again.

**Q: Will my files persist?**  
A: Yes! Your workspace files are mounted from your host machine and persist.

**Q: Do installed Python/npm packages persist?**  
A: Only if you use volumes or rebuild. Best practice: use requirements.txt/package.json.

**Q: Can I customize the configurations?**  
A: Yes! Edit files in `.devcontainer/configs/` or create your own.

**Q: How do I update the container?**  
A: Pull latest code, then: `F1` -> `Dev Containers: Rebuild Container`

**Q: Can I access localhost from inside the container?**  
A: Yes! Ports are forwarded automatically. The container can access host services.

---

## Support

**Logs:**
- VS Code: View -> Output -> "Dev Containers"
- Docker: Docker Desktop -> Containers -> view logs

**Documentation:**
- DevContainers: https://code.visualstudio.com/docs/devcontainers/containers
- Continue AI: https://continue.dev/docs

**This Repository:**
- See `.devcontainer/` for configuration files
- See `docs/` for additional guides

---

**Created:** October 20, 2025  
**Repository:** ai-devcontainer  
**Script:** launch-devcontainer.ps1
