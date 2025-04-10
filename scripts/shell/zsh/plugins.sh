# zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::sudo
# zsh-you-should-use
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
# fast-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
# zinit light zsh-users/zsh-completions
# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
# zsh-history-substring-search
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit load 'zsh-users/zsh-history-substring-search'
zinit ice wait atload '_history_substring_search_config'
source /home/ari/System/scripts/shell/zsh/shell-command-switcher.sh
source /home/ari/System/scripts/edit-desktop-entry.sh
