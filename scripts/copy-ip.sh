#!/bin/bash

# Get the IP address using ip command (most modern Linux distros)
# This gets the primary IP address excluding loopback addresses
IP=$(ip -4 addr show scope global | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)

# Check if the IP was found
if [ -z "$IP" ]; then
    echo "No IP address found."
    exit 1
fi

# Copy to clipboard using wl-copy, xclip, or xsel
# Try wl-copy first (for Wayland)
if command -v wl-copy &> /dev/null; then
    echo -n "$IP" | wl-copy
    echo "IP address $IP copied to clipboard using wl-copy."
# Try xclip if wl-copy is not available
elif command -v xclip &> /dev/null; then
    echo -n "$IP" | xclip -selection clipboard
    echo "IP address $IP copied to clipboard using xclip."
# If xclip is not available, try xsel
elif command -v xsel &> /dev/null; then
    echo -n "$IP" | xsel -b
    echo "IP address $IP copied to clipboard using xsel."
# If none of the above are available
else
    echo "IP address is: $IP"
    echo "Could not copy to clipboard. Please install wl-copy, xclip, or xsel."
    exit 1
fi

exit 0
