# Enable pipx completions
autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"



# Load completions
autoload -Uz compinit && compinit
eval "$(zoxide init zsh)"
