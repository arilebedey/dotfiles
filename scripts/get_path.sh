#!/bin/bash

# ---------------------------------------------------------------
# get_path.sh - Get the full absolute path of a file using fzf
# ---------------------------------------------------------------
#
# Description:
#   This script helps you quickly select a file using fzf (fuzzy finder)
#   and outputs its full absolute path. It also attempts to copy the path
#   to your clipboard using the appropriate clipboard utility for your system.
#
# Usage:
#   ./get_path.sh [optional starting directory]
#
# Arguments:
#   [optional starting directory] - Directory to start the search from
#                                  (defaults to current directory if not specified)
#
# Requirements:
#   - fzf (fuzzy finder) must be installed
#   - One of the following clipboard utilities (optional, for clipboard support):
#     * xclip (for X11 Linux systems)
#     * wl-copy (for Wayland Linux systems)
#     * pbcopy (for macOS)
#     * clip.exe (for Windows/WSL)
#
# Examples:
#   ./get_path.sh                   # Start from current directory
#   ./get_path.sh ~/Documents       # Start from ~/Documents
#   ./get_path.sh /var/log          # Start from /var/log

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "Error: fzf is not installed. Please install it first."
    echo "You can install it using your package manager or from https://github.com/junegunn/fzf"
    exit 1
fi

# Set the starting directory
start_dir="${1:-$(pwd)}"

if [ ! -d "$start_dir" ]; then
    echo "Error: $start_dir is not a valid directory."
    exit 1
fi

# Change to the starting directory
cd "$start_dir" || exit 1

# Use find to get all files (excluding hidden files) and pipe to fzf for selection
# Then get the absolute path of the selected file
selected_file=$(find . -type f -not -path "*/\.*" | fzf --height 40% --reverse --prompt="Select a file: ")

# If user selected a file
if [ -n "$selected_file" ]; then
    # Get the absolute path
    absolute_path="$(cd "$(dirname "$selected_file")" && pwd)/$(basename "$selected_file")"
    echo "$absolute_path"
    
    # Optionally copy to clipboard if a clipboard tool is available
    if command -v xclip &> /dev/null; then
        echo "$absolute_path" | xclip -selection clipboard
        echo "Path copied to clipboard (xclip)."
    elif command -v wl-copy &> /dev/null; then
        echo "$absolute_path" | wl-copy
        echo "Path copied to clipboard (wl-copy)."
    elif command -v pbcopy &> /dev/null; then
        echo "$absolute_path" | pbcopy
        echo "Path copied to clipboard (pbcopy)."
    elif command -v clip.exe &> /dev/null; then
        echo "$absolute_path" | clip.exe
        echo "Path copied to clipboard (clip.exe)."
    fi
else
    echo "No file selected."
    exit 1
fi
