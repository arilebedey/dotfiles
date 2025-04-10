# Rofi Favorites - Quick Access to Your Favorite Websites

## Overview

Rofi Favorites is a customizable launcher script that provides quick keyboard access to your favorite websites. It displays a clean, icon-based menu of websites using the Rofi application launcher, allowing you to quickly navigate to frequently used sites without using a mouse.

![Rofi Favorites Screenshot](https://placeholder-image.com/rofi-favorites.png)

## Features

- **Website Icons**: Automatically downloads and displays official website icons
- **Customizable Order**: Easily arrange websites in your preferred order
- **Keyboard Navigation**: Fully keyboard-accessible (no mouse required)
- **Fast Access**: Launch with a keyboard shortcut for instant access
- **Clean Interface**: Integrates with your existing Rofi theme
- **Self-maintaining**: Automatically downloads missing icons when needed

## Installation

### Prerequisites

Make sure you have the following installed:
- Rofi (`sudo apt install rofi` or equivalent for your distribution)
- curl (`sudo apt install curl`)
- Optional: ImageMagick for better icon handling (`sudo apt install imagemagick`)

### Setup

1. Download the script:
   ```bash
   mkdir -p ~/scripts
   wget https://raw.githubusercontent.com/yourusername/rofi-favorites/main/rofi-favorites.sh -O ~/scripts/rofi-favorites.sh
   chmod +x ~/scripts/rofi-favorites.sh
   ```

2. Run the script with the `--update` flag to download icons:
   ```bash
   ~/scripts/rofi-favorites.sh --update
   ```

3. Test the script by running:
   ```bash
   ~/scripts/rofi-favorites.sh
   ```

## Keyboard Shortcut Setup

To launch Rofi Favorites with a keyboard shortcut:

### For i3wm:
Add to your i3 config file (`~/.config/i3/config`):
```
bindsym $mod+b exec --no-startup-id ~/scripts/rofi-favorites.sh
```

### For GNOME:
1. Open Settings → Keyboard → Keyboard Shortcuts
2. Click the '+' button to add a new shortcut
3. Set a name (e.g., "Web Favorites")
4. Set the command to: `~/scripts/rofi-favorites.sh`
5. Set your preferred keyboard shortcut (e.g., `Super+B`)

### For KDE Plasma:
1. Go to System Settings → Shortcuts → Custom Shortcuts
2. Click "Edit" → "New" → "Global Shortcut" → "Command/URL"
3. Name it "Web Favorites"
4. Set the command as `~/scripts/rofi-favorites.sh`
5. Set your trigger (e.g., `Meta+B`)

## Customization

### Adding or Removing Websites

Edit the script with your text editor to modify the `WEBSITES` array:

```bash
nano ~/scripts/rofi-favorites.sh
```

Find the `WEBSITES` section and modify it to include your favorite sites:

```bash
WEBSITES=(
    "GitHub|https://github.com|github.png|10"
    "YouTube|https://youtube.com|youtube.png|20"
    "Reddit|https://reddit.com|reddit.png|30"
    # Add your sites here using the format:
    "Name|URL|IconFilename|OrderNumber"
)
```

- **Name**: Display name in the menu
- **URL**: Website address to open
- **IconFilename**: Filename for the icon (will be downloaded automatically)
- **OrderNumber**: Position in the menu (lower numbers appear first)

After making changes, run the script with the `--update` flag:

```bash
~/scripts/rofi-favorites.sh --update
```

### Changing the Order

To rearrange your websites, simply change the order numbers in the `WEBSITES` array. The numbers are spaced by 10 (10, 20, 30) to make it easy to insert new items between existing ones.

For example, to add a new site between GitHub (10) and YouTube (20):

```bash
"GitLab|https://gitlab.com|gitlab.png|15"
```

### Custom Icons

If you want to use custom icons instead of downloaded ones:

1. Place your custom icons in `~/.config/rofi/website-icons/`
2. Make sure the icon filename matches what you specified in the `WEBSITES` array
3. Run the script normally (it will use your custom icons)

## Advanced Customization

### Rofi Theme Integration

The script uses your existing Rofi theme. To customize the appearance:

1. Create or edit your Rofi theme file (e.g., `~/.config/rofi/config.rasi`)
2. Adjust the styling according to your preferences
3. For better scrolling, add these lines:
   ```
   configuration {
       scroll-method: 1;
       scroll-step: 5;
   }
   ```

### Changing Icon Size

If icons appear too large or too small, modify the icon processing function in the script:

Find the line that contains `-resize 48x48` and change `48x48` to your desired dimensions (e.g., `32x32` for smaller icons).

## Troubleshooting

### Icons Not Showing

If icons aren't displaying:

1. Make sure you have proper icon support:
   ```bash
   sudo apt install librsvg2-bin
   ```

2. Force an icon update:
   ```bash
   ~/scripts/rofi-favorites.sh --update
   ```

3. Check if the icons were downloaded:
   ```bash
   ls -la ~/.config/rofi/website-icons/
   ```

### Script Not Working

If the script doesn't run:

1. Ensure it's executable:
   ```bash
   chmod +x ~/scripts/rofi-favorites.sh
   ```

2. Check for dependencies:
   ```bash
   which rofi curl
   ```

3. Check the script for errors:
   ```bash
   bash -x ~/scripts/rofi-favorites.sh
   ```

## Adding Your Own Categories

For more advanced setups, you can create category-based website groups by modifying the desktop file creation:

1. Add a category identifier to your website entries
2. Modify the script to create separate Rofi instances for each category
3. Set up keyboard shortcuts for each category

## Contributing

Feel free to improve this script and share your enhancements with the community!

## License

This script is provided under the MIT License. Feel free to modify and distribute it as needed.
