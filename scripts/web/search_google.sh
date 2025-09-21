#!/usr/bin/bash

# Define custom width and height for the rofi window
ROFI_WIDTH="70"
ROFI_HEIGHT="6"

# Prompt user for input using rofi with custom width and height
SEARCH_TERM=$(echo -e "" | rofi -dmenu -p "Enter Google 🪿 search:" -theme-str 'window { width: '$ROFI_WIDTH'%; height: '$ROFI_HEIGHT'%; }')

# Check if SEARCH_TERM is empty
if [ -z "$SEARCH_TERM" ]; then
    echo "No search term entered. Exiting."
    exit 1
fi

# Encode the search term for URL
ENCODED_SEARCH_TERM=$(echo "$SEARCH_TERM" | sed 's/ /+/g')

# Open Chromium
# /opt/google/chrome/chrome "https://www.google.com/search?q=$ENCODED_SEARCH_TERM"
# Open Zen
zen-browser "https://www.google.com/search?q=$ENCODED_SEARCH_TERM"

