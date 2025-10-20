# Example Python Project with AI DevContainer

This is a sample Python project demonstrating the AI DevContainer configuration system.

## What's Included

### Automatic Setup (via python.config.json)
- ✅ **Continue AI** - Press Ctrl+I for AI assistance
- ✅ **Logging** - Loguru configured with structured logging
- ✅ **Linting** - Black, isort, flake8, pylint
- ✅ **Testing** - pytest with coverage
- ✅ **Git** - Pre-commit hooks and aliases
- ✅ **VS Code** - Python extension, Jupyter, debugger

### Try Continue AI

1. Open `hello.py`
2. Select some code
3. Press `Ctrl+I` (or `Cmd+I`)
4. Try these commands:
   - `/test` - Generate tests
   - `/optimize` - Optimize code
   - `/explain` - Explain code
   - `/refactor` - Refactor code

### Try Logging

```python
from loguru import logger

logger.debug("Debug message")
logger.info("Info message")
logger.warning("Warning message")
logger.error("Error message")
```

Logs appear in:
- Console (colorized)
- File: `logs/app.log` (production mode)

### Try Testing

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=. --cov-report=html

# View coverage report
open htmlcov/index.html
```

### Try Linting

```bash
# Format code
black .
isort .

# Check code
flake8 .
pylint *.py
```

Or just save a file - auto-format is enabled!

## Custom Configuration

Want different tools? Edit `.devcontainer/configs/python.config.json`:

```json
{
  "features": {
    "logging": {
      "level": "DEBUG"  // Change log level
    },
    "linting": {
      "tools": {
        "python": ["black", "isort"]  // Use only these tools
      }
    }
  }
}
```

Then reload:
```bash
reload-config
```

## Next Steps

1. Replace `hello.py` with your actual code
2. Add dependencies to `requirements.txt`
3. Write tests in `tests/`
4. Use Continue AI for assistance
5. Commit and push!

Happy coding with AI! 🚀