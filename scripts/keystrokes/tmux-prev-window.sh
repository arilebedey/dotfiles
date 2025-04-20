#!/bin/bash

# Send Ctrl+a (tmux prefix)
hyprctl dispatch exec "wtype -M ctrl a -m ctrl"

# Small delay to ensure keystrokes are processed in sequence
sleep 0.03

# Send n (next window command)
hyprctl dispatch exec "wtype p"

# Exit with success
exit 0
