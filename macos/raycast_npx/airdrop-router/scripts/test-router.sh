#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="${0:A:h:h}"
BUILD_PATH="$PROJECT_ROOT/worker/.build"
WORKER="$BUILD_PATH/release/airdrop-router-worker"

swift build --disable-sandbox --package-path "$PROJECT_ROOT/worker" --configuration release --scratch-path "$BUILD_PATH"
"$WORKER" --self-test

TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/airdrop-router-test.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT
mkdir -p "$TEST_ROOT/downloads" "$TEST_ROOT/destination"
printf 'test transfer' > "$TEST_ROOT/downloads/sample.txt"
printf '{"version":1,"enabled":true,"destinationPath":"%s","recentDestinations":[],"updatedAt":"test"}\n' "$TEST_ROOT/destination" > "$TEST_ROOT/config.json"

AIRDROP_ROUTER_DOWNLOADS_PATH="$TEST_ROOT/downloads" \
AIRDROP_ROUTER_CONFIG_PATH="$TEST_ROOT/config.json" \
AIRDROP_ROUTER_LOG_PATH="$TEST_ROOT/router.log" \
AIRDROP_ROUTER_DISABLE_NOTIFICATIONS=1 \
  "$WORKER" --route-test "$TEST_ROOT/downloads/sample.txt"

[[ -f "$TEST_ROOT/destination/sample.txt" ]]
[[ ! -e "$TEST_ROOT/downloads/sample.txt" ]]
echo "AirDrop Router isolated routing test passed"

# Exercise the live watcher and its AirDrop-only metadata filter.
printf 'ordinary download' > "$TEST_ROOT/downloads/already-present.txt"
: > "$TEST_ROOT/watcher.log"
AIRDROP_ROUTER_DOWNLOADS_PATH="$TEST_ROOT/downloads" \
AIRDROP_ROUTER_CONFIG_PATH="$TEST_ROOT/config.json" \
AIRDROP_ROUTER_LOG_PATH="$TEST_ROOT/watcher.log" \
AIRDROP_ROUTER_DISABLE_NOTIFICATIONS=1 \
  "$WORKER" --watch &
WORKER_PID=$!
trap 'kill "$WORKER_PID" 2>/dev/null || true; rm -rf "$TEST_ROOT"' EXIT

for _ in {1..20}; do
  grep -q "Worker started" "$TEST_ROOT/watcher.log" && break
  sleep 0.1
done

printf 'ordinary new download' > "$TEST_ROOT/downloads/not-airdrop.txt"
printf 'simulated AirDrop' > "$TEST_ROOT/downloads/airdrop-sample.txt"
xattr -w com.apple.quarantine '0083;test;sharingd;' "$TEST_ROOT/downloads/airdrop-sample.txt"

for _ in {1..30}; do
  [[ -f "$TEST_ROOT/destination/airdrop-sample.txt" ]] && break
  sleep 0.25
done

kill "$WORKER_PID" 2>/dev/null || true
wait "$WORKER_PID" 2>/dev/null || true

[[ -f "$TEST_ROOT/destination/airdrop-sample.txt" ]]
[[ -f "$TEST_ROOT/downloads/not-airdrop.txt" ]]
[[ -f "$TEST_ROOT/downloads/already-present.txt" ]]
echo "AirDrop Router live watcher test passed"
