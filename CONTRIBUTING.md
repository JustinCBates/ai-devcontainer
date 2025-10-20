# Contributing to AI DevContainer

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## 🌟 Ways to Contribute

- 🐛 Report bugs
- ✨ Suggest new features or extensions
- 📚 Improve documentation
- 🔧 Submit pull requests
- 💬 Help others in discussions

## 🚀 Getting Started

### Prerequisites

- Docker Desktop installed and running
- VS Code with Dev Containers extension
- Git for version control
- Basic understanding of DevContainers

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/ai-devcontainer.git
   cd ai-devcontainer
   ```

2. **Open in DevContainer**
   - Open the folder in VS Code
   - Press `F1` → "Dev Containers: Reopen in Container"
   - Wait for setup to complete

3. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 Contribution Guidelines

### Code Style

- Follow existing code formatting
- Use meaningful variable and function names
- Add comments for complex logic
- Keep JSON files properly formatted

### Configuration Changes

When modifying configuration files:

1. **Test thoroughly** in a DevContainer
2. **Validate JSON syntax** using the validation script
3. **Update documentation** to reflect changes
4. **Check compatibility** with all config types (base, python, nodejs, fullstack)

### Extension Additions

To add a new extension:

1. Add to appropriate section in `base.config.json` or language-specific config
2. Update the extension count in documentation
3. Add to the relevant feature section
4. Test that it installs and works correctly
5. Update `docs/COMPLETE_ENVIRONMENT.md`

### Documentation

- Update relevant `.md` files in `/docs`
- Keep README.md current
- Add inline comments in configuration files
- Update BACKLOG.md if applicable

## 🧪 Testing

Before submitting:

1. **Run Validation Script**
   ```powershell
   .\validate.ps1
   ```

2. **Test in Container**
   - Build the DevContainer
   - Verify all extensions load
   - Test key features work

3. **Check Documentation**
   - Ensure all links work
   - Verify code examples are correct
   - Check formatting renders properly

## 📋 Pull Request Process

1. **Update Documentation**
   - Add/update relevant docs
   - Update CHANGELOG if applicable

2. **Commit Message Format**
   Use [Conventional Commits](https://www.conventionalcommits.org/):
   ```
   feat: add new extension for X
   fix: resolve issue with Y configuration
   docs: update setup instructions
   chore: update dependencies
   ```

3. **Submit PR**
   - Provide clear description
   - Link related issues
   - Add screenshots if UI changes
   - Check all boxes in PR template

4. **Code Review**
   - Respond to feedback promptly
   - Make requested changes
   - Keep PR focused and small

## 🐛 Reporting Bugs

Use the bug report template and include:

- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Relevant logs or screenshots
- Configuration type being used

## 💡 Suggesting Features

Use the feature request template and include:

- Problem it solves
- Proposed solution
- Alternative approaches
- Implementation ideas
- Examples from other projects

## 📜 Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Assume good intentions
- Help others learn and grow

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Personal attacks
- Publishing others' private information
- Other unprofessional conduct

## 🏷️ Labels and Milestones

We use labels to categorize issues:

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Documentation improvements
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `question` - Further information requested

## 📞 Getting Help

- 📖 Check documentation in `/docs`
- 💬 Open a discussion for questions
- 🐛 Create an issue for bugs
- 📧 Contact maintainers for sensitive issues

## 🙏 Recognition

Contributors will be:

- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in relevant documentation

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing! 🎉
