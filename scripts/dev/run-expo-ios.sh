#!/usr/bin/env bash
set -euo pipefail

# Requirements: fzf, jq, xcrun, npx

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "$1 not found" >&2
    exit 1
  }
}
need xcrun
need fzf
need jq
need npx

JSON="$(xcrun simctl list devices booted --json)"

# Build a newline-separated list: "Name<TAB>UDID"
ITEMS="$(printf "%s" "$JSON" | jq -r '
  .devices
  | to_entries[]
  | .value[]
  | select(.state=="Booted")
  | "\(.name)\t\(.udid)"
')"

if [ -z "$ITEMS" ]; then
  echo "No booted simulators found. Boot one in Simulator first." >&2
  exit 1
fi

# Format columns for display, feed to fzf
CHOICE="$(printf "%s\n" "$ITEMS" \
  | awk -F'\t' '{printf "%-22s %s\n", $1, $2}' \
  | fzf --prompt="Select booted simulator: " --height=40% --reverse || true)"

if [ -z "${CHOICE:-}" ]; then
  echo "Selection cancelled." >&2
  exit 1
fi

# Extract UDID (last whitespace-separated field)
UDID="$(printf "%s" "$CHOICE" | awk '{print $NF}')"

echo "Running on simulator UDID: $UDID"
npx expo run:ios --device "$UDID"
