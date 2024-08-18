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
# Functions
source /home/ari/System/scripts/shell/zsh/functions_.sh
# Scripts
source /home/ari/System/scripts/shell/zsh/fzf2nvim.sh
source /home/ari/System/scripts/shell/zsh/tmux_choose.sh
source /home/ari/System/scripts/shell/zsh/yazi.sh
# Keybinds
source /home/ari/System/scripts/shell/zsh/keybinds.sh

## PLUGIN (end)
source /home/ari/System/scripts/shell/zsh/plugins-end.sh