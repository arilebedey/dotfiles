#!/bin/zsh
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/recently-airdropped-file" >&2
  exit 64
fi

PROJECT_ROOT="${0:A:h:h}"
INSTALLED_WORKER="$HOME/Library/Application Support/AirDrop Router/bin/airdrop-router-worker"
LOCAL_WORKER="$PROJECT_ROOT/worker/.build/release/airdrop-router-worker"

if [[ -x "$INSTALLED_WORKER" ]]; then
  WORKER="$INSTALLED_WORKER"
else
  swift build --disable-sandbox --package-path "$PROJECT_ROOT/worker" --configuration release --scratch-path "$PROJECT_ROOT/worker/.build"
  WORKER="$LOCAL_WORKER"
fi

"$WORKER" --diagnose "$1"
