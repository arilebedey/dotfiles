#!/bin/bash

echo "$(date) Lid closed" >> /tmp/lid-close.log

# Lock the screen with Hyprlock
hyprctl dispatch exec "hyprlock"

sleep 1 && hyprctl dispatch dpms off
