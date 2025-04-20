tmux_choose_session() {
  # Get the list of tmux sessions
  local sessions=$(tmux list-sessions -F "#{session_name}")

  # Check if there are any tmux sessions available
  if [ -z "$sessions" ]; then
    echo "No tmux sessions found."
    return 1
  fi

  # Use fzf to choose a tmux session
  local selected_session=$(echo "$sessions" | fzf --prompt="Select tmux session: ")

  # Check if a session was selected
  if [ -n "$selected_session" ]; then
    # Check if we are inside a tmux session
    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$selected_session"
    else
      tmux attach-session -t "$selected_session"
    fi
  else
    echo "No tmux session selected."
  fi
}

