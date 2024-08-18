WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export EDITOR=nvim
export VISUAL=nvim
export TERM=xterm-kitty
HISTFILE=~/.local/.zshhistory
HISTSIZE=30000
SAVEHIST=30000
XDG_CONFIG_HOME=/home/ari/.config
# writes to history from all terminals as above, but that history "will not be available immediately from other instances of the shell that are using the same history file"
setopt INC_APPEND_HISTORY_TIME
