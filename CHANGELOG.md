# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of bootc-builder
- Unified command-line interface for Titanoboa and Bootc-image-builder
- Support for multiple build types: iso, live-iso, qcow2, raw
- Support for multiple architectures: x86_64, aarch64
- Colored terminal output for better user experience
- Comprehensive error handling and validation
- Installation script for easy setup
- Test suite for validation
- GitHub Actions CI/CD workflow
- Makefile for common development tasks

### Features
- **Build Types**:
  - `iso`: Anaconda installer ISO using bootc-image-builder
  - `live-iso`: Live bootable ISO using Titanoboa
  - `qcow2`: QEMU virtual disk image using bootc-image-builder
  - `raw`: Raw disk image using bootc-image-builder
- **Architecture Support**: x86_64 and aarch64
- **Output Options**: Configurable output directory
- **Verbose Mode**: Detailed output for debugging
- **Smart Tool Selection**: Automatically chooses the right tool for each build type

## [1.0.0] - 2025-08-16

### Added
- Initial release
