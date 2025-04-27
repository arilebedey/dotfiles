# Ghostty Environment Setup

This document explains how to set up different Ghostty configurations based on your current system environment.

## Available Environments

- `42-dell`: Configuration optimized for 42 school Dell machines
- `home`: Configuration for home use

## Manual Setup

To manually set up the correct configuration, run the provided `setup-ghostty-config.sh` script:

```bash
$HOME/System/scripts/setups/setup-ghostty-config.sh 42-dell
$HOME/System/scripts/setups/setup-ghostty-config.sh home
```

Where `[environment-name]` is one of the available environments listed above.

## OS-Specific Instructions

### macOS

1. Place the script in a directory in your PATH, such as `~/bin` or `/usr/local/bin`
2. Make it executable: `chmod +x setup-ghostty-config.sh`
3. Run it with your desired environment: `setup-ghostty-config.sh 42-dell`

### 42 | Ubuntu / Debian 

1. Place the script in a directory in your PATH, such as `~/bin` or `/usr/local/bin`
2. Make it executable: `chmod +x setup-ghostty-config.sh`
3. Run it with your desired environment: `setup-ghostty-config.sh home`

### Arch Linux

1. Place the script in a directory in your PATH, such as `~/bin` or `/usr/local/bin`
2. Make it executable: `chmod +x setup-ghostty-config.sh`
3. Run it with your desired environment: `setup-ghostty-config.sh home`

## Typical Usage

When switching between environments:

1. For 42 Dell machines: `setup-ghostty-config.sh 42-dell`
2. For home setup: `setup-ghostty-config.sh home`

The script will handle creating the proper symlink to your selected configuration, removing any existing configuration first.
