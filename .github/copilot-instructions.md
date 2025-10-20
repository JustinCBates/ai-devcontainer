# Copilot Instructions for AI DevContainer Project

This project provides a configuration-driven DevContainer system for AI-powered development with the Continue extension.

## Project Overview
- **Purpose**: Portable, configurable development environments
- **Core Feature**: Continue AI integration in every configuration
- **Architecture**: Config files + loader script + DevContainer
- **Languages**: Bash (scripts), JSON (configs)

## Development Guidelines

### Configuration Files
- All configs are in `.devcontainer/configs/`
- Must follow the schema in `CONFIG_GUIDE.md`
- Use `"extends"` for inheritance
- Always include Continue configuration
- Document all new features

### Scripts
- Use bash for portability
- Include error handling with `set -e`
- Add logging with echo statements
- Test on both Linux and macOS
- Comment complex logic

### Documentation
- Keep all .md files updated
- Add examples for new features
- Update QUICK_REFERENCE.md for new commands
- Include troubleshooting tips

### Testing
- Test new configs in actual DevContainers
- Verify extension installation
- Check Continue integration works
- Validate environment variables
- Test on different OS (Windows, Linux, macOS)

## Key Principles

1. **Continue First**: Every config must enable Continue AI
2. **Logging Standard**: Include logging in all language configs
3. **Linting Standard**: Include linting/formatting in all configs
4. **Reusability**: Configs should extend base.config.json
5. **Flexibility**: Easy to switch between configs
6. **Documentation**: Every feature must be documented

## File Structure
```
.devcontainer/
├── configs/           # Configuration files (JSON)
├── scripts/          # Helper scripts (Bash)
├── *.sh              # Lifecycle scripts
└── devcontainer.json # DevContainer definition
```

## Adding New Configurations

1. Create config in `.devcontainer/configs/`
2. Extend `base.config.json`
3. Add language-specific extensions
4. Configure logging library
5. Add to CONFIG_GUIDE.md
6. Test in container

## Common Patterns

- All configs must have Continue enabled
- All configs must have logging enabled
- All configs must have linting enabled
- Use semantic names for configs
- Document environment variables
- Include example usage