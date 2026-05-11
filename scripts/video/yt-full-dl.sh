#!/usr/bin/env bash
set -euo pipefail

HISTORY_FILE="$HOME/.ydl_history"
touch "$HISTORY_FILE"

export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export LANG="${LANG:-en_US.UTF-8}"

use_current_dir=false
dry_run=false
url=""
target_dir=""

# ─── Resume Logic ────────────────────────────────────────────────────────────
if [[ $# -eq 0 && -s "$HISTORY_FILE" ]]; then
  if gum confirm "Resume a previous download?"; then
    selected="$(
      tac "$HISTORY_FILE" |
        fzf --prompt="Select previous task > " --height=15 --reverse --border
    )"

    if [[ -n "${selected:-}" ]]; then
      target_dir="$(printf '%s\n' "$selected" | sed -E 's/^Target: (.*) \| URL: .* \| Date: .*$/\1/')"
      url="$(printf '%s\n' "$selected" | sed -E 's/^Target: .* \| URL: (.*) \| Date: .*$/\1/')"

      url="$(printf '%s' "$url" | tr -d '\r\n')"
      target_dir="$(printf '%s' "$target_dir" | tr -d '\r\n')"

      echo "Resuming URL: $url"
      echo "Target Directory: $target_dir"
    fi
  fi
fi

# ─── Argument Parsing ────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--current-dir)
      use_current_dir=true
      ;;
    -d|--dry-run)
      dry_run=true
      ;;
    http*)
      url="$1"
      ;;
  esac
  shift
done

# ─── Inputs ──────────────────────────────────────────────────────────────────
if [[ -z "$url" ]]; then
  url="$(gum input --width=100 --placeholder "Paste URL here (ESC to abort)")"
fi

: "${url:?URL is required.}"

if [[ -z "$target_dir" ]]; then
  if "$use_current_dir"; then
    target_dir="$PWD"
  else
    set +e
    parent_dir="$(
      find "$HOME/Downloads" "$HOME/Videos" "$HOME/Movies" "$HOME/data" /Volumes \
        -maxdepth 3 -type d 2>/dev/null |
        fzf --height 40% --layout=reverse --border \
          --prompt='📂 Select Destination: ' \
          --preview 'ls -F {} | head -20'
    )"
    set -e

    [[ -z "${parent_dir:-}" ]] && echo "Aborting." && exit 1

    subfolder_name="$(gum input --width=100 --placeholder "Name the subfolder (Leave empty to use parent)")"

    if [[ -z "$subfolder_name" ]]; then
      target_dir="$parent_dir"
    else
      target_dir="$parent_dir/$subfolder_name"
    fi
  fi
fi

mkdir -p "$target_dir"

# ─── Browser Cookies ─────────────────────────────────────────────────────────
COOKIE_FLAG=(--cookies-from-browser chrome)

archive_file="$target_dir/archive.txt"
touch "$archive_file"

# ─── Build yt-dlp Command ────────────────────────────────────────────────────
ytcmd=(
  yt-dlp
  -f "bestvideo[height<=1080]+bestaudio/best"
  --embed-thumbnail
  --windows-filenames
  --embed-metadata
  --yes-playlist
  --lazy-playlist
  --continue
  --ignore-errors
  --download-archive "$archive_file"
  -P "$target_dir"
  -o "%(uploader)s - %(upload_date)s - %(title)s.%(ext)s"
  "${COOKIE_FLAG[@]}"
  --limit-rate 1M
  --min-sleep-interval 10
  --max-sleep-interval 50
  --sleep-requests 2
  --retries 5
  --retry-sleep exp=5:60
  --fragment-retries 5
)

# ─── History Logging ─────────────────────────────────────────────────────────
history_line="Target: $target_dir | URL: $url | Date: $(date '+%Y-%m-%d %H:%M')"

if "$dry_run"; then
  echo "--- DRY RUN MODE ---"
  ytcmd+=(--simulate --print "%(playlist_index)s | %(title)s: %(filesize_approx,filesize!s)s")
else
  echo "--- LIVE DOWNLOAD MODE ---"

  if ! grep -Fq "Target: $target_dir | URL: $url |" "$HISTORY_FILE"; then
    printf '%s\n' "$history_line" >> "$HISTORY_FILE"
  fi
fi

# ─── Playlist Length Detection ───────────────────────────────────────────────
get_total_items() {
  yt-dlp \
    --flat-playlist \
    --lazy-playlist \
    --print "%(id)s" \
    "${COOKIE_FLAG[@]}" \
    "$url" 2>/dev/null |
    awk 'NF' |
    wc -l |
    tr -d ' '
}

archive_count() {
  [[ -f "$archive_file" ]] || {
    echo 0
    return
  }

  wc -l < "$archive_file" | tr -d ' '
}

random_between() {
  local min="$1"
  local max="$2"
  echo $(( RANDOM % (max - min + 1) + min ))
}

# ─── Random Range Download Logic ─────────────────────────────────────────────
download_random_ranges() {
  total_items="$(get_total_items)"

  if [[ -z "$total_items" || "$total_items" -lt 1 ]]; then
    echo "Could not determine playlist/channel size."
    echo "Falling back to normal yt-dlp run."
    echo "────────────────────────────────────────────────────────────────────────────"

    "${ytcmd[@]}" "$url"
    return
  fi

  echo "Detected $total_items playlist/channel items."
  echo "Downloading random sequential ranges."
  echo "Range starts are random playlist positions."
  echo "Range length is random from 1-8 videos."
  echo "Already-downloaded items are skipped by:"
  echo "$archive_file"
  echo "────────────────────────────────────────────────────────────────────────────"

  no_progress_rounds=0
  max_no_progress_rounds=$(( total_items * 3 ))

  while true; do
    before_count="$(archive_count)"

    if [[ "$before_count" -ge "$total_items" ]]; then
      echo
      echo "Archive count reached detected playlist size: $before_count/$total_items"
      echo "Done."
      break
    fi

    range_size="$(random_between 1 8)"
    start="$(random_between 1 "$total_items")"
    end=$(( start + range_size - 1 ))

    if [[ "$end" -gt "$total_items" ]]; then
      end="$total_items"
    fi

    echo
    echo "Random range: $start-$end"
    echo "Range length requested: $range_size"
    echo "Actual range length: $(( end - start + 1 ))"
    echo "Archive progress: $before_count/$total_items"
    echo "────────────────────────────────────────────────────────────────────────────"

    set +e
    "${ytcmd[@]}" \
      --playlist-start "$start" \
      --playlist-end "$end" \
      "$url"
    yt_status=$?
    set -e

    after_count="$(archive_count)"

    if [[ "$after_count" -gt "$before_count" ]]; then
      no_progress_rounds=0
    else
      no_progress_rounds=$(( no_progress_rounds + 1 ))
      echo "No new archive progress this round. Streak: $no_progress_rounds/$max_no_progress_rounds"
    fi

    if [[ "$yt_status" -ne 0 ]]; then
      echo "yt-dlp exited with status $yt_status for this range; continuing because --ignore-errors is enabled."
    fi

    if [[ "$no_progress_rounds" -ge "$max_no_progress_rounds" ]]; then
      echo
      echo "Stopped after $no_progress_rounds random ranges with no archive progress."
      echo "Some remaining items may be unavailable, private, region-locked, age-gated, or already failed."
      echo "Current archive count: $(archive_count)/$total_items"
      break
    fi
  done
}

# ─── Run ─────────────────────────────────────────────────────────────────────
echo "Target: $target_dir"
echo "────────────────────────────────────────────────────────────────────────────"

if "$dry_run"; then
  "${ytcmd[@]}" "$url"
else
  download_random_ranges
fi
