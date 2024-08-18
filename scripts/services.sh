#!/bin/bash

# Automounter for removable media
udiskie &

# Pyprland Daemon
# pypr --debug /tmp/pypr.log &

# Notification Daemon
dunst &

# Notify about devices connecting and disconnecting
# devify &

# Idle daemon to screen lock
hypridle &

# Clipboard
## Those to were in hyrpland.conf
# wl-paste --primary --watch cliphist store --primary &
# wl-paste --watch cliphist store
## This was here
# wl-paste --type image --watch cliphist store & #Stores only image data
# wl-paste --watch cliphist store &

# Polkit authentication
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

echo $(timedatectl status) > ~/log_services.txt
echo "SUCCESS" >> ~/log_services.txt
