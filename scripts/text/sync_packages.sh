#!/bin/bash

# Directories and files
PACMAN_FILE1="/home/ari/Information/system-history/packages/pacman_packages.txt"
YAY_FILE1="/home/ari/Information/system-history/packages/aur_packages.txt"
PACMAN_FILE2="/home/ari/System/arch-packages/pacman_packages.txt"
YAY_FILE2="/home/ari/System/arch-packages/aur_packages.txt"
LOG_FILE="/home/ari/Information/system-history/scripts-logs/LOG_PACKAGE_SYNC.log"

# Ensure the target directories exist
mkdir -p /home/ari/Information/system-history/packages
mkdir -p /home/ari/System/arch-packages
mkdir -p /home/ari/Information/system-history/scripts-logs

# Get current date and time
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Redirect stdout and stderr to log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Log the start time
echo "[$TIMESTAMP] Starting package sync"

# Export pacman package list excluding AUR packages
echo "[$TIMESTAMP] Exporting pacman package list to $PACMAN_FILE1 and $PACMAN_FILE2"
if pacman -Qqe | grep -vxFf <(pacman -Qqm) | tee "$PACMAN_FILE1" > "$PACMAN_FILE2"; then
    echo "[$TIMESTAMP] Successfully exported pacman package list"
else
    echo "[$TIMESTAMP] Failed to export pacman package list"
fi

# Export yay AUR package list
echo "[$TIMESTAMP] Exporting yay AUR package list to $YAY_FILE1 and $YAY_FILE2"
if pacman -Qqm | tee "$YAY_FILE1" > "$YAY_FILE2"; then
    echo "[$TIMESTAMP] Successfully exported yay AUR package list"
else
    echo "[$TIMESTAMP] Failed to export yay AUR package list"
fi

# Log the end time
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] Finished package sync"

