mz() {
  # Check if the user provided a directory path as an argument
  if [ -z "$1" ]; then
    echo "Usage: mz <directory>"
    return 1
  fi

  # Create the directory with -p to avoid errors if it already exists
  mkdir -p "$1"

  # Change to the newly created directory using z
  z "$1"
}

tx() {
    if [ -z "$1" ]; then
        echo "Usage: touchx <filename>"
        return 1
    fi
    touch "$1" && chmod +x "$1"
    echo "Created and made executable: $1"
}

# Function to run llm without activating the whole environment
llm() {
  $HOME/llm-env/bin/llm "$@"
}

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --border-label ' sesh ' --border --prompt '⚡  ')
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\ew' sesh-sessions
bindkey -M vicmd '\ew' sesh-sessions
bindkey -M viins '\ew' sesh-sessions

### TEST
# Create a function to run nvim
run_nvim() {
  BUFFER="nvim"
  zle accept-line
}
# Register the function as a widget
zle -N run_nvim
# Bind Ctrl+E to the widget
bindkey '^E' run_nvim

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

git-copy-latest-diff() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not inside a git repository."
    return 1
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    git diff HEAD~1 HEAD | pbcopy
    echo "Latest commit diff copied to clipboard (macOS)."
  else
    # Linux (requires xclip or xsel)
    if command -v xclip >/dev/null 2>&1; then
      git diff HEAD~1 HEAD | xclip -selection clipboard
      echo "Latest commit diff copied to clipboard (Linux, xclip)."
    elif command -v xsel >/dev/null 2>&1; then
      git diff HEAD~1 HEAD | xsel --clipboard --input
      echo "Latest commit diff copied to clipboard (Linux, xsel)."
    else
      echo "No clipboard tool found. Install xclip or xsel."
      return 1
    fi
  fi
}
