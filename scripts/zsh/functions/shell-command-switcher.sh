#!/bin/zsh
# Shell Command Switcher
# Save as shell-command-switcher.sh

# Define the command-switcher function
function cs() {
  # Text styling
  local YELLOW=$'\033[0;33m'
  local RESET=$'\033[0m'

  # Get the last command from history
  local HIST_CMD=$(fc -ln -1)
  
  if [[ "$HIST_CMD" == "cs" ]]; then
    # If last command was cs itself, get the one before it
    HIST_CMD=$(fc -ln -2 -2)
  fi
  
  if [[ -z "$HIST_CMD" ]]; then
    return 1
  fi

  # Extract command and arguments
  local ORIGINAL_CMD=$(echo "$HIST_CMD" | awk '{print $1}')
  local ARGS=$(echo "$HIST_CMD" | cut -d' ' -f2-)

  # Display only the last command and prompt
  echo "${YELLOW}Last command:${RESET} $ORIGINAL_CMD"
  echo -n "> "
  
  # Run fzf to select new command
  local NEW_CMD=$(which $(compgen -c | sort -u | fzf --height 40% --reverse))
  
  # Build new command with original arguments
  local NEW_COMMAND="$NEW_CMD $ARGS"
  
  # Place the command in the shell buffer without preview
  print -z "$NEW_COMMAND"
}
