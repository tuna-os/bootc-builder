#!/bin/bash

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Default installation directory
INSTALL_DIR="/usr/local/bin"

# Parse command line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --install-dir)
            if [ -z "${2:-}" ]; then
                print_error "--install-dir requires a value"
                exit 1
            fi
            INSTALL_DIR="$2"
            shift 2
            ;;
        -h|--help)
            cat << EOF
install.sh - Install bootc-builder

USAGE:
    ./install.sh [OPTIONS]

OPTIONS:
    --install-dir <DIR>  Installation directory (default: /usr/local/bin)
    -h, --help           Show this help message

EXAMPLES:
    # Install to default location (/usr/local/bin)
    sudo ./install.sh

    # Install to custom location
    ./install.sh --install-dir ~/.local/bin

EOF
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if script exists
if [ ! -f "bootc-builder" ]; then
    print_error "bootc-builder script not found in current directory"
    exit 1
fi

# Initialize git submodules if we're in a git repository
if [ -d ".git" ] && command -v git &> /dev/null; then
    print_info "Initializing git submodules..."
    git submodule update --init --recursive
fi

# Check if install directory exists, create if it doesn't
if [ ! -d "$INSTALL_DIR" ]; then
    print_info "Creating install directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Check if we have write permissions to install directory
if [ ! -w "$INSTALL_DIR" ]; then
    print_error "No write permission to $INSTALL_DIR. Try running with sudo or use --install-dir to specify a different location."
    exit 1
fi

# Copy the script
print_info "Installing bootc-builder to $INSTALL_DIR..."
cp bootc-builder "$INSTALL_DIR/bootc-builder"

# Make sure it's executable
chmod +x "$INSTALL_DIR/bootc-builder"

print_success "bootc-builder installed successfully!"
print_info "You can now run 'bootc-builder --help' from anywhere"

# Check if install directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    print_info "Note: $INSTALL_DIR is not in your PATH. You may want to add it to your ~/.bashrc or ~/.zshrc:"
    echo "    export PATH=\"$INSTALL_DIR:\$PATH\""
fi
