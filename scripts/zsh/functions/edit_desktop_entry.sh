# Function to edit desktop entries
# Add this to your .zshrc or source it selectively
edit_desktop_entry() {
  # Ensure the user's applications directory exists
  mkdir -p ~/.local/share/applications/

  # First, use fzf to select a command from history (if desired)
  if [[ "$1" == "--with-history" ]]; then
    local selected_command=$(fc -l 1 | fzf --height 40% --border --prompt="Select command from history: " | sed 's/^[0-9]\+\s\+//')
    
    if [[ -n "$selected_command" ]]; then
      echo "Selected command: $selected_command"
      # Uncomment to save selected command to a variable or file if needed
      # echo "$selected_command" > /tmp/last_selected_command
    fi
  fi

  # Use fzf to select a desktop entry file from system applications
  local selected_desktop_file=$(find /usr/share/applications -name "*.desktop" | fzf --preview "cat {}" --height 60% --border --prompt="Select desktop file: ")

  # Exit if no file was selected
  if [[ -z "$selected_desktop_file" ]]; then
    echo "No desktop file selected. Exiting."
    return 1
  fi

  # Get just the filename without the path
  local filename=$(basename "$selected_desktop_file")

  # Copy the selected file to user's applications directory
  cp "$selected_desktop_file" ~/.local/share/applications/

  # Confirm the copy
  echo "Copied $filename to ~/.local/share/applications/"

  # Open the copied file with nvim
  nvim ~/.local/share/applications/"$filename"
}

# Optional shorthand alias
alias ede="edit_desktop_entry"
