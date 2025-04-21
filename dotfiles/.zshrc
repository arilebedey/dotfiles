## STARSHIP
eval "$(starship init zsh)"

## ZINIT
source /home/ari/System/scripts/zsh/zinit.sh

## NVM
source /home/ari/System/scripts/zsh/nvm.sh

## PLUGINS
source /home/ari/System/scripts/zsh/plugins.sh

## ZSH OPTS
source /home/ari/System/scripts/zsh/zshopts.sh

## OTHER CONFIG IMPORTS
# Aliases
source /home/ari/.zshaliases
source /home/ari/.keys.sh
source /home/ari/System/scripts/zsh/function_aliases.sh
source /home/ari/System/scripts/zsh/scripts.sh
# Functions
source /home/ari/System/scripts/zsh/functions_.sh
# Scripts
source /home/ari/System/scripts/zsh/fzf2nvim.sh
source /home/ari/System/scripts/zsh/tmux_choose.sh
source /home/ari/System/scripts/zsh/yazi.sh
# Keybindings
source /home/ari/System/scripts/zsh/keybinds.sh

## PLUGIN (keep at the end!)
source /home/ari/System/scripts/zsh/plugins-end.sh

## SECRETS
source /home/ari/config/keys/secrets.sh

# Created by `pipx` on 2025-03-09 23:29:27
export PATH="$PATH:/home/ari/.local/bin"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
