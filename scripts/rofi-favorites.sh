#!/bin/bash
# Directory to store website icons
ICON_DIR="$HOME/.config/rofi/website-icons"
# Create icon directory if it doesn't exist
mkdir -p "$ICON_DIR"
# Define favorite websites with their names, URLs, and icon paths
# Format: "Name|URL|IconPath"
WEBSITES=(
    "Telegram|https://web.telegram.org|telegram.png"
    "Claude|https://claude.ai|claude.png"
    "X|https://twitter.com|twitter.png"
    "GitHub|https://github.com|github.png"
    "Discord|https://discord.com|discord.png"
    "YouTube|https://youtube.com|youtube.png"
    "Reddit|https://reddit.com|reddit.png"
    "Google Drive|https://drive.google.com|gdrive.png"
    "Gmail|https://mail.google.com|gmail.png"
    "Wikipedia|https://wikipedia.org|wikipedia.png"
)
# Function to download icon if it doesn't exist
download_missing_icons() {
    # Common icon URLs for popular websites
    declare -A ICON_URLS=(
        ["telegram.png"]="https://telegram.org/img/favicon.ico"
        ["github.png"]="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"
        ["youtube.png"]="https://www.youtube.com/s/desktop/8f593214/img/favicon_144x144.png"
        ["reddit.png"]="https://www.redditstatic.com/desktop2x/img/favicon/android-icon-192x192.png"
        ["twitter.png"]="https://abs.twimg.com/responsive-web/web/icon-default.604e2486a34a2f6e.png"
        ["netflix.png"]="https://assets.nflxext.com/ffe/siteui/common/icons/nficon2016.png"
        ["gdrive.png"]="https://ssl.gstatic.com/docs/doclist/images/drive_2022q3_32dp.png"
        ["gmail.png"]="https://ssl.gstatic.com/ui/v1/icons/mail/rfr/gmail.ico"
        ["spotify.png"]="https://open.spotifycdn.com/cdn/images/favicon.0f31d2ea.ico"
        ["amazon.png"]="https://www.amazon.com/favicon.ico"
        ["wikipedia.png"]="https://en.wikipedia.org/static/favicon/wikipedia.ico"
        ["claude.png"]="https://claude.ai/favicon.ico"
        ["discord.png"]="https://discord.com/assets/847541504914fd33810e70a0ea73177e.ico"
    )
    
    for website in "${WEBSITES[@]}"; do
        icon_name=$(echo "$website" | cut -d'|' -f3)
        if [ ! -f "$ICON_DIR/$icon_name" ] && [ -n "${ICON_URLS[$icon_name]}" ]; then
            echo "Downloading icon: $icon_name"
            curl -s "${ICON_URLS[$icon_name]}" -o "$ICON_DIR/$icon_name"
        fi
    done
}
# Function to ensure icons are properly formatted for Rofi
process_icons() {
    for website in "${WEBSITES[@]}"; do
        icon_name=$(echo "$website" | cut -d'|' -f3)
        icon_path="$ICON_DIR/$icon_name"
        
        # Convert icons to PNG format with proper size if needed
        if [ -f "$icon_path" ]; then
            # Ensure the icon is properly sized (48x48 works well with Rofi)
            if command -v convert >/dev/null 2>&1; then
                convert "$icon_path" -resize 48x48 "$icon_path.tmp" && mv "$icon_path.tmp" "$icon_path"
            fi
        fi
    done
}
# Function to create custom desktop files for rofi
create_desktop_files() {
    DESKTOP_DIR="$HOME/.local/share/applications/rofi-favorites"
    mkdir -p "$DESKTOP_DIR"
    
    # Remove old desktop files
    rm -f "$DESKTOP_DIR"/*.desktop
    
    for website in "${WEBSITES[@]}"; do
        name=$(echo "$website" | cut -d'|' -f1)
        url=$(echo "$website" | cut -d'|' -f2)
        icon=$(echo "$website" | cut -d'|' -f3)
        
        # Use absolute path for icon
        icon_path="$ICON_DIR/$icon"
        
        # Create a desktop file for each website
        cat > "$DESKTOP_DIR/${name// /_}.desktop" << EOF
[Desktop Entry]
Type=Application
Name=$name
Exec=xdg-open "$url"
Icon=$icon_path
Categories=Rofi;Favorites;
Terminal=false
EOF
    done
}
# We don't need these functions anymore since we're using drun mode
# which automatically launches the applications based on desktop files
# Check for --update flag to force icon download
if [[ "$1" == "--update" ]]; then
    download_missing_icons
    process_icons
    create_desktop_files
    echo "Icons and desktop files updated successfully."
    exit 0
fi
# Download icons if needed
download_missing_icons
# Process icons to ensure they work with Rofi
process_icons
# Create desktop files for Rofi
create_desktop_files
# Launch Rofi with only our custom desktop files
rofi -show drun -drun-categories Favorites -i -p "Favorites"
