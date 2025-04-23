# Enable pipx completions
autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit

# Only run if register-python-argcomplete exists
if command -v register-python-argcomplete &> /dev/null; then
  eval "$(register-python-argcomplete pipx)"
fi

# Load completions
autoload -Uz compinit && compinit
eval "$(zoxide init zsh)"
