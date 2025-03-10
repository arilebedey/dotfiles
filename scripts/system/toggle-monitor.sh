#!/bin/bash

# Check if the monitor is currently enabled
if hyprctl monitors | grep -q "eDP-2"; then
    # If enabled, disable it
    hyprctl keyword monitor "eDP-2,disable"
    notify-send "Monitor eDP-2" "Disabled"
else
    # If disabled, enable it with the specified configuration
    hyprctl keyword monitor "eDP-2,2560x1440,0x0,1"
    notify-send "Monitor eDP-2" "Enabled"
fi
