# DevContainer Test Suite (PowerShell Version)
# Validates the complete DevContainer setup

param(
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Continue"

# Colors for output (PowerShell)
function Write-Header {
    param([string]$Message)
    Write-Host "`n============================================================================================================" -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Blue
    Write-Host "============================================================================================================`n" -ForegroundColor Blue
}

function Write-TestStart {
    param([string]$Message)
    $script:TestsRun++
    Write-Host "[TEST $script:TestsRun] " -NoNewline -ForegroundColor Yellow
    Write-Host $Message
}

function Write-TestPass {
    param([string]$Message)
    $script:TestsPassed++
    Write-Host "✓ PASS " -NoNewline -ForegroundColor Green
    Write-Host "$Message`n"
}

function Write-TestFail {
    param(
        [string]$Message,
        [string]$Error = ""
    )
    $script:TestsFailed++
    Write-Host "✗ FAIL " -NoNewline -ForegroundColor Red
    Write-Host $Message
    if ($Error) {
        Write-Host "  Error: $Error`n" -ForegroundColor Red
    }
}

# Test counters
$script:TestsRun = 0
$script:TestsPassed = 0
$script:TestsFailed = 0

# Paths
$ProjectRoot = Split-Path -Parent $PSScriptRoot
if (-not $ProjectRoot) { $ProjectRoot = "d:\Repos\ai-devcontainer" }
$DevContainerDir = Join-Path $ProjectRoot ".devcontainer"
$ConfigDir = Join-Path $DevContainerDir "configs"
$ScriptsDir = Join-Path $DevContainerDir "scripts"
$DocsDir = Join-Path $ProjectRoot "docs"

# Start tests
Write-Header "DevContainer Configuration Test Suite"
Write-Host "Testing directory: $DevContainerDir"
Write-Host "Started: $(Get-Date)"
Write-Host ""

# ============================================================================
# Test 1: Directory Structure
# ============================================================================
Write-Header "Test 1: Directory Structure"

Write-TestStart "Check .devcontainer directory exists"
if (Test-Path $DevContainerDir -PathType Container) {
    Write-TestPass "Directory exists: $DevContainerDir"
} else {
    Write-TestFail "Directory missing: $DevContainerDir"
}

Write-TestStart "Check configs directory exists"
if (Test-Path $ConfigDir -PathType Container) {
    Write-TestPass "Directory exists: $ConfigDir"
} else {
    Write-TestFail "Directory missing: $ConfigDir"
}

Write-TestStart "Check scripts directory exists"
if (Test-Path $ScriptsDir -PathType Container) {
    Write-TestPass "Directory exists: $ScriptsDir"
} else {
    Write-TestFail "Directory missing: $ScriptsDir"
}

Write-TestStart "Check docs directory exists"
if (Test-Path $DocsDir -PathType Container) {
    Write-TestPass "Directory exists: $DocsDir"
} else {
    Write-TestFail "Directory missing: $DocsDir"
}

# ============================================================================
# Test 2: Required Files
# ============================================================================
Write-Header "Test 2: Required Files"

$RequiredFiles = @(
    (Join-Path $DevContainerDir "devcontainer.json"),
    (Join-Path $DevContainerDir "Dockerfile"),
    (Join-Path $DevContainerDir "docker-compose.yml"),
    (Join-Path $DevContainerDir "post-create.sh"),
    (Join-Path $DevContainerDir "post-start.sh"),
    (Join-Path $ScriptsDir "load-config.sh"),
    (Join-Path $ConfigDir "base.config.json"),
    (Join-Path $ConfigDir "python.config.json"),
    (Join-Path $ConfigDir "nodejs.config.json"),
    (Join-Path $ConfigDir "fullstack.config.json")
)

foreach ($file in $RequiredFiles) {
    $filename = Split-Path $file -Leaf
    Write-TestStart "Check file exists: $filename"
    if (Test-Path $file -PathType Leaf) {
        Write-TestPass "File exists and is readable"
    } else {
        Write-TestFail "File missing or not readable: $file"
    }
}

# ============================================================================
# Test 3: JSON Configuration Validation
# ============================================================================
Write-Header "Test 3: JSON Configuration Validation"

$ConfigFiles = @(
    (Join-Path $DevContainerDir "devcontainer.json"),
    (Join-Path $ConfigDir "base.config.json"),
    (Join-Path $ConfigDir "python.config.json"),
    (Join-Path $ConfigDir "nodejs.config.json"),
    (Join-Path $ConfigDir "fullstack.config.json")
)

foreach ($config in $ConfigFiles) {
    if (Test-Path $config) {
        $configName = Split-Path $config -Leaf
        Write-TestStart "Validate JSON syntax: $configName"
        try {
            # Read and parse JSON
            $jsonContent = Get-Content $config -Raw
            # Remove comments for JSON validation (JSONC to JSON)
            $jsonContent = $jsonContent -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
            $null = $jsonContent | ConvertFrom-Json
            Write-TestPass "Valid JSON"
        } catch {
            Write-TestFail "Invalid JSON" $_.Exception.Message
        }
    }
}

# ============================================================================
# Test 4: Extension Configuration
# ============================================================================
Write-Header "Test 4: Extension Configuration"

Write-TestStart "Count extensions in base.config.json"
$baseConfigPath = Join-Path $ConfigDir "base.config.json"
if (Test-Path $baseConfigPath) {
    try {
        $jsonContent = Get-Content $baseConfigPath -Raw
        $jsonContent = $jsonContent -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
        $baseConfig = $jsonContent | ConvertFrom-Json
        $extCount = 0
        if ($baseConfig.extensions.required) {
            $extCount = $baseConfig.extensions.required.Count
        }
        if ($extCount -ge 24) {
            Write-TestPass "Found $extCount extensions (expected 24)"
        } else {
            Write-TestFail "Found only $extCount extensions (expected 24)"
        }
    } catch {
        Write-TestFail "Cannot parse base.config.json" $_.Exception.Message
    }
} else {
    Write-TestFail "base.config.json not found"
}

Write-TestStart "Verify critical extensions are present"
$CriticalExtensions = @(
    "continue.continue",
    "SonarSource.sonarlint-vscode",
    "hbenl.vscode-test-explorer",
    "ryanluker.vscode-coverage-gutters",
    "eamodio.gitlens",
    "snyk-security.snyk-vulnerability-scanner",
    "mhutchie.git-graph",
    "GitHub.vscode-pull-request-github"
)

if (Test-Path $baseConfigPath) {
    try {
        $jsonContent = Get-Content $baseConfigPath -Raw
        $jsonContent = $jsonContent -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
        $baseConfig = $jsonContent | ConvertFrom-Json
        $missingExtensions = @()
        
        foreach ($ext in $CriticalExtensions) {
            if ($baseConfig.extensions.required -notcontains $ext) {
                $missingExtensions += $ext
            }
        }
        
        if ($missingExtensions.Count -eq 0) {
            Write-TestPass "All $($CriticalExtensions.Count) critical extensions found"
        } else {
            Write-TestFail "Missing critical extensions: $($missingExtensions -join ', ')"
        }
    } catch {
        Write-TestFail "Cannot verify extensions" $_.Exception.Message
    }
} else {
    Write-TestFail "Cannot verify extensions (base.config.json missing)"
}

# ============================================================================
# Test 5: Feature Configuration
# ============================================================================
Write-Header "Test 5: Feature Configuration"

$ExpectedFeatures = @(
    "continue",
    "logging",
    "linting",
    "testing",
    "git",
    "documentation",
    "dependencies",
    "workflow",
    "codeQuality",
    "security"
)

Write-TestStart "Verify feature sections in base.config.json"
if (Test-Path $baseConfigPath) {
    try {
        $jsonContent = Get-Content $baseConfigPath -Raw
        $jsonContent = $jsonContent -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
        $baseConfig = $jsonContent | ConvertFrom-Json
        $missingFeatures = @()
        
        foreach ($feature in $ExpectedFeatures) {
            $featureProperty = $baseConfig.features.PSObject.Properties[$feature]
            if (-not $featureProperty) {
                $missingFeatures += $feature
            }
        }
        
        if ($missingFeatures.Count -eq 0) {
            Write-TestPass "All $($ExpectedFeatures.Count) feature sections found"
        } else {
            Write-TestFail "Missing feature sections: $($missingFeatures -join ', ')"
        }
    } catch {
        Write-TestFail "Cannot verify features" $_.Exception.Message
    }
} else {
    Write-TestFail "Cannot verify features"
}

# ============================================================================
# Test 6: Environment Variables
# ============================================================================
Write-Header "Test 6: Environment Variables"

Write-TestStart "Check environment variable definitions"
if (Test-Path $baseConfigPath) {
    try {
        $jsonContent = Get-Content $baseConfigPath -Raw
        $jsonContent = $jsonContent -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
        $baseConfig = $jsonContent | ConvertFrom-Json
        $envCount = 0
        if ($baseConfig.environment) {
            $envCount = ($baseConfig.environment.PSObject.Properties | Measure-Object).Count
        }
        if ($envCount -ge 37) {
            Write-TestPass "Found $envCount environment variables (expected 37+)"
        } else {
            Write-TestFail "Found only $envCount environment variables (expected 37+)"
        }
    } catch {
        Write-TestFail "Cannot verify environment variables" $_.Exception.Message
    }
} else {
    Write-TestFail "Cannot verify environment variables"
}

# ============================================================================
# Test 7: Docker Configuration
# ============================================================================
Write-Header "Test 7: Docker Configuration"

Write-TestStart "Validate Dockerfile"
$dockerfilePath = Join-Path $DevContainerDir "Dockerfile"
if (Test-Path $dockerfilePath) {
    $content = Get-Content $dockerfilePath -Raw
    if ($content -match "FROM mcr.microsoft.com/devcontainers/python") {
        Write-TestPass "Dockerfile has correct base image"
    } else {
        Write-TestFail "Dockerfile base image not found"
    }
} else {
    Write-TestFail "Dockerfile not found"
}

Write-TestStart "Validate docker-compose.yml"
$composeFile = Join-Path $DevContainerDir "docker-compose.yml"
if (Test-Path $composeFile) {
    $content = Get-Content $composeFile -Raw
    if (($content -match "devcontainer:") -and ($content -match "ai-backend:")) {
        Write-TestPass "docker-compose.yml has required services"
    } else {
        Write-TestFail "docker-compose.yml missing required services"
    }
} else {
    Write-TestFail "docker-compose.yml not found"
}

# ============================================================================
# Test 8: Configuration Inheritance
# ============================================================================
Write-Header "Test 8: Configuration Inheritance"

Write-TestStart "Verify python.config.json extends base"
$pythonConfigPath = Join-Path $ConfigDir "python.config.json"
if (Test-Path $pythonConfigPath) {
    try {
        $jsonContent = Get-Content $pythonConfigPath -Raw
        $jsonContent = $jsonContent -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
        $pythonConfig = $jsonContent | ConvertFrom-Json
        if ($pythonConfig.extends) {
            Write-TestPass "python.config.json extends base config"
        } else {
            Write-TestFail "python.config.json missing 'extends' field"
        }
    } catch {
        Write-TestFail "Cannot verify inheritance" $_.Exception.Message
    }
} else {
    Write-TestFail "Cannot verify inheritance (file missing)"
}

Write-TestStart "Verify nodejs.config.json extends base"
$nodejsConfigPath = Join-Path $ConfigDir "nodejs.config.json"
if (Test-Path $nodejsConfigPath) {
    try {
        $jsonContent = Get-Content $nodejsConfigPath -Raw
        $jsonContent = $jsonContent -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
        $nodejsConfig = $jsonContent | ConvertFrom-Json
        if ($nodejsConfig.extends) {
            Write-TestPass "nodejs.config.json extends base config"
        } else {
            Write-TestFail "nodejs.config.json missing 'extends' field"
        }
    } catch {
        Write-TestFail "Cannot verify inheritance" $_.Exception.Message
    }
} else {
    Write-TestFail "Cannot verify inheritance (file missing)"
}

# ============================================================================
# Test 9: Documentation
# ============================================================================
Write-Header "Test 9: Documentation"

$DocFiles = @(
    (Join-Path $ProjectRoot "README.md"),
    (Join-Path $DocsDir "CONFIG_GUIDE.md"),
    (Join-Path $DocsDir "ARCHITECTURE.md"),
    (Join-Path $DocsDir "COMPLETE_ENVIRONMENT.md"),
    (Join-Path $DocsDir "TESTING_COVERAGE_ANALYSIS.md"),
    (Join-Path $DocsDir "WORKFLOW_ANALYSIS.md"),
    (Join-Path $DocsDir "ANTI_PATTERN_ANALYSIS.md"),
    (Join-Path $ProjectRoot "BACKLOG.md")
)

foreach ($doc in $DocFiles) {
    $docName = Split-Path $doc -Leaf
    Write-TestStart "Check documentation: $docName"
    if (Test-Path $doc) {
        Write-TestPass "Documentation file exists"
    } else {
        Write-TestFail "Documentation missing: $docName"
    }
}

# ============================================================================
# Test 10: Continue AI Configuration
# ============================================================================
Write-Header "Test 10: Continue AI Configuration"

Write-TestStart "Verify Continue config in base.config.json"
if (Test-Path $baseConfigPath) {
    try {
        $jsonContent = Get-Content $baseConfigPath -Raw
        $jsonContent = $jsonContent -replace '//.*', '' -replace '/\*[\s\S]*?\*/', ''
        $baseConfig = $jsonContent | ConvertFrom-Json
        if ($baseConfig.continueConfig) {
            $cmdCount = 0
            if ($baseConfig.continueConfig.customCommands) {
                $cmdCount = ($baseConfig.continueConfig.customCommands.PSObject.Properties | Measure-Object).Count
            }
            Write-TestPass "Continue configured with $cmdCount custom commands"
        } else {
            Write-TestFail "Continue configuration missing"
        }
    } catch {
        Write-TestFail "Cannot verify Continue configuration" $_.Exception.Message
    }
} else {
    Write-TestFail "Cannot verify Continue configuration"
}

# ============================================================================
# Test Results Summary
# ============================================================================
Write-Header "Test Results Summary"

Write-Host "Total Tests Run:    " -NoNewline
Write-Host $script:TestsRun -ForegroundColor Blue

Write-Host "Tests Passed:       " -NoNewline
Write-Host $script:TestsPassed -ForegroundColor Green

Write-Host "Tests Failed:       " -NoNewline
Write-Host $script:TestsFailed -ForegroundColor Red

Write-Host ""

if ($script:TestsFailed -eq 0) {
    Write-Host "============================================================================================================" -ForegroundColor Green
    Write-Host "✓ ALL TESTS PASSED!" -ForegroundColor Green
    Write-Host "============================================================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "The DevContainer configuration is valid and ready to use!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Ensure Docker Desktop is running"
    Write-Host "  2. Open this folder in VS Code"
    Write-Host "  3. Install 'Dev Containers' extension (ms-vscode-remote.remote-containers)"
    Write-Host "  4. Command Palette → 'Dev Containers: Reopen in Container'"
    Write-Host "  5. Wait for setup to complete (first time takes 5-10 minutes)"
    Write-Host "  6. Start coding!"
    Write-Host ""
    Write-Host "Configuration Summary:" -ForegroundColor Cyan
    Write-Host "  • 24 universal extensions configured"
    Write-Host "  • 10 feature domains (AI, Testing, Quality, Security, etc.)"
    Write-Host "  • 37+ environment variables"
    Write-Host "  • Multiple language configs (Python, Node.js, Full Stack)"
    Write-Host "  • Self-hosted AI backend integration"
    Write-Host ""
    exit 0
}
else {
    Write-Host "============================================================================================================" -ForegroundColor Red
    Write-Host "✗ SOME TESTS FAILED" -ForegroundColor Red
    Write-Host "============================================================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please fix the failing tests before using the DevContainer." -ForegroundColor Red
    Write-Host "Check the output above for details."
    Write-Host ""
    exit 1
}
