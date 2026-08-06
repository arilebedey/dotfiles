#!/usr/bin/env bash
set -euo pipefail

use_current_dir=false
url=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--current-dir)
      use_current_dir=true
      shift
      ;;
    -h|--help)
      echo "Usage: $(basename "$0") [-c|--current-dir] URL"
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
    *)
      if [[ -n "$url" ]]; then
        echo "Give exactly one URL." >&2
        exit 2
      fi
      url="$1"
      shift
      ;;
  esac
done

: "${url:?Give a video URL}"

for command_name in yt-dlp; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Missing required command: $command_name" >&2
    exit 1
  fi
done

if $use_current_dir; then
  target_dir="$PWD"
  echo "Using current directory: $target_dir"
else
  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf is required unless --current-dir is used." >&2
    exit 1
  fi

  set +e
  target_dir=$(
    find "$HOME/Downloads" "$HOME/Videos" "$HOME/Movies" "$HOME/data" /Volumes \
      -type d 2>/dev/null |
      fzf --prompt='Download to > '
  )
  set -e

  if [[ -z "$target_dir" ]]; then
    echo "No directory selected. Aborting." >&2
    exit 1
  fi
  echo "Selected directory: $target_dir"
fi

ytcmd=(
  yt-dlp
  --no-playlist
  -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]"
  --merge-output-format mp4
  --remux-video mp4
  --embed-thumbnail
  --embed-metadata
  --download-archive "$target_dir/.yt-dlp-archive.txt"
  -P "$target_dir"
  -o "%(uploader_id,uploader|video)s-%(title).80B.%(ext)s"
  "$url"
)

echo "Downloading with yt-dlp..."
"${ytcmd[@]}"
