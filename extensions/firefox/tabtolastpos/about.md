# Tab Mover

## Overview
Tab Mover is a lightweight browser extension that allows you to instantly move your current tab to the last position in your browser window with a simple keyboard shortcut.

## Features
- Move any active tab to the end of your tab bar with a single keyboard shortcut (Alt+U)
- Works in any browser window
- No configuration needed
- Minimal permissions required (only needs access to tabs)

## How It Works
When you press Alt+U while browsing, the extension identifies your current tab and moves it to the last position in your browser window. This is particularly useful when you want to:

- Organize your workflow by moving less important tabs to the end
- Quickly rearrange tabs without drag-and-drop
- Clean up your tab bar by pushing reference tabs to the end

## Installation
1. Download the extension files
2. Load as an unpacked extension in your browser's extension management page
3. The Alt+U shortcut is ready to use immediately

## Technical Details
Tab Mover is built with the WebExtensions API and works with any browser that supports this standard, including Firefox and Chromium-based browsers like Chrome, Edge, and Brave.

The extension requires minimal permissions, only requesting access to the tabs API to perform its single function.

## Source Code
The extension consists of just two files:
- `manifest.json`: Defines the extension metadata and permissions
- `background.js`: Contains the logic to move the current tab to the last position

## License
This extension is released under the MIT License. Feel free to modify and distribute as needed.

## Feedback and Contributions
For feature requests, bug reports, or contributions, please open an issue on the project's repository.
