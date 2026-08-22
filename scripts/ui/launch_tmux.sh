#!/usr/bin/env bash

SESSION_NAME="home"
STARTUP_LOCK="${TMPDIR:-/tmp}/tmux-${UID}-startup.lock"
STARTUP_LOCK_DIR="${STARTUP_LOCK}.d"
STARTUP_LOCK_METHOD=""
RESTORE_SCRIPT="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tmux-resurrect/scripts/restore.sh"

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

# Serialize startup so several terminals opened at login cannot race tmux-continuum.
acquire_startup_lock() {
  if command -v shlock >/dev/null 2>&1; then
    STARTUP_LOCK_METHOD="shlock"
    until shlock -f "$STARTUP_LOCK" -p "$$"; do
      sleep 0.05
    done
  elif command -v flock >/dev/null 2>&1; then
    STARTUP_LOCK_METHOD="flock"
    exec 9>"$STARTUP_LOCK"
    flock 9
  else
    STARTUP_LOCK_METHOD="mkdir"
    until mkdir "$STARTUP_LOCK_DIR" 2>/dev/null; do
      sleep 0.05
    done
  fi
}

release_startup_lock() {
  case "$STARTUP_LOCK_METHOD" in
    shlock)
      rm -f "$STARTUP_LOCK"
      ;;
    flock)
      flock -u 9
      exec 9>&-
      ;;
    mkdir)
      rmdir "$STARTUP_LOCK_DIR" 2>/dev/null || true
      ;;
  esac
  STARTUP_LOCK_METHOD=""
}

acquire_startup_lock
trap release_startup_lock EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

STARTED_SERVER="false"

# A tmux server cannot exist without a session when exit-empty is enabled.
if ! tmux list-sessions >/dev/null 2>&1; then
  if tmux new-session -d -s "$SESSION_NAME" \
    \; source-file "$HOME/System/dotfiles/.config/tmux/startup-appendix.conf"; then
    STARTED_SERVER="true"
  else
    printf 'tmux: failed to start the server\n' >&2
    exit 1
  fi
elif ! tmux has-session -t "=$SESSION_NAME" 2>/dev/null; then
  tmux new-session -d -s "$SESSION_NAME"
fi

# Restore exactly once, while other terminal launches are still locked out.
if [[ "$STARTED_SERVER" == "true" ]]; then
  if [[ -x "$RESTORE_SCRIPT" ]]; then
    tmux run-shell "$RESTORE_SCRIPT"
  else
    printf 'tmux: restore script not found: %s\n' "$RESTORE_SCRIPT" >&2
  fi
fi

release_startup_lock
trap - EXIT HUP INT TERM

exec tmux attach-session -t "=$SESSION_NAME"
