#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy Last Screenshot
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Screenshot Tools

# Directory where screenshots are stored
screenshot_dir="/Users/ari/Images/Screenshots"

# Find the most recent screenshot file
screenshot=$(ls -t "$screenshot_dir"/Screenshot*.png 2>/dev/null | head -n 1)

# Check if a screenshot exists
if [[ -n "$screenshot" ]]; then
  # Copy the screenshot to the clipboard
  osascript -e "set the clipboard to (read (POSIX file \"$screenshot\") as JPEG picture)"
  echo "Copied: $(basename "$screenshot")"
else
  echo "No screenshot found in $screenshot_dir."
fi

# Close Raycast
osascript -e 'tell application "Raycast" to hide'
