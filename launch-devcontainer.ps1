# AI DevContainer Interactive Launcher
# ASCII encoding - no Unicode characters

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "        AI DevContainer Interactive Launcher" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check Docker
try {
    docker info | Out-Null
    Write-Host "  [OK] Docker is running" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Check VS Code
$vscodePath = Get-Command code -ErrorAction SilentlyContinue
if ($vscodePath) {
    Write-Host "  [OK] VS Code is installed" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] VS Code not found in PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host ""
Write-Host "Select your DevContainer configuration:" -ForegroundColor Cyan
Write-Host ""

# Configuration options
Write-Host "  [1] Base Configuration" -ForegroundColor White
Write-Host "      - 24 universal extensions" -ForegroundColor Gray
Write-Host "      - Git, linting, testing, AI assistance" -ForegroundColor Gray
Write-Host "      - No language-specific tools" -ForegroundColor Gray
Write-Host "      - Best for: Minimal setup, scripts, configs" -ForegroundColor Gray
Write-Host ""

Write-Host "  [2] Python Configuration (RECOMMENDED for AI work)" -ForegroundColor White
Write-Host "      - 31 extensions (24 universal + 7 Python)" -ForegroundColor Gray
Write-Host "      - Python 3.11, pytest, Jupyter, Loguru" -ForegroundColor Gray
Write-Host "      - Best for: AI/ML, backend, data science" -ForegroundColor Gray
Write-Host ""

Write-Host "  [3] Node.js Configuration" -ForegroundColor White
Write-Host "      - 29 extensions (24 universal + 5 Node.js)" -ForegroundColor Gray
Write-Host "      - Node.js 20, Jest, ESLint, Prettier" -ForegroundColor Gray
Write-Host "      - Best for: Web apps, React, API development" -ForegroundColor Gray
Write-Host ""

Write-Host "  [4] Full Stack Configuration" -ForegroundColor White
Write-Host "      - 36 extensions (24 universal + 12 language)" -ForegroundColor Gray
Write-Host "      - Python 3.11 + Node.js 20" -ForegroundColor Gray
Write-Host "      - Best for: Full stack apps, microservices" -ForegroundColor Gray
Write-Host ""

Write-Host "  [5] Custom Configuration" -ForegroundColor White
Write-Host "      - Specify your own config file path" -ForegroundColor Gray
Write-Host ""

# Get user choice
$choice = Read-Host "Enter your choice [1-5]"

# Map choice to config
$configName = ""
$configPath = ""
$description = ""
$buildTime = ""
$extensions = ""

switch ($choice) {
    "1" {
        $configName = "Base"
        $configPath = ".devcontainer/configs/base.config.json"
        $description = "Minimal setup with universal tools"
        $buildTime = "5-7 minutes"
        $extensions = "24 extensions"
    }
    "2" {
        $configName = "Python"
        $configPath = ".devcontainer/configs/python.config.json"
        $description = "Python 3.11 with AI/ML tools"
        $buildTime = "8-10 minutes"
        $extensions = "31 extensions"
    }
    "3" {
        $configName = "Node.js"
        $configPath = ".devcontainer/configs/nodejs.config.json"
        $description = "Node.js 20 with web development tools"
        $buildTime = "8-10 minutes"
        $extensions = "29 extensions"
    }
    "4" {
        $configName = "Full Stack"
        $configPath = ".devcontainer/configs/fullstack.config.json"
        $description = "Python 3.11 + Node.js 20 with all tools"
        $buildTime = "12-15 minutes"
        $extensions = "36 extensions"
    }
    "5" {
        $configPath = Read-Host "Enter config file path (relative to .devcontainer/)"
        $configName = "Custom"
        $description = "User-specified configuration"
        $buildTime = "Variable"
        $extensions = "Variable"
    }
    default {
        Write-Host ""
        Write-Host "Invalid choice. Exiting." -ForegroundColor Red
        exit 1
    }
}

# Verify config file exists
if (-not (Test-Path "$PSScriptRoot\$configPath")) {
    Write-Host ""
    Write-Host "Error: Config file not found: $configPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Show selection
Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "You selected: $configName Configuration" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Configuration: $description" -ForegroundColor White
Write-Host "Extensions: $extensions" -ForegroundColor White
Write-Host "Build time: $buildTime (first time)" -ForegroundColor White
Write-Host ""
Write-Host "This will:" -ForegroundColor Cyan
Write-Host "  - Build Ubuntu 22.04 container" -ForegroundColor White
if ($choice -eq "2" -or $choice -eq "4") {
    Write-Host "  - Install Python 3.11" -ForegroundColor White
}
if ($choice -eq "3" -or $choice -eq "4") {
    Write-Host "  - Install Node.js 20" -ForegroundColor White
}
Write-Host "  - Install $extensions" -ForegroundColor White
Write-Host "  - Configure Continue AI" -ForegroundColor White
Write-Host "  - Set up development tools" -ForegroundColor White
Write-Host ""

# Confirm
$confirm = Read-Host "Continue? [Y/n]"
if ($confirm -eq "n" -or $confirm -eq "N") {
    Write-Host ""
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

# Set environment variable
$env:DEVCONTAINER_CONFIG_FILE = $configPath

Write-Host ""
Write-Host "Launching VS Code with $configName configuration..." -ForegroundColor Yellow
Write-Host ""

# Launch VS Code
Set-Location $PSScriptRoot
Start-Process code -ArgumentList "." -NoNewWindow

# Wait a moment for VS Code to start
Start-Sleep -Seconds 2

# Show next steps
Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "        Next Steps" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "VS Code is opening. When it starts:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Look for notification in bottom-right corner" -ForegroundColor White
Write-Host "   'Folder contains a Dev Container configuration file.'" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Click 'Reopen in Container'" -ForegroundColor White
Write-Host "   OR" -ForegroundColor Gray
Write-Host "   Press F1 and type: Dev Containers: Reopen in Container" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Wait for build ($buildTime first time)" -ForegroundColor White
Write-Host "   - Click 'show log' to watch progress" -ForegroundColor Gray
Write-Host "   - Green 'Dev Container' badge appears when ready" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Once inside container, test it:" -ForegroundColor White
if ($choice -eq "2" -or $choice -eq "4") {
    Write-Host "   python3 --version" -ForegroundColor Gray
    Write-Host "   which pytest black pip" -ForegroundColor Gray
}
if ($choice -eq "3" -or $choice -eq "4") {
    Write-Host "   node --version" -ForegroundColor Gray
    Write-Host "   which npm eslint prettier" -ForegroundColor Gray
}
Write-Host ""
Write-Host "5. Start coding with Continue AI!" -ForegroundColor White
Write-Host "   - Press Ctrl+I for AI assistance" -ForegroundColor Gray
Write-Host "   - Type code and get completions" -ForegroundColor Gray
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Configuration file: $configPath" -ForegroundColor Gray
Write-Host "Working directory: $PSScriptRoot" -ForegroundColor Gray
Write-Host ""
Write-Host "Troubleshooting:" -ForegroundColor Cyan
Write-Host "  - If build fails: F1 -> 'Dev Containers: Rebuild Container'" -ForegroundColor Gray
Write-Host "  - View logs: Click 'show log' in notification" -ForegroundColor Gray
Write-Host "  - Check Docker: Make sure Docker Desktop is running" -ForegroundColor Gray
Write-Host ""
Write-Host "Press any key to exit this script..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
