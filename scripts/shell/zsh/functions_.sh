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

# Alias to use the function
alias ts='sesh-sessions'
alias ta='source /home/ari/System/scripts/ui/launch_tmux.sh'
alias d='source /home/ari/System/scripts/ui/fzf-cd.sh'
alias tn='source /home/ari/System/scripts/ui/fzf_cd_or_tmux.sh'
alias wpng='source /home/ari/System/scripts/images/write-save-png-location.sh'
alias spng='/home/ari/System/scripts/images/save-clip-2-png.sh'
alias gpng='/home/ari/System/scripts/images/save-clip-2-png.sh -l'
