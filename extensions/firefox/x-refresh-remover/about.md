# X Refresh Button Remover

A simple Firefox extension that removes the pill-shaped refresh button from X (formerly Twitter).

## Overview

This lightweight extension hides the refresh button that appears in the X interface. The refresh button takes up valuable space in the UI and can be redundant since refreshing the feed can be done by:

- Pressing F5 or Ctrl+R to refresh the entire page
- Scrolling to the top of your feed where a "Show new posts" button often appears
- Using the pull-to-refresh gesture on touch devices

## Features

- Removes only the refresh button, leaving all other UI elements intact
- Works on both twitter.com and x.com domains
- No performance impact as it uses simple CSS to hide the element
- No data collection or tracking
- No external dependencies
- Minimal resource usage

## Installation

### Method 1: Temporary Installation (For Testing)

1. Download the files from this repository
2. Open Firefox
3. Type `about:debugging` in the address bar
4. Click on "This Firefox" in the left sidebar
5. Click "Load Temporary Add-on..."
6. Navigate to the downloaded files and select the manifest.json file
7. The extension will be installed and active immediately

Note: Temporary installations will be removed when you restart Firefox.

### Method 2: Permanent Installation

1. Download the files
2. Zip the files (manifest.json and remove-refresh.css)
3. Rename the .zip file to "x-refresh-remover.xpi"
4. Open Firefox
5. Type `about:addons` in the address bar
6. Click the gear icon and select "Install Add-on From File..."
7. Select your x-refresh-remover.xpi file
8. Click "Add" when prompted

## Files

The extension consists of just two files:

- `manifest.json`: Configuration file that tells Firefox about the extension
- `remove-refresh.css`: CSS styles that hide the refresh button

## How It Works

The extension uses CSS selectors to target and hide the refresh button element on X's interface. It accomplishes this by injecting a CSS file into pages on the twitter.com and x.com domains.

The CSS targets various possible implementations of the refresh button, including those identified by:
- Data attributes
- ARIA labels
- Role attributes
- SVG path content

This approach ensures compatibility across different versions of X's interface and is resilient to minor UI changes.

## Compatibility

- Firefox: Works on current and recent versions
- X/Twitter: Compatible with the current interface as of April 2025

## Troubleshooting

If the refresh button is still visible after installing the extension:

1. Make sure the extension is enabled in Firefox's add-ons manager
2. Try refreshing or reloading the X/Twitter page
3. Check if X has updated its interface, which might require an update to the extension

## License

This extension is released under the MIT License. Feel free to modify and distribute as needed.

## Privacy

This extension:
- Does not collect any user data
- Does not communicate with any external servers
- Does not modify any content other than hiding the refresh button
- Requires only the minimum permissions needed to function

## Contributing

If X updates its interface and the extension no longer works properly, feel free to update the CSS selectors in the remove-refresh.css file to target the new implementation of the refresh button.
