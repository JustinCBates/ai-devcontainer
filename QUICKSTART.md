# AI DevContainer - Quick Reference

## Launch the DevContainer

```powershell
cd d:\Repos\ai-devcontainer
.\launch-devcontainer.ps1
```

## What You Get

### Base Configuration (24 extensions)
- Universal development tools
- Continue AI assistance
- Git, linting, testing

### Python Configuration (31 extensions) - RECOMMENDED for AI
- Base + Python 3.11
- pytest, Jupyter, Loguru
- Black, isort, flake8

### Node.js Configuration (29 extensions)
- Base + Node.js 20
- Jest, ESLint, Prettier
- npm/yarn/pnpm

### Full Stack Configuration (36 extensions)
- Base + Python + Node.js
- All development tools
- Best for full stack projects

## First Time Setup

1. Run launcher: `.\launch-devcontainer.ps1`
2. Select configuration (option 2 recommended)
3. Wait for VS Code to open
4. Click "Reopen in Container"
5. Wait 8-15 minutes for build
6. Start coding!

## Quick Commands

### In VS Code (after container opens)

```bash
# Check Python
python3 --version

# Check Node.js
node --version

# List extensions
code --list-extensions | grep continue

# Test Continue AI
# Press Ctrl+I for AI assistance
```

### Rebuild Container

```
F1 -> Dev Containers: Rebuild Container
```

### View Logs

```
F1 -> Dev Containers: Show Container Log
```

### Exit Container

```
F1 -> Dev Containers: Reopen Folder Locally
```

## Troubleshooting

**Build fails?**
- Check Docker Desktop is running
- Click "show log" to see errors
- Try: F1 -> "Rebuild Container Without Cache"

**Extensions not loading?**
- Wait a few minutes after container starts
- Check: View -> Output -> "Dev Containers"

**Need more help?**
- See `docs/LAUNCH_GUIDE.md` for detailed guide
- Check Docker Desktop -> Containers for logs

## Files Created

- `launch-devcontainer.ps1` - Interactive launcher script
- `docs/LAUNCH_GUIDE.md` - Comprehensive documentation

## Next Steps

After container is running:

1. Clone your project inside the container
2. Install dependencies (`pip install`, `npm install`)
3. Start coding with Continue AI assistance
4. Connect to self-hosted AI backend (if running)

---

**Questions?** Check `docs/LAUNCH_GUIDE.md` for detailed walkthrough!
