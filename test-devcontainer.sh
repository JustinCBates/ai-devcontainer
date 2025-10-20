#!/bin/bash
# DevContainer Test Suite
# Validates the complete DevContainer setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEVCONTAINER_DIR="$PROJECT_ROOT/.devcontainer"
CONFIG_DIR="$DEVCONTAINER_DIR/configs"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

test_start() {
    TESTS_RUN=$((TESTS_RUN + 1))
    echo -e "${YELLOW}[TEST $TESTS_RUN]${NC} $1"
}

test_pass() {
    TESTS_PASSED=$((TESTS_PASSED + 1))
    echo -e "${GREEN}✓ PASS${NC} $1\n"
}

test_fail() {
    TESTS_FAILED=$((TESTS_FAILED + 1))
    echo -e "${RED}✗ FAIL${NC} $1"
    if [ -n "$2" ]; then
        echo -e "${RED}  Error: $2${NC}\n"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if file exists and is readable
file_check() {
    if [ -f "$1" ] && [ -r "$1" ]; then
        return 0
    else
        return 1
    fi
}

# Validate JSON file
validate_json() {
    local file=$1
    if command_exists jq; then
        jq empty "$file" 2>/dev/null
        return $?
    elif command_exists python3; then
        python3 -c "import json; json.load(open('$file'))" 2>/dev/null
        return $?
    else
        echo "Neither jq nor python3 available for JSON validation"
        return 1
    fi
}

# Count extensions in config
count_extensions() {
    local file=$1
    if command_exists jq; then
        jq -r '.extensions.required[]?' "$file" 2>/dev/null | wc -l
    else
        echo "0"
    fi
}

# Start tests
print_header "DevContainer Configuration Test Suite"
echo "Testing directory: $DEVCONTAINER_DIR"
echo "Started: $(date)"
echo ""

# ============================================================================
# Test 1: Directory Structure
# ============================================================================
print_header "Test 1: Directory Structure"

test_start "Check .devcontainer directory exists"
if [ -d "$DEVCONTAINER_DIR" ]; then
    test_pass "Directory exists: $DEVCONTAINER_DIR"
else
    test_fail "Directory missing: $DEVCONTAINER_DIR"
fi

test_start "Check configs directory exists"
if [ -d "$CONFIG_DIR" ]; then
    test_pass "Directory exists: $CONFIG_DIR"
else
    test_fail "Directory missing: $CONFIG_DIR"
fi

test_start "Check scripts directory exists"
if [ -d "$DEVCONTAINER_DIR/scripts" ]; then
    test_pass "Directory exists: $DEVCONTAINER_DIR/scripts"
else
    test_fail "Directory missing: $DEVCONTAINER_DIR/scripts"
fi

# ============================================================================
# Test 2: Required Files
# ============================================================================
print_header "Test 2: Required Files"

REQUIRED_FILES=(
    "$DEVCONTAINER_DIR/devcontainer.json"
    "$DEVCONTAINER_DIR/Dockerfile"
    "$DEVCONTAINER_DIR/docker-compose.yml"
    "$DEVCONTAINER_DIR/post-create.sh"
    "$DEVCONTAINER_DIR/post-start.sh"
    "$DEVCONTAINER_DIR/scripts/load-config.sh"
    "$CONFIG_DIR/base.config.json"
    "$CONFIG_DIR/python.config.json"
    "$CONFIG_DIR/nodejs.config.json"
    "$CONFIG_DIR/fullstack.config.json"
)

for file in "${REQUIRED_FILES[@]}"; do
    filename=$(basename "$file")
    test_start "Check file exists: $filename"
    if file_check "$file"; then
        test_pass "File exists and is readable"
    else
        test_fail "File missing or not readable: $file"
    fi
done

# ============================================================================
# Test 3: Script Executability
# ============================================================================
print_header "Test 3: Script Executability"

SCRIPTS=(
    "$DEVCONTAINER_DIR/post-create.sh"
    "$DEVCONTAINER_DIR/post-start.sh"
    "$DEVCONTAINER_DIR/scripts/load-config.sh"
)

for script in "${SCRIPTS[@]}"; do
    script_name=$(basename "$script")
    test_start "Check script is executable: $script_name"
    if [ -x "$script" ]; then
        test_pass "Script is executable"
    else
        # Try to make it executable
        chmod +x "$script" 2>/dev/null
        if [ -x "$script" ]; then
            test_pass "Script made executable"
        else
            test_fail "Cannot make script executable: $script"
        fi
    fi
done

# ============================================================================
# Test 4: JSON Configuration Validation
# ============================================================================
print_header "Test 4: JSON Configuration Validation"

CONFIG_FILES=(
    "$DEVCONTAINER_DIR/devcontainer.json"
    "$CONFIG_DIR/base.config.json"
    "$CONFIG_DIR/python.config.json"
    "$CONFIG_DIR/nodejs.config.json"
    "$CONFIG_DIR/fullstack.config.json"
)

# Check if jq is available
if ! command_exists jq; then
    echo -e "${YELLOW}Installing jq for JSON validation...${NC}"
    if command_exists apt-get; then
        sudo apt-get update -qq && sudo apt-get install -y -qq jq 2>/dev/null || true
    fi
fi

for config in "${CONFIG_FILES[@]}"; do
    if [ -f "$config" ]; then
        config_name=$(basename "$config")
        test_start "Validate JSON syntax: $config_name"
        if validate_json "$config"; then
            test_pass "Valid JSON"
        else
            test_fail "Invalid JSON" "Syntax error in $config"
        fi
    fi
done

# ============================================================================
# Test 5: Extension Configuration
# ============================================================================
print_header "Test 5: Extension Configuration"

test_start "Count extensions in base.config.json"
if [ -f "$CONFIG_DIR/base.config.json" ]; then
    EXT_COUNT=$(count_extensions "$CONFIG_DIR/base.config.json")
    if [ "$EXT_COUNT" -ge 24 ]; then
        test_pass "Found $EXT_COUNT extensions (expected 24)"
    else
        test_fail "Found only $EXT_COUNT extensions (expected 24)"
    fi
else
    test_fail "base.config.json not found"
fi

test_start "Verify critical extensions are present"
CRITICAL_EXTENSIONS=(
    "continue.continue"
    "SonarSource.sonarlint-vscode"
    "hbenl.vscode-test-explorer"
    "ryanluker.vscode-coverage-gutters"
    "eamodio.gitlens"
    "snyk-security.snyk-vulnerability-scanner"
)

MISSING_EXTENSIONS=()
if [ -f "$CONFIG_DIR/base.config.json" ] && command_exists jq; then
    for ext in "${CRITICAL_EXTENSIONS[@]}"; do
        if ! jq -e ".extensions.required[] | select(. == \"$ext\")" "$CONFIG_DIR/base.config.json" > /dev/null 2>&1; then
            MISSING_EXTENSIONS+=("$ext")
        fi
    done
    
    if [ ${#MISSING_EXTENSIONS[@]} -eq 0 ]; then
        test_pass "All critical extensions found"
    else
        test_fail "Missing critical extensions: ${MISSING_EXTENSIONS[*]}"
    fi
else
    test_fail "Cannot verify extensions (jq not available or file missing)"
fi

# ============================================================================
# Test 6: Feature Configuration
# ============================================================================
print_header "Test 6: Feature Configuration"

EXPECTED_FEATURES=(
    "continue"
    "logging"
    "linting"
    "testing"
    "git"
    "documentation"
    "dependencies"
    "workflow"
    "codeQuality"
    "security"
)

test_start "Verify feature sections in base.config.json"
if [ -f "$CONFIG_DIR/base.config.json" ] && command_exists jq; then
    MISSING_FEATURES=()
    for feature in "${EXPECTED_FEATURES[@]}"; do
        if ! jq -e ".features.$feature" "$CONFIG_DIR/base.config.json" > /dev/null 2>&1; then
            MISSING_FEATURES+=("$feature")
        fi
    done
    
    if [ ${#MISSING_FEATURES[@]} -eq 0 ]; then
        test_pass "All ${#EXPECTED_FEATURES[@]} feature sections found"
    else
        test_fail "Missing feature sections: ${MISSING_FEATURES[*]}"
    fi
else
    test_fail "Cannot verify features"
fi

# ============================================================================
# Test 7: Environment Variables
# ============================================================================
print_header "Test 7: Environment Variables"

test_start "Check environment variable definitions"
if [ -f "$CONFIG_DIR/base.config.json" ] && command_exists jq; then
    ENV_COUNT=$(jq -r '.environment | keys | length' "$CONFIG_DIR/base.config.json" 2>/dev/null)
    if [ "$ENV_COUNT" -ge 37 ]; then
        test_pass "Found $ENV_COUNT environment variables (expected 37+)"
    else
        test_fail "Found only $ENV_COUNT environment variables (expected 37+)"
    fi
else
    test_fail "Cannot verify environment variables"
fi

# ============================================================================
# Test 8: Docker Configuration
# ============================================================================
print_header "Test 8: Docker Configuration"

test_start "Validate Dockerfile"
if file_check "$DEVCONTAINER_DIR/Dockerfile"; then
    if grep -q "FROM mcr.microsoft.com/devcontainers/python" "$DEVCONTAINER_DIR/Dockerfile"; then
        test_pass "Dockerfile has correct base image"
    else
        test_fail "Dockerfile base image not found"
    fi
else
    test_fail "Dockerfile not found"
fi

test_start "Validate docker-compose.yml"
if file_check "$DEVCONTAINER_DIR/docker-compose.yml"; then
    if grep -q "devcontainer:" "$DEVCONTAINER_DIR/docker-compose.yml" && \
       grep -q "ai-backend:" "$DEVCONTAINER_DIR/docker-compose.yml"; then
        test_pass "docker-compose.yml has required services"
    else
        test_fail "docker-compose.yml missing required services"
    fi
else
    test_fail "docker-compose.yml not found"
fi

# ============================================================================
# Test 9: Script Syntax
# ============================================================================
print_header "Test 9: Script Syntax"

for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        test_start "Check bash syntax: $script_name"
        if bash -n "$script" 2>/dev/null; then
            test_pass "Script syntax valid"
        else
            test_fail "Script has syntax errors: $script"
        fi
    fi
done

# ============================================================================
# Test 10: Configuration Inheritance
# ============================================================================
print_header "Test 10: Configuration Inheritance"

test_start "Verify python.config.json extends base"
if [ -f "$CONFIG_DIR/python.config.json" ] && command_exists jq; then
    if jq -e '.extends' "$CONFIG_DIR/python.config.json" > /dev/null 2>&1; then
        test_pass "python.config.json extends base config"
    else
        test_fail "python.config.json missing 'extends' field"
    fi
else
    test_fail "Cannot verify inheritance"
fi

test_start "Verify nodejs.config.json extends base"
if [ -f "$CONFIG_DIR/nodejs.config.json" ] && command_exists jq; then
    if jq -e '.extends' "$CONFIG_DIR/nodejs.config.json" > /dev/null 2>&1; then
        test_pass "nodejs.config.json extends base config"
    else
        test_fail "nodejs.config.json missing 'extends' field"
    fi
else
    test_fail "Cannot verify inheritance"
fi

# ============================================================================
# Test 11: Documentation
# ============================================================================
print_header "Test 11: Documentation"

DOC_FILES=(
    "$PROJECT_ROOT/README.md"
    "$PROJECT_ROOT/docs/CONFIG_GUIDE.md"
    "$PROJECT_ROOT/docs/ARCHITECTURE.md"
    "$PROJECT_ROOT/docs/COMPLETE_ENVIRONMENT.md"
    "$PROJECT_ROOT/BACKLOG.md"
)

for doc in "${DOC_FILES[@]}"; do
    if [ -f "$doc" ]; then
        doc_name=$(basename "$doc")
        test_start "Check documentation: $doc_name"
        test_pass "Documentation file exists"
    fi
done

# ============================================================================
# Test 12: Continue AI Configuration
# ============================================================================
print_header "Test 12: Continue AI Configuration"

test_start "Verify Continue config in base.config.json"
if [ -f "$CONFIG_DIR/base.config.json" ] && command_exists jq; then
    if jq -e '.continueConfig' "$CONFIG_DIR/base.config.json" > /dev/null 2>&1; then
        CUSTOM_COMMANDS=$(jq -r '.continueConfig.customCommands | keys | length' "$CONFIG_DIR/base.config.json" 2>/dev/null)
        test_pass "Continue configured with $CUSTOM_COMMANDS custom commands"
    else
        test_fail "Continue configuration missing"
    fi
else
    test_fail "Cannot verify Continue configuration"
fi

# ============================================================================
# Test Results Summary
# ============================================================================
print_header "Test Results Summary"

echo -e "Total Tests Run:    ${BLUE}$TESTS_RUN${NC}"
echo -e "Tests Passed:       ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed:       ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ ALL TESTS PASSED!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "The DevContainer configuration is valid and ready to use!"
    echo ""
    echo "Next steps:"
    echo "  1. Open this folder in VS Code"
    echo "  2. Command Palette → 'Dev Containers: Reopen in Container'"
    echo "  3. Wait for setup to complete"
    echo "  4. Start coding!"
    exit 0
else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}✗ SOME TESTS FAILED${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Please fix the failing tests before using the DevContainer."
    echo "Check the output above for details."
    exit 1
fi
