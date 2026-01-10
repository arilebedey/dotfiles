if [ "$(whoami)" = "alebedev" ]; then
  eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
  export PATH=$HOME/local/bin:$PATH
  export PATH=$PATH:/home/alebedev/.local/share/soar/bin
  eval "$(zoxide init zsh)"
  eval "$(~/homebrew/bin/brew shellenv)"
  export PATH=$HOME/bin:$PATH
  xset r rate 250 60
  source /home/alebedev/System/scripts/system/launch_ft_lock.sh
  bluetoothctl show | grep -q "Powered: no" && bluetoothctl power on
fi

# Check if running on Wayland or X11 and use appropriate clipboard tool
if [[ -n $WAYLAND_DISPLAY ]]; then
  # Already using Wayland, so wl-copy is appropriate
  # No need for an alias in this case
else
  # On X11, alias wl-copy to xclip
  alias wl-copy='xclip -selection clipboard'
  alias wl-paste='xclip -selection clipboard -o'
fi

if [ "$HOST" = "ls" ]; then
  eval "$(direnv hook zsh)"
fi
