#!/bin/bash

# Paths
SOURCE="/Users/ari/System/dotfiles/.config/lazygit/config.yml"
TARGET="$HOME/Library/Application Support/lazygit/config.yml"

# Ensure target directory exists
mkdir -p "$(dirname "$TARGET")"

# Initial sync at startup
cp "$SOURCE" "$TARGET"
echo "Initial sync done: $SOURCE -> $TARGET"

# Watch for changes and sync
fswatch -o "$SOURCE" | while read -r; do
  echo "Change detected, updating config..."
  cp "$SOURCE" "$TARGET"
done
