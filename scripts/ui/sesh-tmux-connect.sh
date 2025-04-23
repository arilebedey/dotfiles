#!/bin/bash

if [ "$(whoami)" = "alebedev" ]; then
  export PATH="/home/alebedev/homebrew/bin:$PATH"
  /home/alebedev/homebrew/bin/sesh connect "$(/home/alebedev/homebrew/bin/sesh list -t | /usr/bin/fzf-tmux -p 50%,50%)"
else
  sesh connect "$(sesh list -t | fzf-tmux -p 50%,50%)"
fi
