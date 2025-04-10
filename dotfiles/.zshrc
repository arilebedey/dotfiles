## STARSHIP
eval "$(starship init zsh)"

## ZINIT
source /home/ari/System/scripts/shell/zsh/zinit.sh

## NVM
source /home/ari/System/scripts/shell/zsh/nvm.sh

## PLUGINS
source /home/ari/System/scripts/shell/zsh/plugins.sh

## ZSH OPTS
source /home/ari/System/scripts/shell/zsh/zshopts.sh

## OTHER CONFIG IMPORTS
# Aliases
source /home/ari/.zshaliases
source /home/ari/.keys.sh
# Functions
source /home/ari/System/scripts/shell/zsh/functions_.sh
# Scripts
source /home/ari/System/scripts/shell/zsh/fzf2nvim.sh
source /home/ari/System/scripts/shell/zsh/tmux_choose.sh
source /home/ari/System/scripts/shell/zsh/yazi.sh
# Keybindings
source /home/ari/System/scripts/shell/zsh/keybinds.sh

## PLUGIN (keep at the end!)
source /home/ari/System/scripts/shell/zsh/plugins-end.sh

## SECRETS
source /home/ari/System/scripts/shell/zsh/secrets.sh

# Created by `pipx` on 2025-03-09 23:29:27
export PATH="$PATH:/home/ari/.local/bin"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
