#!/usr/bin/bash

# Directories to monitor
MONITOR_DIRS=(
    "/home/ari/Downloads/"               # Change this to the first directory you want to monitor
    "/home/ari/Images/Clipboard"     # Second directory to monitor
)

# Obsidian image folder
OBSIDIAN_DIR="/home/ari/Information/obsidian-notes/_ Files/Obsidian Screenshot Files"

# Monitor for new files with image extensions
inotifywait -m -e create --format '%w%f' "${MONITOR_DIRS[@]}" | while read NEWFILE
do
    if [[ "${NEWFILE}" =~ \.(jpg|jpeg|png|gif|bmp|tiff|webp|svg|heic|heif)$ ]]; then
        FILENAME=$(basename "${NEWFILE}")
        RESPONSE=$(echo -e "Yes\nNo" | rofi -dmenu -p "Move ${FILENAME} to Obsidian folder?")
        
        if [[ "${RESPONSE}" == "Yes" ]]; then
            mv "${NEWFILE}" "${OBSIDIAN_DIR}"
            notify-send "Image moved" "${FILENAME} has been moved to the Obsidian folder."
        else
            notify-send "Image not moved" "${FILENAME} was not moved."
        fi
    fi
done
