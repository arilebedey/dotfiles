#!/usr/bin/env bash

# Script to list directories using fzf, exclude specified ones,
# save the selected path to a file, and ensure the script always stays
# in the directory it was run from.

# Define the top-level and nested directories to be excluded
top_level_dirs=(".local/share" ".nvm/versions/node" "Backups/OBSIDIAN" ".tmux/plugins")
nested_dirs=("node_modules" ".git" "obsidian-notes")

# Store the current working directory
original_dir=$(pwd)

# Change to the home directory
cd "$HOME" || { echo "Failed to change directory to home"; exit 1; }

# Build the find exclusion pattern for top-level directories
top_level_pattern=""
for dir in "${top_level_dirs[@]}"; do
  top_level_pattern+=" -path './$dir' -o"
done

# Build the find exclusion pattern for nested directories
nested_pattern=""
for dir in "${nested_dirs[@]}"; do
  nested_pattern+=" -path '*/$dir' -o"
done

# Combine the patterns and remove the trailing -o
exclude_pattern="${top_level_pattern} ${nested_pattern}"
exclude_pattern=${exclude_pattern::-3}

# Use find to list directories, exclude the specified ones, and use fzf for selection
selected_dir=$(eval "find . -type d \( $exclude_pattern \) -prune -o -type d -print" | fzf)

# Change back to the original directory
cd "$original_dir" || { echo "Failed to change back to original directory"; exit 1; }

# Check if a directory was selected
if [ -n "$selected_dir" ]; then
  # Handle case where home directory is selected
  if [ "$selected_dir" = "." ]; then
    selected_dir="$HOME"
  else
    # Convert selected_dir to an absolute path
    selected_dir="$HOME/${selected_dir#./}"
  fi

  # Overwrite the save location file with the selected directory
  echo "$selected_dir" > /home/ari/System/scripts/images/save-clip-2-png-location.txt
else
  echo "No directory selected."
fi

