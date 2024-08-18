#!/usr/bin/env bash

# Define the path to the file that contains the save directory location
LOCATION_FILE="/home/ari/System/scripts/images/save-clip-2-png-location.txt"

# Check for the -l flag
if [ "$1" == "-l" ]; then
    if [ -f "$LOCATION_FILE" ]; then
        SAVE_DIR=$(cat "$LOCATION_FILE")
        notify-send "Current Save Directory" "$SAVE_DIR"
    else
        notify-send "Error" "Location file not found."
    fi
    exit 0
fi

# Read the save directory from the file
if [ -f "$LOCATION_FILE" ]; then
    SAVE_DIR=$(cat "$LOCATION_FILE")
else
    echo "Error: Location file not found. Using default directory."
    SAVE_DIR="/home/ari/Images/Clipboard"
fi

# Create the directory if it doesn't exist
mkdir -p "$SAVE_DIR"

# Prompt the user for a name using rofi
NAME=$(rofi -dmenu -p "Image name?")

# Define the output file name based on the user's input
if [ -z "$NAME" ]; then
    echo "Error: No name provided. Aborting."
    exit 1
else
    OUTPUT_FILE="${SAVE_DIR}/${NAME}.png"
fi

# Get the last clipboard entry using cliphist and save it as an image
cliphist list -n 1 | cliphist decode | magick - "$OUTPUT_FILE"

# Check if the file was created successfully
if [ -f "$OUTPUT_FILE" ]; then
    echo "Image saved as $OUTPUT_FILE"
else
    echo "Failed to save image"
fi

