#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="${0:A:h:h}"
APP_SUPPORT="$HOME/Library/Application Support/AirDrop Router"
BIN_DIR="$APP_SUPPORT/bin"
BIN_PATH="$BIN_DIR/airdrop-router-worker"
PLIST_PATH="$HOME/Library/LaunchAgents/com.arilebedey.airdrop-router.plist"
BUILD_PATH="$PROJECT_ROOT/worker/.build"
LABEL="com.arilebedey.airdrop-router"

mkdir -p "$BIN_DIR" "$HOME/Library/LaunchAgents"

swift build --disable-sandbox --package-path "$PROJECT_ROOT/worker" --configuration release --scratch-path "$BUILD_PATH"
install -m 755 "$BUILD_PATH/release/airdrop-router-worker" "$BIN_PATH"

plutil -create xml1 "$PLIST_PATH"
plutil -insert Label -string "$LABEL" "$PLIST_PATH"
plutil -insert ProgramArguments -xml "<array><string>$BIN_PATH</string><string>--watch</string></array>" "$PLIST_PATH"
plutil -insert RunAtLoad -bool true "$PLIST_PATH"
plutil -insert KeepAlive -bool true "$PLIST_PATH"
plutil -insert ProcessType -string Background "$PLIST_PATH"
plutil -insert StandardOutPath -string "$APP_SUPPORT/worker.stdout.log" "$PLIST_PATH"
plutil -insert StandardErrorPath -string "$APP_SUPPORT/worker.stderr.log" "$PLIST_PATH"
plutil -insert EnvironmentVariables -xml "<dict><key>AIRDROP_ROUTER_DOWNLOADS_PATH</key><string>$HOME/Downloads</string><key>AIRDROP_ROUTER_CONFIG_PATH</key><string>$APP_SUPPORT/config.json</string><key>AIRDROP_ROUTER_LOG_PATH</key><string>$APP_SUPPORT/router.log</string></dict>" "$PLIST_PATH"

launchctl bootout "gui/$UID" "$PLIST_PATH" 2>/dev/null || true
launchctl bootstrap "gui/$UID" "$PLIST_PATH"
launchctl kickstart -k "gui/$UID/$LABEL"

cd "$PROJECT_ROOT"
if [[ ! -d node_modules ]]; then
  npm install
fi
npm run build

echo "Installed AirDrop Router worker and login agent."
echo "Run 'npm run dev' once from $PROJECT_ROOT to register the local extension with Raycast."
