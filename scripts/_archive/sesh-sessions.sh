# function sesh-sessions() {
#   {
#     exec </dev/tty
#     exec <&1
#     local session
#     session=$(sesh list -t -c | fzf --height 40% --border-label ' sesh ' --border --prompt '⚡  ')
#     [[ -z "$session" ]] && return
#     sesh connect $session
#   }
# }
#
# zle     -N             sesh-sessions
# bindkey -M emacs '\ew' sesh-sessions
# bindkey -M vicmd '\ew' sesh-sessions
# bindkey -M viins '\ew' sesh-sessions
