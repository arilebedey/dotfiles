if [ -f "$HOME/.system-envs" ]; then
  source "$HOME/.system-envs"
fi

### 42 Configs
source $HOME/System/scripts/zsh/42.sh

## STARSHIP
eval "$(starship init zsh)"

## ZINIT
source $HOME/System/scripts/zsh/zinit.sh

## NVM
source $HOME/System/scripts/zsh/nvm.sh

## PLUGINS
source $HOME/System/scripts/zsh/plugins.sh

## ZSH OPTS
source $HOME/System/scripts/zsh/zshopts.sh

## OTHER CONFIG IMPORTS
# Aliases
source $HOME/.zshaliases
source $HOME/.keys.sh
# Functions
source $HOME/System/scripts/zsh/functions.sh
# Scripts
source $HOME/System/scripts/zsh/scripts.sh
# Scripts
source $HOME/System/scripts/zsh/fzf2nvim.sh
# Keybindings
source $HOME/System/scripts/zsh/keybinds.sh

## PLUGIN (keep at the end!)
source $HOME/System/scripts/zsh/plugins-end.sh

## SECRETS
source $HOME/.config/keys/secrets.sh
source $HOME/System/scripts/zsh/secrets.sh

# Created by `pipx` on 2025-03-09 23:29:27
export PATH="$PATH:/home/ari/.local/bin"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/System/macos/exec:$PATH"

# Macos GNU Stow Op
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
bindkey -e
# Op End
export PATH=/home/alebedev/.local/funcheck/host:$PATH
