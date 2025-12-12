#!/bin/bash

set -e

for cmd in fzf nvim; do
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
    exit 0
fi

FILE_PATHS=$(grep -v '^\s*$' "$SELECTED_CTX" | grep -v '^#' | sed 's/^- *//')
if [ -z "$FILE_PATHS" ]; then
    exit 1
fi

TEMP_FILE=$(mktemp).prompt
PROMPT_FILE=$(mktemp).prompt

echo -e "\n# Save and exit when done." > "$PROMPT_FILE"

while IFS= read -r PATH_LINE; do
    if [ -z "$PATH_LINE" ]; then
        continue
    fi

    # Check if path is absolute or relative
    if [[ "$PATH_LINE" = /* ]]; then
        FULL_PATH="$PATH_LINE"
    else
        FULL_PATH="$(realpath "$PATH_LINE" 2>/dev/null || true)"
    fi

    if [ -z "$FULL_PATH" ] || [ ! -f "$FULL_PATH" ]; then
        continue
    fi

    EXTENSION="${FULL_PATH##*.}"
    echo -e "#### ${FULL_PATH}\n" >> "$TEMP_FILE"
    echo -e "\`\`\`${EXTENSION}" >> "$TEMP_FILE"
    cat "$FULL_PATH" >> "$TEMP_FILE"
    echo -e "\`\`\`\n" >> "$TEMP_FILE"
done <<< "$FILE_PATHS"

echo -e "#### List of files included\n" >> "$TEMP_FILE"
echo "$FILE_PATHS" | sed 's/^/- /' >> "$TEMP_FILE"
echo >> "$TEMP_FILE"

nvim +startinsert "$PROMPT_FILE"

PROMPT_CONTENT=$(grep -v "^# " "$PROMPT_FILE" | sed '/^$/d' || true)

if [ -n "$PROMPT_CONTENT" ]; then
    echo -e "### Prompt\n" >> "$TEMP_FILE"
    cat "$PROMPT_FILE" | grep -v "^# " >> "$TEMP_FILE"
fi

OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then
    CLIP_CMD="pbcopy"
elif command -v wl-copy &> /dev/null; then
    CLIP_CMD="wl-copy"
elif command -v xclip &> /dev/null; then
    CLIP_CMD="xclip -selection clipboard"
else
    CLIP_CMD=""
fi

if [ -n "$CLIP_CMD" ]; then
    cat "$TEMP_FILE" | $CLIP_CMD
    echo "Copied combined content to clipboard."
else
    echo "Clipboard command not found; output saved to: $TEMP_FILE"
fi
