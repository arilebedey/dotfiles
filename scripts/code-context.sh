#!/bin/bash

# Exit on any error
set -e

# Check for dependencies
for cmd in fzf nvim wl-copy; do
  if ! command -v $cmd &> /dev/null; then
    echo "Error: $cmd is required but not installed."
    exit 1
  fi
done

# Create a temporary file
TEMP_FILE=$(mktemp)

# Define directories to exclude
EXCLUDE_DIRS=".git|.svn|.hg|node_modules|__pycache__|.venv|.env|.idea|.vscode"

# Brief description and instruction
echo "Code Context Builder for LLM Prompts"
echo "Select files [TAB: multi-select, ENTER: confirm]:"

# Find all files, including those in hidden directories, but exclude specific directories
mapfile -t SELECTED_FILES < <(find . -type f -not -path "*/\($EXCLUDE_DIRS\)/*" | fzf --multi)

# Exit if no files were selected
if [ ${#SELECTED_FILES[@]} -eq 0 ]; then
  echo "No files selected. Exiting."
  rm "$TEMP_FILE"
  exit 0
fi

echo "Selected ${#SELECTED_FILES[@]} file(s)"

# Current working directory for relative paths
CWD=$(pwd)

# Process each selected file
for FILE in "${SELECTED_FILES[@]}"; do
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

# Create a temporary prompt file
PROMPT_FILE=$(mktemp)
echo "# Enter your prompt below" > "$PROMPT_FILE"
echo "" >> "$PROMPT_FILE"
echo "# Save and quit (:wq) when done" >> "$PROMPT_FILE"

# Open the prompt file in nvim
nvim "$PROMPT_FILE"

# Check if the prompt file has content beyond the initial template
PROMPT_CONTENT=$(grep -v "^# " "$PROMPT_FILE" | sed '/^$/d')

if [ -n "$PROMPT_CONTENT" ]; then
  # Add the prompt to the temp file with a header
  echo -e "### Prompt\n" >> "$TEMP_FILE"
  cat "$PROMPT_FILE" | grep -v "^# " >> "$TEMP_FILE"
fi

# Copy the contents of the temp file to clipboard
cat "$TEMP_FILE" | wl-copy
echo "Context and prompt copied to clipboard!"

# Clean up temporary files
rm "$TEMP_FILE" "$PROMPT_FILE"
echo "Temporary files removed."
