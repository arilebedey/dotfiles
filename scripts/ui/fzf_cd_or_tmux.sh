#!/usr/bin/env bash

# fzf_cd_or_tmux.sh
# Script to list directories using fzf, exclude specified ones, prompt for a tmux session name if desired,
# and create a tmux session. If run inside a tmux session, it creates the session without attaching to it
# and changes back to the original directory. Otherwise, it creates the session and attaches to it.

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
exclude_pattern="${exclude_pattern% -o}"

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

  # Ensure the selected directory exists and change to it
  if cd "$selected_dir"; then
    # Refetch the full path using pwd
    selected_dir=$(pwd)
    
    # Get the directory name for default session name
    default_session_name=$(basename "$selected_dir" | tr '.' '_')

    # Prompt the user for a tmux session name using gum
    session_name=$(gum input --width=160 --placeholder "Tmux session creation at $selected_dir. Specify name (ENTER for '$default_session_name', ESC to abort)")

    # If user pressed ESC, session_name will be empty and we abort
    # If user pressed ENTER without input, use the default_session_name
    if [ -n "$session_name" ] || [ "$session_name" = "" ]; then
      # Use default name if empty input
      if [ -z "$session_name" ]; then
        session_name="$default_session_name"
      fi
      
      # Check if the script is running inside a tmux session
      if [ -n "$TMUX" ]; then
        # Create the tmux session but do not attach to it
        tmux new-session -d -s "$session_name" -c "$selected_dir"
        echo "Tmux session '$session_name' created at $selected_dir. You may attach to it."

        # Change back to the original directory
        cd "$original_dir"
      else
        # Create the tmux session and attach to it
        tmux new-session -d -s "$session_name" -c "$selected_dir"
        tmux attach-session -t "$session_name"
      fi
    fi
  else
    echo "Failed to change directory to $selected_dir"
    exit 1
  fi
else
  echo "No directory selected."
fi
