# bootc-builder

A bash wrapper for [Titanoboa](https://github.com/ublue-os/titanoboa) and [Bootc-image-builder](https://github.com/osbuild/bootc-image-builder) that provides a unified interface for building bootable images from container images.

## Features

- 🚀 **Unified Interface**: Single command for multiple build tools
- 🏗️ **Multiple Build Types**: Support for ISO, Live ISO, QCOW2, and Raw disk images
- 🏛️ **Architecture Support**: Build for x86_64 and aarch64 architectures
- 🎨 **Colored Output**: Clear, colorful terminal output for better UX
- ⚙️ **Smart Tool Selection**: Automatically chooses the right tool for each build type
- 🛡️ **Error Handling**: Comprehensive validation and error reporting

## Installation

### Quick Install
```bash
# Clone the repository
git clone https://github.com/tuna-os/bootc-builder.git
cd bootc-builder

# Install to /usr/local/bin (requires sudo)
sudo ./install.sh

# Or install to a custom location
./install.sh --install-dir ~/.local/bin
```

### Manual Install
```bash
# Make executable and copy to your PATH
chmod +x bootc-builder
sudo cp bootc-builder /usr/local/bin/
```

## Usage

```bash
bootc-builder build <IMAGE_URI> --type <TYPE> [OPTIONS]
```

### Options

- `--type <TYPE>`: Build type (required)
  - `iso`: Anaconda installer ISO (uses bootc-image-builder)
  - `live-iso`: Live ISO that boots directly to the OS (uses Titanoboa)
  - `qcow2`: QEMU disk image (uses bootc-image-builder)
  - `raw`: Raw disk image (uses bootc-image-builder)

- `--arch <ARCH>`: Target architecture (default: x86_64)
  - `x86_64`: Intel/AMD 64-bit
  - `aarch64`: ARM 64-bit

- `--output-dir <DIR>`: Output directory (default: current directory)
- `--verbose`: Enable verbose output
- `--help`: Show help message

## Examples

### Basic Usage
```bash
# Create an Anaconda ISO for installation
bootc-builder build ghcr.io/ublue-os/bluefin:latest --type iso --output-dir /tmp

# Create a live ISO that boots directly
bootc-builder build ghcr.io/ublue-os/bluefin:latest --type live-iso --output-dir /tmp

# Create a QEMU disk image
bootc-builder build ghcr.io/ublue-os/bluefin:latest --type qcow2 --output-dir /tmp
```

### Advanced Usage
```bash
# Build for ARM64 architecture
bootc-builder build ghcr.io/ublue-os/bluefin:latest --type iso --arch aarch64 --output-dir /tmp

# Enable verbose output for debugging
bootc-builder build ghcr.io/ublue-os/bluefin:latest --type qcow2 --verbose --output-dir /tmp

# Build from specific tag
bootc-builder build ghcr.io/ublue-os/bluefin:40 --type live-iso --output-dir ./builds
```

## Build Types Explained

| Type | Tool | Description | Use Case |
|------|------|-------------|----------|
| `iso` | bootc-image-builder | Anaconda installer ISO | Traditional installation media |
| `live-iso` | Titanoboa | Live bootable ISO | Try before install, rescue disks |
| `qcow2` | bootc-image-builder | QEMU virtual disk | Virtual machines |
| `raw` | bootc-image-builder | Raw disk image | Physical deployment, cloud images |

## Requirements
- podman
- just (command runner)

## Dependencies

bootc-builder has different dependencies based on the build type:

- **All builds**: `podman` - Container runtime for pulling and managing images
- **Live ISO builds**: `just` - Command runner for executing Titanoboa builds

### Installing Dependencies

**podman**:
- **Fedora/RHEL**: `sudo dnf install podman`
- **Ubuntu/Debian**: `sudo apt install podman`
- **Arch**: `sudo pacman -S podman`
- **macOS**: `brew install podman`

**just**:
- **Fedora**: `sudo dnf install just`
- **Ubuntu/Debian**: `cargo install just` (requires Rust) or download from releases
- **Arch**: `sudo pacman -S just`
- **macOS**: `brew install just`

## Architecture

bootc-builder acts as a unified interface that:

1. **Validates input parameters** (image URI, build type, architecture, etc.)
2. **Selects the appropriate tool**:
   - Uses **Titanoboa** (native) for `live-iso` builds via git submodule
   - Uses **bootc-image-builder** (containerized) for `iso`, `qcow2`, and `raw` builds
3. **Generates configuration files** as needed for each tool
4. **Executes the build** using the appropriate method for each tool
5. **Handles cleanup** and provides user feedback

### Titanoboa Integration

For live ISO builds, bootc-builder uses Titanoboa as a git submodule. This allows us to:
- Call Titanoboa natively without containerization
- Benefit from the latest Titanoboa features and fixes
- Avoid the complexity of nested podman required for a containerized approach

The submodule is automatically initialized during installation.

## Development

### Building and Testing
```bash
# Initialize git submodules
git submodule update --init --recursive

# Make scripts executable
make dev

# Run tests
make test

# Lint shell scripts (requires shellcheck)
make lint

# Clean up temporary files
make clean
```

### Contributing
1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Run tests: `make test`
5. Commit your changes: `git commit -am 'Add some feature'`
6. Push to the branch: `git push origin feature-name`
7. Submit a pull request

## Troubleshooting

### Common Issues

**"podman: command not found"**
- Install podman on your system (see Dependencies section above)

**"just: command not found"**
- Install just command runner (see Dependencies section above)
- Only required for live-iso builds

**"Titanoboa directory not found"**
- Initialize git submodules: `git submodule update --init --recursive`

**Permission denied when running**
- Make sure the script is executable: `chmod +x bootc-builder`
- For system installation, use sudo: `sudo ./install.sh`

**Build fails with container errors**
- Ensure podman is running and accessible
- Try running with `--verbose` for more detailed output
- Check that the container image URI is correct and accessible

### Getting Help
- Run `bootc-builder --help` for usage information
- Check the [Issues](https://github.com/tuna-os/bootc-builder/issues) page
- Review the examples in this README

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
A bash+glow wrapper for [Titanoboa](https://github.com/ublue-os/titanoboa) and [Bootc-image-builder](https://github.com/osbuild/bootc-image-builder)

## Usage
```bash
bootc-builder image --type {iso,live-iso,qcow2,raw} --arch {x86_64,aarch64} --output-dir /path/to/output
```

## Example
```bash
bootc-builder ghcr.io/ublue-os/bluefin:latest --type iso --arch x86_64 --output-dir /tmp # uses Bootc-image-builder to create an non-live Anaconda ISO from the Bootc image
bootc-builder ghcr.io/ublue-os/bluefin:lts --type live-iso --arch aarch64 --output-dir /tmp # uses Titanoboa to create a live ISO from the Bootc image
```
## Requirements
- podman


# Special thanks
- [titanoboa](https://github.com/ublue-os/titanoboa)
- [bootc-image-builder](https://github.com/osbuild/bootc-image-builder)