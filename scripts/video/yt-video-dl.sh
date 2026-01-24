#!/usr/bin/env bash
set -euo pipefail

url=${1:?Give a YouTube/YouTube Music/youtu.be URL}

# Extract ID (channel, playlist, or video) from various URL forms
extract_id() {
  local input="$1"
  if [[ "$input" =~ channel/([A-Za-z0-9_-]+) ]]; then
    echo "${BASH_REMATCH[1]}" && return
  fi
  if [[ "$input" =~ /@([A-Za-z0-9_-]+) ]]; then
    echo "${BASH_REMATCH[1]}" && return
  fi
  if [[ "$input" =~ list=([A-Za-z0-9_-]+) ]]; then
    echo "${BASH_REMATCH[1]}" && return
  fi
  if [[ "$input" =~ v=([A-Za-z0-9_-]{11}) ]]; then
    echo "${BASH_REMATCH[1]}" && return
  fi
  if [[ "$input" =~ youtu\.be/([A-Za-z0-9_-]{11}) ]]; then
    echo "${BASH_REMATCH[1]}" && return
  fi
  echo "$input"
}

id=$(extract_id "$url")
echo "Extracted ID: $id"

# ─── Select target directory ────────────────────────────────────────────────
set +e

target_dir=$(
  find "$HOME/Downloads" "$HOME/Videos" "$HOME/Movies" "$HOME/data" /Volumes \
    -type d 2>/dev/null \
  | fzf --prompt='Download to > '
)

set -e

if [ -z "${target_dir}" ]; then
  echo "No directory selected. Aborting." >&2
  exit 1
fi
echo "Selected directory: $target_dir"

# ─── Build and run yt-dlp ────────────────────────────────────────────────────
ytcmd=(
  yt-dlp
  -f "bestvideo[height=1080]+bestaudio/best"
  --embed-thumbnail --embed-metadata
  --download-archive "$target_dir/.yt-dlp-archive.txt"
  -P "$target_dir"
  -o "%(uploader)s - %(upload_date)s - %(title)s.%(ext)s"
  "$url"
)

echo "Running command:"
printf '  %q\n' "${ytcmd[@]}"
echo "────────────────────────────────────────────────────────────────────────────"

"${ytcmd[@]}"
status=$?

if [ $status -eq 0 ]; then
  echo "yt-dlp finished successfully."
else
  echo "yt-dlp exited with error code $status."
fi
