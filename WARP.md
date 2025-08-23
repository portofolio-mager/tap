# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a Homebrew tap repository that provides custom formulae for the portofolio-mager organization. Currently contains the `todo` formula, which is a renamed version of taskwarrior.

## Architecture

### Core Components

1. **Formula Directory**: Contains Ruby formula definitions
   - `Formula/todo.rb` - Taskwarrior v3.4.1 renamed as "todo" command

2. **GitHub Actions Workflows**:
   - `.github/workflows/tests.yml` - Automated testing via brew test-bot on multiple OS versions
   - `.github/workflows/publish.yml` - Automated bottle publishing via brew pr-pull

## Common Commands

### Installation and Usage
```bash
# Install the tap
brew tap portofolio-mager/tap

# Install formula
brew install portofolio-mager/tap/todo

# Or direct install
brew install portofolio-mager/tap/todo
```

### Development Commands
```bash
# Test formula locally
brew test todo

# Audit formula for style and issues
brew audit --strict Formula/todo.rb

# Style check
brew style Formula/todo.rb

# Test installation from source
brew install --build-from-source Formula/todo.rb

# Reinstall formula
brew reinstall todo

# Uninstall formula
brew uninstall todo
```

### Formula Testing
```bash
# Run the formula test block
brew test todo

# Run comprehensive tests (simulates CI)
brew test-bot --only-tap-syntax
brew test-bot --only-formulae
```

### Updating Formula
```bash
# Edit formula
brew edit todo

# Update SHA256 after URL change
brew fetch --force Formula/todo.rb
brew sha256 Formula/todo.rb

# Create bottles (after PR merge)
brew bottle --json --root-url=https://github.com/portofolio-mager/tap/releases/download/<tag> todo
```

## Key Implementation Details

### Formula Structure
- The `todo` formula renames taskwarrior's `task` binary to `todo`
- Includes completions for bash, zsh, and fish shells
- Dependencies: cmake, corrosion, rust (build-time)
- Linux-specific dependencies: linux-headers, readline, util-linux

### CI/CD Pipeline
- Tests run on: ubuntu-22.04, macos-13, macos-15
- Automatic bottle creation for pull requests
- PR labeling with 'pr-pull' triggers bottle publishing

### Testing Requirements
- Formula must pass `brew test-bot` checks
- Test block creates `.taskrc` and verifies command functionality
- Bottles are uploaded as artifacts in pull requests
