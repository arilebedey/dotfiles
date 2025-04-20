#!/bin/bash
# This script uses tmux socket to send commands directly

# Function to find the tmux socket for the current user
find_tmux_socket() {
  # Try to find the socket in common locations
  for socket in /tmp/tmux-$UID/default /tmp/tmux-*/default /tmp/tmux.*; do
    if [ -S "$socket" ]; then
      echo "$socket"
      return 0
    fi
  done
  return 1
}

# Try direct tmux command if we're in a tmux session
if [ -n "$TMUX" ]; then
  tmux kill-window
  exit 0
fi

# Find the tmux socket
socket=$(find_tmux_socket)
if [ -n "$socket" ]; then
  # Send command through the socket
  tmux -S "$socket" kill-window
  exit 0
fi

# Fall back to wtype method if above methods fail
hyprctl -P dispatch exec "wtype -M ctrl a -m ctrl"
sleep 0.2
hyprctl -P dispatch exec "wtype w"

exit 0
