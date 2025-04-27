#!/bin/bash
# Save current session name
SESSION=$(tmux display-message -p "#S")

# Create a new window and remember its name (using window name is more stable than index)
tmux new-window -c "$PWD"
KEEP_WINDOW=$(tmux display-message -p "#I")

# First approach: Keep killing the first window until only our window remains
WINDOW_COUNT=$(tmux list-windows -t "$SESSION" | wc -l)
while [ "$WINDOW_COUNT" -gt 1 ]; do
  # Get the index of the first window
  FIRST_WIN=$(tmux list-windows -t "$SESSION" -F "#I" | head -1)
  
  # If first window is our window to keep, get the second one instead
  if [ "$FIRST_WIN" = "$KEEP_WINDOW" ]; then
    FIRST_WIN=$(tmux list-windows -t "$SESSION" -F "#I" | head -2 | tail -1)
  fi
  
  # Kill the window
  tmux kill-window -t "$SESSION:$FIRST_WIN"
  
  # Update window count
  WINDOW_COUNT=$(tmux list-windows -t "$SESSION" | wc -l)
done
