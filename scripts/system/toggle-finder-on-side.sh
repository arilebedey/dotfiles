#!/bin/bash

TOGGLE_FILE="/Users/ari/Library/Application Support/ToggleScripts/finder_on_side_toggle"

mkdir -p "$(dirname "$TOGGLE_FILE")"

send_key_press() {
  osascript -e "tell application \"System Events\" to keystroke (ASCII character ${key_code}) using {${modifiers}}"
}

if [ -f "$TOGGLE_FILE" ]; then
  osascript -e 'tell application "Finder" to make new Finder window'
  rm "$TOGGLE_FILE"
else
  touch "$TOGGLE_FILE"
fi
