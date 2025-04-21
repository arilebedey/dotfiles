#!/bin/bash

# Check if the monitor is currently disabled
if ! hyprctl monitors | grep -q "eDP-2"; then
    # If disabled, enable it with the specified configuration
    hyprctl keyword monitor "eDP-2,2560x1440,0x0,1"
    notify-send "Monitor eDP-2" "Enabled"
else
    # If enabled, disable it
    hyprctl keyword monitor "eDP-2,disable"
    notify-send "Monitor eDP-2" "Disabled"
fi
