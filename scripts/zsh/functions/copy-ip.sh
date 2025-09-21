# ---------------------------------------------------------------
# copy_ip - Get primary IPv4 address and copy it to clipboard
# ---------------------------------------------------------------
copy_ip() {
    # Get the IP address using ip command (exclude loopback)
    local IP
    IP=$(ip -4 addr show scope global | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)

    # Check if an IP was found
    if [ -z "$IP" ]; then
        echo "No IP address found."
        return 1
    fi

    # Try clipboard tools
    if command -v wl-copy &> /dev/null; then
        echo -n "$IP" | wl-copy
        echo "IP address $IP copied to clipboard using wl-copy."
    elif command -v xclip &> /dev/null; then
        echo -n "$IP" | xclip -selection clipboard
        echo "IP address $IP copied to clipboard using xclip."
    elif command -v xsel &> /dev/null; then
        echo -n "$IP" | xsel -b
        echo "IP address $IP copied to clipboard using xsel."
    # Support macOS pbcopy
    elif command -v pbcopy &> /dev/null; then
        echo -n "$IP" | pbcopy
        echo "IP address $IP copied to clipboard using pbcopy."
    # Support Windows/WSL
    elif command -v clip.exe &> /dev/null; then
        echo -n "$IP" | clip.exe
        echo "IP address $IP copied to clipboard using clip.exe."
    else
        echo "IP address is: $IP"
        echo "Could not copy to clipboard. Please install wl-copy, xclip, xsel, pbcopy, or clip.exe."
        return 1
    fi
}

# Aliases to make it quick
alias copyip='copy_ip'
alias cip='copy_ip'
alias myip='copy_ip'
