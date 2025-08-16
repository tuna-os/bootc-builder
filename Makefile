.PHONY: help install test clean lint

# Default target
help:
	@echo "bootc-builder Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  help     - Show this help message"
	@echo "  test     - Run tests"
	@echo "  install  - Install bootc-builder to /usr/local/bin (requires sudo)"
	@echo "  clean    - Clean up temporary files"
	@echo "  lint     - Check shell script with shellcheck (if available)"
	@echo ""
	@echo "Examples:"
	@echo "  make test"
	@echo "  sudo make install"
	@echo "  make lint"

# Run tests
test:
	@echo "Running tests..."
	./test.sh

# Install to system
install:
	@echo "Installing bootc-builder..."
	./install.sh

# Clean up temporary files
clean:
	@echo "Cleaning up..."
	rm -f *.toml
	rm -f bootc-config.toml
	@echo "Clean complete."

# Lint shell scripts (requires shellcheck)
lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		echo "Linting shell scripts..."; \
		shellcheck bootc-builder install.sh test.sh; \
		echo "Linting complete."; \
	else \
		echo "shellcheck not found. Install it to run linting."; \
		echo "  - Ubuntu/Debian: apt install shellcheck"; \
		echo "  - Fedora: dnf install ShellCheck"; \
		echo "  - macOS: brew install shellcheck"; \
	fi

# Development target - make the script executable and init submodules
dev:
	chmod +x bootc-builder install.sh test.sh
	@if [ -d ".git" ]; then \
		echo "Initializing git submodules..."; \
		git submodule update --init --recursive; \
	fi
	@echo "Scripts made executable and submodules initialized."
