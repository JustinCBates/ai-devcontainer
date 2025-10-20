# GitHub Setup Guide

This guide will help you push your AI DevContainer repository to GitHub.

## 📋 Prerequisites

- Git installed and configured
- GitHub account
- Repository created on GitHub (or follow steps below)

## 🚀 Method 1: Using GitHub CLI (Recommended)

If you have GitHub CLI installed:

```bash
# Navigate to repository
cd d:\Repos\ai-devcontainer

# Create GitHub repository and push
gh repo create ai-devcontainer --public --source=. --push

# Or for private repository
gh repo create ai-devcontainer --private --source=. --push
```

## 🌐 Method 2: Using GitHub Website

### Step 1: Create Repository on GitHub

1. Go to [GitHub](https://github.com/new)
2. Set **Repository name**: `ai-devcontainer`
3. Add **Description**: 
   ```
   A portable, configuration-driven DevContainer for AI-powered development with Continue
   ```
4. Choose **Public** or **Private**
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click **Create repository**

### Step 2: Push to GitHub

```bash
# Navigate to repository
cd d:\Repos\ai-devcontainer

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/ai-devcontainer.git

# Push to GitHub
git push -u origin main
```

## 📝 Method 3: Manual Setup

### 1. Add Remote

```powershell
cd d:\Repos\ai-devcontainer

# HTTPS (easier, requires token)
git remote add origin https://github.com/YOUR_USERNAME/ai-devcontainer.git

# OR SSH (requires SSH key setup)
git remote add origin git@github.com:YOUR_USERNAME/ai-devcontainer.git
```

### 2. Verify Remote

```bash
git remote -v
```

Should show:
```
origin  https://github.com/YOUR_USERNAME/ai-devcontainer.git (fetch)
origin  https://github.com/YOUR_USERNAME/ai-devcontainer.git (push)
```

### 3. Push to GitHub

```bash
# Push main branch
git push -u origin main

# If you have other branches
git push --all
```

## 🏷️ Recommended Repository Settings

Once pushed, configure these settings on GitHub:

### About Section
- **Description**: A portable, configuration-driven DevContainer for AI-powered development with Continue
- **Website**: Link to your documentation or demo
- **Topics**: Add relevant tags:
  - `devcontainer`
  - `vscode`
  - `docker`
  - `ai`
  - `continue`
  - `development-environment`
  - `python`
  - `nodejs`
  - `configuration`

### Settings

1. **Enable Discussions** (Settings → General → Features)
2. **Enable Issues** (if not already enabled)
3. **Branch Protection** (Settings → Branches):
   - Require pull request reviews
   - Require status checks to pass
   - Enable "Do not allow bypassing the above settings"

### Additional Files

The following files have been created for GitHub:
- ✅ `.github/ISSUE_TEMPLATE/bug_report.md`
- ✅ `.github/ISSUE_TEMPLATE/feature_request.md`
- ✅ `.github/PULL_REQUEST_TEMPLATE.md`
- ✅ `.github/FUNDING.yml`
- ✅ `CONTRIBUTING.md`
- ✅ `CODE_OF_CONDUCT.md`

## 🎨 Customization

### Update Topics

```bash
# Using GitHub CLI
gh repo edit --add-topic devcontainer,vscode,docker,ai,continue
```

### Add Repository Description

```bash
# Using GitHub CLI
gh repo edit --description "A portable, configuration-driven DevContainer for AI-powered development with Continue"
```

### Enable Features

```bash
# Enable Discussions
gh repo edit --enable-discussions

# Enable Issues
gh repo edit --enable-issues

# Enable Wiki
gh repo edit --enable-wiki
```

## 🔒 Authentication Issues?

### Personal Access Token (PAT)

If pushing fails with authentication errors:

1. **Generate PAT**: 
   - Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Generate new token with `repo` scope
   - Copy the token

2. **Use token as password**:
   ```bash
   git push -u origin main
   Username: YOUR_USERNAME
   Password: YOUR_PERSONAL_ACCESS_TOKEN
   ```

3. **Cache credentials** (Windows):
   ```bash
   git config --global credential.helper manager-core
   ```

### SSH Key Setup

For SSH authentication:

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to ssh-agent
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub
```

Then add the public key to GitHub:
- GitHub Settings → SSH and GPG keys → New SSH key

## ✅ Verification

After pushing, verify:

1. **Repository is visible** at `https://github.com/YOUR_USERNAME/ai-devcontainer`
2. **All files are present** (37 files)
3. **README displays correctly** with badges
4. **Documentation is accessible** in `/docs` folder
5. **Issues and PR templates work**

## 🎉 Next Steps

Once your repository is on GitHub:

1. **Share with team**: Invite collaborators
2. **Set up CI/CD**: Add GitHub Actions workflows
3. **Create releases**: Tag versions for stable releases
4. **Enable GitHub Pages**: Host documentation
5. **Monitor activity**: Watch stars, forks, and issues

## 📞 Need Help?

- Check [Git documentation](https://git-scm.com/doc)
- See [GitHub docs](https://docs.github.com)
- Review [CONTRIBUTING.md](../CONTRIBUTING.md)

---

**Ready to push?** Follow the methods above and your repository will be live on GitHub! 🚀
