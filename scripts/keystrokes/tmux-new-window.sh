#!/bin/bash

# This script simulates Ctrl-a followed by n in tmux under Hyprland
# It uses Hyprland's dispatch command to send key events

# Send Ctrl+a (tmux prefix)
hyprctl dispatch exec "wtype -M ctrl a -m ctrl"

# Small delay to ensure keystrokes are processed in sequence
sleep 0.03

# Send n (next window command)
hyprctl dispatch exec "wtype t"

# Exit with success
exit 0
