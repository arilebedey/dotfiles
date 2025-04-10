#!/bin/bash

# Lock the screen with Hyprlock
hyprctl dispatch exec "hyprlock"

# Wait for the lock screen to activate
sleep 1

# Hibernate the system
systemctl suspend
