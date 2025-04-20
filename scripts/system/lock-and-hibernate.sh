#!/bin/bash

# /home/ari/Code/configs/Bashes/sdbunmount &

# Lock the screen with Hyprlock
hyprctl dispatch exec "hyprlock" && sleep 1 && systemctl suspend
