#!/usr/bin/env python3
"""
Rofi Favorites - Quick Access to Your Favorite Websites
A clean, icon-based menu using Rofi for quick keyboard access to favorite websites.
"""

import os
import sys
import subprocess
import json
from pathlib import Path
import requests
from typing import Dict, List, Tuple, Optional
import shutil

# Configuration paths
HOME = Path.home()
ICON_DIR = HOME / ".config/rofi/website-icons"
DESKTOP_DIR = HOME / ".local/share/applications/rofi-favorites"
CONFIG_FILE = HOME / ".config/rofi/favorites-config.json"

# Ensure directories exist
ICON_DIR.mkdir(parents=True, exist_ok=True)
DESKTOP_DIR.mkdir(parents=True, exist_ok=True)

# Define favorite websites with their names, URLs, icon filenames, and order
DEFAULT_WEBSITES = [
    {"name": "Telegram", "url": "https://web.telegram.org", "icon": "telegram.png", "order": 10},
    {"name": "Claude", "url": "https://claude.ai", "icon": "claude.png", "order": 20},
    {"name": "X", "url": "https://twitter.com", "icon": "twitter.png", "order": 30},
    {"name": "GitHub", "url": "https://github.com", "icon": "github.png", "order": 40},
    {"name": "Discord", "url": "https://discord.com", "icon": "discord.png", "order": 50},
    {"name": "YouTube", "url": "https://youtube.com", "icon": "youtube.png", "order": 60},
    {"name": "Reddit", "url": "https://reddit.com", "icon": "reddit.png", "order": 70},
    {"name": "Google Drive", "url": "https://drive.google.com", "icon": "gdrive.png", "order": 80},
    {"name": "Gmail", "url": "https://mail.google.com", "icon": "gmail.png", "order": 90},
    {"name": "Wikipedia", "url": "https://wikipedia.org", "icon": "wikipedia.png", "order": 100},
]

# Common icon URLs for popular websites
ICON_URLS = {
    "github.png": "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
    "youtube.png": "https://www.youtube.com/s/desktop/8f593214/img/favicon_144x144.png",
    "reddit.png": "https://www.redditstatic.com/desktop2x/img/favicon/android-icon-192x192.png",
    "twitter.png": "https://abs.twimg.com/responsive-web/web/icon-default.604e2486a34a2f6e.png",
    "netflix.png": "https://assets.nflxext.com/ffe/siteui/common/icons/nficon2016.png",
    "gdrive.png": "https://ssl.gstatic.com/docs/doclist/images/drive_2022q3_32dp.png",
    "gmail.png": "https://ssl.gstatic.com/ui/v1/icons/mail/rfr/gmail.ico",
    "spotify.png": "https://open.spotifycdn.com/cdn/images/favicon.0f31d2ea.ico",
    "amazon.png": "https://www.amazon.com/favicon.ico",
    "wikipedia.png": "https://en.wikipedia.org/static/favicon/wikipedia.ico",
    "telegram.png": "https://telegram.org/img/favicon.ico",
    "claude.png": "https://claude.ai/favicon.ico",
    "discord.png": "https://discord.com/assets/847541504914fd33810e70a0ea73177e.ico",
}


def load_config() -> List[Dict]:
    """Load website configuration from file or use defaults."""
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, OSError) as e:
            print(f"Error loading config file: {e}")
            print("Using default configuration")
            return DEFAULT_WEBSITES
    else:
        # First run, write default config
        save_config(DEFAULT_WEBSITES)
        return DEFAULT_WEBSITES


def save_config(websites: List[Dict]) -> None:
    """Save website configuration to file."""
    try:
        with open(CONFIG_FILE, 'w') as f:
            json.dump(websites, f, indent=2)
    except OSError as e:
        print(f"Error saving config file: {e}")


def download_missing_icons(websites: List[Dict]) -> None:
    """Download website icons if they don't exist locally."""
    for site in websites:
        icon_name = site["icon"]
        icon_path = ICON_DIR / icon_name
        if not icon_path.exists() and icon_name in ICON_URLS:
            print(f"Downloading icon: {icon_name}")
            try:
                response = requests.get(ICON_URLS[icon_name], stream=True)
                response.raise_for_status()
                with open(icon_path, 'wb') as icon_file:
                    response.raw.decode_content = True
                    shutil.copyfileobj(response.raw, icon_file)
            except requests.exceptions.RequestException as e:
                print(f"Error downloading {icon_name}: {e}")


def process_icons(websites: List[Dict]) -> None:
    """Process icons to ensure proper format and size for Rofi."""
    # Check if ImageMagick is installed
    if not shutil.which("convert"):
        print("ImageMagick not found. Icons will not be resized.")
        return

    for site in websites:
        icon_name = site["icon"]
        icon_path = ICON_DIR / icon_name
        if icon_path.exists():
            # Resize icon to 48x48 for Rofi
            try:
                subprocess.run(
                    ["convert", str(icon_path), "-resize", "48x48", f"{str(icon_path)}.tmp"],
                    check=True
                )
                shutil.move(f"{str(icon_path)}.tmp", str(icon_path))
            except subprocess.SubprocessError as e:
                print(f"Error processing icon {icon_name}: {e}")


def create_desktop_files(websites: List[Dict]) -> None:
    """Create desktop files for Rofi launcher."""
    # Remove old desktop files
    for file in DESKTOP_DIR.glob("*.desktop"):
        file.unlink()
    
    # Sort websites by order
    sorted_websites = sorted(websites, key=lambda x: x["order"])
    
    # Create new desktop files
    for site in sorted_websites:
        name = site["name"]
        url = site["url"]
        icon_name = site["icon"]
        order = site["order"]
        
        icon_path = ICON_DIR / icon_name
        desktop_file = DESKTOP_DIR / f"{str(order).zfill(3)}_{name.replace(' ', '_')}.desktop"
        
        desktop_content = f"""[Desktop Entry]
Type=Application
Name={name}
Exec=xdg-open "{url}"
Icon={icon_path}
Categories=Rofi;Favorites;
Terminal=false
"""
        with open(desktop_file, 'w') as f:
            f.write(desktop_content)


def launch_rofi() -> None:
    """Launch Rofi with favorite websites."""
    try:
        subprocess.run(
            ["rofi", "-show", "drun", "-drun-categories", "Favorites", "-i", "-p", "Favorites"],
            check=True
        )
    except subprocess.SubprocessError as e:
        print(f"Error launching Rofi: {e}")
        sys.exit(1)


def reorder_website(websites: List[Dict], name: str, new_order: int) -> List[Dict]:
    """Change the order of a website."""
    for site in websites:
        if site["name"].lower() == name.lower():
            site["order"] = new_order
    return websites


def add_website(websites: List[Dict], name: str, url: str, icon: str, order: int) -> List[Dict]:
    """Add a new website to the list."""
    new_site = {"name": name, "url": url, "icon": icon, "order": order}
    websites.append(new_site)
    return websites


def remove_website(websites: List[Dict], name: str) -> List[Dict]:
    """Remove a website from the list."""
    return [site for site in websites if site["name"].lower() != name.lower()]


def print_website_list(websites: List[Dict]) -> None:
    """Print the list of websites in order."""
    sorted_websites = sorted(websites, key=lambda x: x["order"])
    print("\nCurrent Website Order:")
    print("-" * 50)
    for site in sorted_websites:
        print(f"{site['order']:3d}. {site['name']} ({site['url']})")
    print("-" * 50)


def main() -> None:
    """Main function to run the script."""
    # Load configuration
    websites = load_config()
    
    # Check for command line arguments
    if len(sys.argv) > 1:
        if sys.argv[1] == "--update":
            download_missing_icons(websites)
            process_icons(websites)
            create_desktop_files(websites)
            print("Icons and desktop files updated successfully.")
            return
        elif sys.argv[1] == "--list":
            print_website_list(websites)
            return
        elif sys.argv[1] == "--add" and len(sys.argv) >= 6:
            name = sys.argv[2]
            url = sys.argv[3]
            icon = sys.argv[4]
            order = int(sys.argv[5])
            websites = add_website(websites, name, url, icon, order)
            save_config(websites)
            print(f"Added {name} at position {order}")
            print_website_list(websites)
            return
        elif sys.argv[1] == "--remove" and len(sys.argv) >= 3:
            name = sys.argv[2]
            websites = remove_website(websites, name)
            save_config(websites)
            print(f"Removed {name}")
            print_website_list(websites)
            return
        elif sys.argv[1] == "--reorder" and len(sys.argv) >= 4:
            name = sys.argv[2]
            order = int(sys.argv[3])
            websites = reorder_website(websites, name, order)
            save_config(websites)
            print(f"Moved {name} to position {order}")
            print_website_list(websites)
            return
        elif sys.argv[1] == "--help":
            print("""
Rofi Favorites - Quick Access to Your Favorite Websites

Usage:
  rofi-favorites.py                 Launch Rofi with favorite websites
  rofi-favorites.py --update        Update icons and desktop files
  rofi-favorites.py --list          List all websites in order
  rofi-favorites.py --add NAME URL ICON ORDER   Add a new website
  rofi-favorites.py --remove NAME   Remove a website
  rofi-favorites.py --reorder NAME ORDER   Change a website's position
  rofi-favorites.py --help          Show this help message
            """)
            return

    # Regular run
    download_missing_icons(websites)
    process_icons(websites)
    create_desktop_files(websites)
    launch_rofi()


if __name__ == "__main__":
    main()
