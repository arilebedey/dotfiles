#!/bin/bash

set -e

for cmd in fzf; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: $cmd is required but not installed."
        exit 1
    fi
done

CTX_DIR="./.ctx"
if [ ! -d "$CTX_DIR" ]; then
    echo "Error: $CTX_DIR does not exist."
    exit 1
fi

SELECTED_CTX=$(find "$CTX_DIR" -type f | fzf --height 30% --border --prompt="Select context file > ")
if [ -z "$SELECTED_CTX" ]; then
    echo "No context file selected. Exiting."
    exit 0
fi

IGNORED_PATHS=(
    '*/.git/*'
    '*/node_modules/*'
    '*/.DS_Store'
    '*/__pycache__/*'
    '*/libft/*'
    '*/obj/*'
    '*/.vscode/*'
)

FIND_CMD="find . -type f"
for path in "${IGNORED_PATHS[@]}"; do
    FIND_CMD+=" -not -path '$path'"
done

echo "Select files to add (TAB to select multiple, ENTER to confirm):"
SELECTED_FILES=$(eval "$FIND_CMD" | fzf --multi)

if [ -z "$SELECTED_FILES" ]; then
    echo "No files selected. Exiting."
    exit 0
fi

while IFS= read -r FILE; do
    [ -z "$FILE" ] && continue
    RELATIVE_PATH="${FILE#./}"
    echo "$RELATIVE_PATH" >> "$SELECTED_CTX"
done <<< "$SELECTED_FILES"

echo >> "$SELECTED_CTX"

echo "Selected files appended to $SELECTED_CTX."
