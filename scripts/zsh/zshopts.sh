WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export EDITOR=nvim
export VISUAL=nvim
# export TERM=xterm-kitty
export TERM=ghostty
HISTFILE=~/.local/.zshhistory
HISTSIZE=30000
SAVEHIST=30000
XDG_CONFIG_HOME=/home/ari/.config
# writes to history from all terminals as above, but that history "will not be available immediately from other instances of the shell that are using the same history file"
setopt INC_APPEND_HISTORY_TIME
# Java for RN
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH="$PATH:/home/ari/Android/Sdk/emulator"
# NestJS
export PATH=$PATH:$(npm config get prefix)/bin
# Theme
export GTK_THEME='Adwaita-dark'
# Disable bracketed paste
# unset zle_bracketed_paste
unsetopt BEEP
# Disable flow control (Ctrl+S, Ctrl+Q)
stty -ixon
