bindkey "^E" forward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Control + Backspace Setting
bindkey '^H' backward-kill-word
bindkey '^B' backward-kill-word

# Shift-Tab
bindkey '^[[Z' autosuggest-accept
bindkey '^[[27;2;9~' autosuggest-accept

# Shift-Enter inserts a newline without accepting the command
shift_enter_newline() {
  LBUFFER+=$'\n'
}

zle -N shift_enter_newline
bindkey $'\e[13;2u' shift_enter_newline

# interupt sig
stty intr ^P
# stty intr '^C'


# map ctrl+c  copy_to_clipboard # in kitty.conf
bindkey '^K' clear-screen
bindkey '^U' clear-screen
