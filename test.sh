#!/bin/bash

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit_code="${3:-0}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    print_info "Running test: $test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        local exit_code=0
    else
        local exit_code=$?
    fi
    
    if [ $exit_code -eq $expected_exit_code ]; then
        print_success "$test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        print_error "$test_name (expected exit code $expected_exit_code, got $exit_code)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Check if bootc-builder exists
if [ ! -f "./bootc-builder" ]; then
    print_error "bootc-builder script not found in current directory"
    exit 1
fi

print_info "Testing bootc-builder functionality..."
echo

# Test help output
run_test "Help message" "./bootc-builder --help"
run_test "Help message (short)" "./bootc-builder -h"

# Test missing arguments
run_test "Missing arguments" "./bootc-builder" 1
run_test "Missing build command" "./bootc-builder build" 1
run_test "Missing type" "./bootc-builder build test-image" 1

# Test invalid arguments
run_test "Invalid command" "./bootc-builder invalid" 1
run_test "Invalid type" "./bootc-builder build test-image --type invalid" 1
run_test "Invalid arch" "./bootc-builder build test-image --type iso --arch invalid" 1

# Test valid argument combinations (these will fail at podman stage, but should pass validation)
run_test "Valid ISO build args" "./bootc-builder build test-image --type iso --arch x86_64 --output-dir /tmp --verbose" 1
run_test "Valid Live ISO build args" "./bootc-builder build test-image --type live-iso --arch aarch64 --output-dir /tmp" 1
run_test "Valid QCOW2 build args" "./bootc-builder build test-image --type qcow2 --output-dir /tmp" 1
run_test "Valid Raw build args" "./bootc-builder build test-image --type raw --output-dir /tmp" 1

echo
print_info "Test Summary:"
print_info "Tests run: $TESTS_RUN"
print_success "Tests passed: $TESTS_PASSED"
if [ $TESTS_FAILED -gt 0 ]; then
    print_error "Tests failed: $TESTS_FAILED"
else
    print_success "Tests failed: $TESTS_FAILED"
fi

if [ $TESTS_FAILED -eq 0 ]; then
    print_success "All tests passed!"
    exit 0
else
    print_error "Some tests failed!"
    exit 1
fi
