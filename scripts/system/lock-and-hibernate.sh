#!/bin/bash

/home/ari/Code/configs/Bashes/sdbunmount &&

# Lock the screen with Hyprlock
sudo hyprctl dispatch exec "hyprlock" && sleep 0.5 && systemctl suspend
