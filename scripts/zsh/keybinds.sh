bindkey "^E" forward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Control + Backspace Setting
bindkey '^H' backward-kill-word
bindkey '^B' backward-kill-word

# Shift-Tab
bindkey '^[[Z' autosuggest-accept
bindkey '^[[27;2;9~' autosuggest-accept

# interupt sig
stty intr ^P
# stty intr '^C'


# map ctrl+c  copy_to_clipboard # in kitty.conf
bindkey '^K' clear-screen
bindkey '^U' clear-screen
