#!/bin/bash

# Exit on any error
set -e

# Array of directories and files to ignore
IGNORED_PATHS=(
    '*/.git/*'
    '*/node_modules/*'
    '*/.DS_Store'
    '*/__pycache__/*'
    '*/libft/*'
    '*/obj/*'
    '*/.vscode/*'
    '*/dist/*'
    '*/mlx_linux/*'
)

# Build find command with ignored paths
FIND_CMD="find . -type f"
for path in "${IGNORED_PATHS[@]}"; do
    FIND_CMD+=" -not -path '$path'"
done

# Detect operating system
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE=Linux;;
    Darwin*)    OS_TYPE=Mac;;
    *)          OS_TYPE=Unknown;;
esac

# Set clipboard command based on OS
if [ "$OS_TYPE" = "Mac" ]; then
    CLIPBOARD_CMD="pbcopy"
elif [ "$OS_TYPE" = "Linux" ]; then
    # Check for Wayland or X11
    if [ -n "$WAYLAND_DISPLAY" ]; then
        CLIPBOARD_CMD="wl-copy"
    elif [ -n "$DISPLAY" ]; then
        CLIPBOARD_CMD="xclip -selection clipboard"
    else
        echo "Error: No display server detected. Cannot determine clipboard command."
        exit 1
    fi
else
    echo "Error: Unsupported operating system: $OS"
    exit 1
fi

# Check for dependencies
if [ "$OS_TYPE" = "Mac" ]; then
    REQUIRED_COMMANDS="fzf nvim $CLIPBOARD_CMD"
else
    # For Linux, check the appropriate clipboard tool
    if [ "$CLIPBOARD_CMD" = "wl-copy" ]; then
        REQUIRED_COMMANDS="fzf nvim wl-copy"
    else
        REQUIRED_COMMANDS="fzf nvim xclip"
    fi
fi

for cmd in $REQUIRED_COMMANDS; do
    if ! command -v ${cmd%% *} &> /dev/null; then
        echo "Error: ${cmd%% *} is required but not installed."
        exit 1
    fi
done

# Create a temporary file with .prompt extension
TEMP_FILE=$(mktemp).prompt
echo "Temporary file created at: $TEMP_FILE"

# Use fzf to select files (multiple files can be selected with TAB)
echo "Select files using fzf (TAB to select multiple, ENTER to confirm):"
SELECTED_FILES=$(eval "$FIND_CMD" | fzf --multi)

# Exit if no files were selected
if [ -z "$SELECTED_FILES" ]; then
    echo "No files selected. Exiting."
    rm "$TEMP_FILE"
    exit 0
fi

# Current working directory for relative paths
CWD=$(pwd)

# Process each selected file
echo "$SELECTED_FILES" | while read -r FILE; do
    # Get relative path for the file
    RELATIVE_PATH="${FILE#./}"
    
    # Get file extension for code block
    EXTENSION="${FILE##*.}"
    
    # Add file path as H4 in markdown
    echo -e "#### ${RELATIVE_PATH}\n" >> "$TEMP_FILE"
    
    # Add file content as code block with language
    echo -e "\`\`\`${EXTENSION}" >> "$TEMP_FILE"
    cat "$FILE" >> "$TEMP_FILE"
    echo -e "\`\`\`\n" >> "$TEMP_FILE"
done

# Add a H4 section listing all provided files
echo -e "#### List of files provided\n" >> "$TEMP_FILE"
while IFS= read -r FILE; do
    RELATIVE_PATH="${FILE#./}"
    echo "- ${RELATIVE_PATH}" >> "$TEMP_FILE"
done <<< "$SELECTED_FILES"
echo >> "$TEMP_FILE"

# Create a temporary prompt file with .prompt extension
PROMPT_FILE=$(mktemp).prompt
echo "" > "$PROMPT_FILE"
echo "# Save and quit when done" >> "$PROMPT_FILE"

# Open the prompt file in nvim
nvim +startinsert "$PROMPT_FILE"

# Check if the prompt file has content beyond the initial template
PROMPT_CONTENT=$(grep -v "^# " "$PROMPT_FILE" | sed '/^$/d')

if [ -n "$PROMPT_CONTENT" ]; then
    # Add the prompt to the temp file with a header
    echo -e "### Prompt\n" >> "$TEMP_FILE"
    cat "$PROMPT_FILE" | grep -v "^# " >> "$TEMP_FILE"
fi

# Copy the contents of the temp file to clipboard
if [ "$CLIPBOARD_CMD" = "xclip -selection clipboard" ]; then
    cat "$TEMP_FILE" | xclip -selection clipboard
else
    cat "$TEMP_FILE" | $CLIPBOARD_CMD
fi
echo "Context and prompt copied to clipboard!"

# Clean up temporary files
rm "$TEMP_FILE" "$PROMPT_FILE"
echo "Temporary files removed."
