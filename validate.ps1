# Simple DevContainer Validation Script
# Quick validation of DevContainer setup

Write-Host "`n===== DevContainer Configuration Validation =====" -ForegroundColor Cyan
Write-Host "Testing directory: d:\Repos\ai-devcontainer`n" -ForegroundColor Gray

$passed = 0
$failed = 0

# Test 1: Check critical files
Write-Host "[1] Checking critical files..." -ForegroundColor Yellow
$files = @(
    ".devcontainer\devcontainer.json",
    ".devcontainer\Dockerfile",
    ".devcontainer\docker-compose.yml",
    ".devcontainer\configs\base.config.json",
    ".devcontainer\configs\python.config.json"
)

foreach ($file in $files) {
    $path = "d:\Repos\ai-devcontainer\$file"
    if (Test-Path $path) {
        $passed++
        Write-Host "  ✓ $file" -ForegroundColor Green
    }
    else {
        $failed++
        Write-Host "  ✗ $file MISSING" -ForegroundColor Red
    }
}

# Test 2: Validate JSON files
Write-Host "`n[2] Validating JSON syntax..." -ForegroundColor Yellow
$jsonFiles = @(
    ".devcontainer\configs\base.config.json",
    ".devcontainer\configs\python.config.json",
    ".devcontainer\configs\nodejs.config.json"
)

foreach ($file in $jsonFiles) {
    $path = "d:\Repos\ai-devcontainer\$file"
    if (Test-Path $path) {
        try {
            $content = Get-Content $path -Raw
            # Remove comments
            $content = $content -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
            $null = $content | ConvertFrom-Json
            $passed++
            Write-Host "  ✓ $file" -ForegroundColor Green
        }
        catch {
            $failed++
            Write-Host "  ✗ $file INVALID JSON" -ForegroundColor Red
        }
    }
}

# Test 3: Check extension count
Write-Host "`n[3] Checking extension configuration..." -ForegroundColor Yellow
$baseConfigPath = "d:\Repos\ai-devcontainer\.devcontainer\configs\base.config.json"
if (Test-Path $baseConfigPath) {
    try {
        $content = Get-Content $baseConfigPath -Raw
        $content = $content -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
        $config = $content | ConvertFrom-Json
        $extCount = $config.extensions.required.Count
        Write-Host "  Found $extCount extensions" -ForegroundColor Cyan
        
        if ($extCount -ge 24) {
            $passed++
            Write-Host "  ✓ Extension count OK (expected 24)" -ForegroundColor Green
        }
        else {
            $failed++
            Write-Host "  ✗ Expected 24 extensions, found $extCount" -ForegroundColor Red
        }
        
        # Check critical extensions
        $critical = @("continue.continue", "SonarSource.sonarlint-vscode", 
                     "hbenl.vscode-test-explorer", "ryanluker.vscode-coverage-gutters")
        $missing = @()
        foreach ($ext in $critical) {
            if ($config.extensions.required -notcontains $ext) {
                $missing += $ext
            }
        }
        
        if ($missing.Count -eq 0) {
            $passed++
            Write-Host "  ✓ All critical extensions present" -ForegroundColor Green
        }
        else {
            $failed++
            Write-Host "  ✗ Missing: $($missing -join ', ')" -ForegroundColor Red
        }
    }
    catch {
        $failed++
        Write-Host "  ✗ Cannot parse base.config.json" -ForegroundColor Red
    }
}

# Test 4: Check feature sections
Write-Host "`n[4] Checking feature sections..." -ForegroundColor Yellow
if (Test-Path $baseConfigPath) {
    try {
        $content = Get-Content $baseConfigPath -Raw
        $content = $content -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
        $config = $content | ConvertFrom-Json
        
        $features = @("continue", "logging", "testing", "codeQuality", "workflow")
        $missing = @()
        foreach ($feat in $features) {
            if (-not $config.features.PSObject.Properties[$feat]) {
                $missing += $feat
            }
        }
        
        if ($missing.Count -eq 0) {
            $passed++
            Write-Host "  ✓ All key features configured" -ForegroundColor Green
        }
        else {
            $failed++
            Write-Host "  ✗ Missing features: $($missing -join ', ')" -ForegroundColor Red
        }
    }
    catch {
        $failed++
        Write-Host "  ✗ Cannot verify features" -ForegroundColor Red
    }
}

# Test 5: Check documentation
Write-Host "`n[5] Checking documentation..." -ForegroundColor Yellow
$docs = @(
    "README.md",
    "docs\COMPLETE_ENVIRONMENT.md",
    "docs\TESTING_COVERAGE_ANALYSIS.md",
    "BACKLOG.md"
)

foreach ($doc in $docs) {
    $path = "d:\Repos\ai-devcontainer\$doc"
    if (Test-Path $path) {
        $passed++
        Write-Host "  ✓ $doc" -ForegroundColor Green
    }
    else {
        Write-Host "  ⚠ $doc missing" -ForegroundColor Yellow
    }
}

# Summary
Write-Host "`n=================================================" -ForegroundColor Cyan
Write-Host "RESULTS:" -ForegroundColor Cyan
Write-Host "  Passed: $passed" -ForegroundColor Green
Write-Host "  Failed: $failed" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })
Write-Host "=================================================" -ForegroundColor Cyan

if ($failed -eq 0) {
    Write-Host "`n✓ Configuration is VALID and ready to use!`n" -ForegroundColor Green
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Ensure Docker Desktop is running"
    Write-Host "  2. Open this folder in VS Code"
    Write-Host "  3. Install 'Dev Containers' extension"
    Write-Host "  4. Command Palette → 'Dev Containers: Reopen in Container'"
    Write-Host "  5. Wait for setup (first time: 5-10 minutes)"
    Write-Host "  6. Start coding!`n"
    
    Write-Host "Configuration includes:" -ForegroundColor Cyan
    Write-Host "  • 24 universal extensions"
    Write-Host "  • AI assistance (Continue)"
    Write-Host "  • Testing & coverage tools"
    Write-Host "  • Code quality analysis (SonarLint)"
    Write-Host "  • Workflow automation"
    Write-Host "  • Security scanning`n"
}
else {
    Write-Host "`n✗ Some validation checks failed. Please review above.`n" -ForegroundColor Red
}
