#!/bin/zsh
set -euo pipefail

APP_SUPPORT="$HOME/Library/Application Support/AirDrop Router"
PLIST_PATH="$HOME/Library/LaunchAgents/com.arilebedey.airdrop-router.plist"

launchctl bootout "gui/$UID" "$PLIST_PATH" 2>/dev/null || true
if [[ -f "$PLIST_PATH" ]]; then
  mv "$PLIST_PATH" "$HOME/.Trash/com.arilebedey.airdrop-router.plist"
fi
if [[ -d "$APP_SUPPORT/bin" ]]; then
  mv "$APP_SUPPORT/bin" "$HOME/.Trash/AirDrop Router bin"
fi

echo "AirDrop Router worker removed. Its configuration and logs remain in $APP_SUPPORT."
