#!/usr/bin/env bash

SESSION_NAME="home"
# tmux="/opt/homebrew/bin/tmux"
tmux="tmux"

# Ensure Homebrew bin is in PATH (for tmux installed via brew)
if [[ -d "/opt/homebrew/bin" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
elif [[ -d "/usr/local/bin" ]]; then
  export PATH="/usr/local/bin:$PATH"
fi

# Fix TERM if ghostty terminfo is missing
if [[ "$TERM" == "ghostty" ]] && ! infocmp ghostty >/dev/null 2>&1; then
  export TERM="xterm-256color"
fi

# Check if the session exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  # Attach to the existing session
  exec tmux attach-session -t "$SESSION_NAME"
else
  # Create a new session and load config
  exec tmux new-session -d -s "$SESSION_NAME" \
    \; source-file "$HOME/System/dotfiles/.config/tmux/startup-appendix.conf" \
    \; attach-session -t "$SESSION_NAME"
fi
