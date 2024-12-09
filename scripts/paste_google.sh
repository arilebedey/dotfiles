#!/usr/bin/bash

# Get the content of the clipboard
SEARCH_TERM=$(wl-paste)

# Check if SEARCH_TERM is empty
if [ -z "$SEARCH_TERM" ]; then
    echo "Clipboard is empty. Exiting."
    exit 1
fi

# Encode the search term for URL
ENCODED_SEARCH_TERM=$(echo "$SEARCH_TERM" | sed 's/ /+/g')

# Open Chromium and search Google
zen-browser "https://www.google.com/search?q=$ENCODED_SEARCH_TERM"

