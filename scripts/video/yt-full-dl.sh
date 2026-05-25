#!/usr/bin/env bash
set -euo pipefail

HISTORY_FILE="$HOME/.ydl_history"
touch "$HISTORY_FILE"

export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export LANG="${LANG:-en_US.UTF-8}"

use_current_dir=false
dry_run=false
audio_only=false
sequential_mode=false
url=""
target_dir=""

# ─── URL Normalization ───────────────────────────────────────────────────────
normalize_url() {
  local input_url="$1"
  local playlist_id=""

  if [[ "$input_url" == *"youtube.com/watch"* && "$input_url" == *"list="* ]]; then
    playlist_id="$(printf '%s\n' "$input_url" | sed -nE 's/.*[?&]list=([^&]+).*/\1/p')"
  elif [[ "$input_url" == *"youtube.com/playlist"* && "$input_url" == *"list="* ]]; then
    playlist_id="$(printf '%s\n' "$input_url" | sed -nE 's/.*[?&]list=([^&]+).*/\1/p')"
  fi

  if [[ -n "${playlist_id:-}" ]]; then
    printf 'https://www.youtube.com/playlist?list=%s\n' "$playlist_id"
  else
    printf '%s\n' "$input_url"
  fi
}

# ─── Resume Logic ────────────────────────────────────────────────────────────
if [[ $# -eq 0 && -s "$HISTORY_FILE" ]]; then
  if gum confirm "Resume a previous download?"; then
    set +e
    selected="$(
      tac "$HISTORY_FILE" |
        fzf --prompt="Select previous task > " --height=15 --reverse --border
    )"
    resume_pick_status=$?
    set -e

    if [[ "$resume_pick_status" -eq 0 && -n "${selected:-}" ]]; then
      target_dir="$(printf '%s\n' "$selected" | sed -E 's/^Target: (.*) \| URL: .* \| Date: .*$/\1/')"
      url="$(printf '%s\n' "$selected" | sed -E 's/^Target: .* \| URL: (.*) \| Date: .*$/\1/')"

      url="$(printf '%s' "$url" | tr -d '\r\n')"
      target_dir="$(printf '%s' "$target_dir" | tr -d '\r\n')"
      url="$(normalize_url "$url")"
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
    -a|--audio)
      audio_only=true
      ;;
    -s|--sequential)
      sequential_mode=true
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

url="$(printf '%s' "$url" | tr -d '\r\n')"
normalized_url="$(normalize_url "$url")"

if [[ "$normalized_url" != "$url" ]]; then
  echo "Normalized URL:"
  echo "$normalized_url"
fi

url="$normalized_url"

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

failed_file="$target_dir/failed.txt"
touch "$failed_file"

# ─── Build yt-dlp Command ────────────────────────────────────────────────────
ytcmd=(
  yt-dlp
  --windows-filenames
  --yes-playlist
  --lazy-playlist
  --continue
  --ignore-errors
  --download-archive "$archive_file"
  -P "$target_dir"
  "${COOKIE_FLAG[@]}"
  --limit-rate 1M
  --min-sleep-interval 10
  --max-sleep-interval 30
  --sleep-requests 2
  --retries 5
  --retry-sleep exp=5:60
  --fragment-retries 5
)

if "$audio_only"; then
  ytcmd+=(
    -f "ba/bestaudio"
    -x
    --audio-format m4a
    --embed-thumbnail
    --add-metadata
    -o "%(uploader)s - %(upload_date)s - %(title)s.%(ext)s"
  )
else
  ytcmd+=(
    -f "bestvideo[height<=1080]+bestaudio/best"
    --embed-thumbnail
    --embed-metadata
    -o "%(uploader)s - %(upload_date)s - %(title)s.%(ext)s"
  )
fi

# ─── History Logging ─────────────────────────────────────────────────────────
history_line="Target: $target_dir | URL: $url | Date: $(date '+%Y-%m-%d %H:%M')"
history_key="Target: $target_dir | URL: $url |"

if "$dry_run"; then
  echo "--- DRY RUN MODE ---"
  ytcmd+=(--simulate --print "%(playlist_index)s | %(title)s: %(filesize_approx,filesize!s)s")
else
  echo "--- LIVE DOWNLOAD MODE ---"

  if ! grep -Fq "$history_key" "$HISTORY_FILE"; then
    printf '%s\n' "$history_line" >> "$HISTORY_FILE"
  fi
fi

# ─── Playlist Length Detection ───────────────────────────────────────────────
get_total_items() {
  local probe_log=""
  local probe_output=""
  local probe_status=0

  probe_log="$(mktemp "${TMPDIR:-/tmp}/yt-full-dl-probe.XXXXXX")"

  set +e
  probe_output="$(
    yt-dlp \
      --flat-playlist \
      --lazy-playlist \
      --print "%(id)s" \
      "${COOKIE_FLAG[@]}" \
      "$url" 2>"$probe_log" |
      awk 'NF' |
      wc -l |
      tr -d ' '
  )"
  probe_status=$?
  set -e

  rm -f "$probe_log"

  if [[ "$probe_status" -ne 0 ]]; then
    printf '0\n'
    return 0
  fi

  printf '%s\n' "${probe_output:-0}"
}

archive_count() {
  [[ -f "$archive_file" ]] || {
    echo 0
    return
  }

  wc -l < "$archive_file" | tr -d ' '
}

failed_count() {
  [[ -s "$failed_file" ]] || {
    echo 0
    return
  }

  sort -u "$failed_file" | wc -l | tr -d ' '
}

resolved_count() {
  cat "$archive_file" "$failed_file" 2>/dev/null |
    awk 'NF' |
    sort -u |
    wc -l |
    tr -d ' '
}

mark_failed_ids_from_log() {
  local log_file="$1"

  [[ -f "$log_file" ]] || return

  awk '
    /^ERROR: \[youtube\] [A-Za-z0-9_-]+:/ {
      id = $3
      sub(/:$/, "", id)
      line = tolower($0)

      if (
        line ~ /video unavailable/ ||
        line ~ /private video/ ||
        line ~ /removed by the uploader/ ||
        line ~ /sign in to confirm your age/ ||
        line ~ /age-restricted/ ||
        line ~ /members-only/ ||
        line ~ /not available in your country/ ||
        line ~ /blocked in your country/
      ) {
        print id
      }
    }
  ' "$log_file" >> "$failed_file"

  if [[ -s "$failed_file" ]]; then
    sort -u -o "$failed_file" "$failed_file"
  fi
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

  if "$audio_only"; then
    echo "Mode: audio-only m4a with embedded thumbnail."
  else
    echo "Mode: video up to 1080p with embedded thumbnail and metadata."
  fi

  echo "Downloading random sequential ranges."
  echo "Range starts are random playlist positions."
  echo "Range length is random from 1-8 videos."
  echo "Resolved items are tracked across:"
  echo "$archive_file"
  echo "$failed_file"
  echo "────────────────────────────────────────────────────────────────────────────"

  no_progress_rounds=0
  max_no_progress_rounds=$(( total_items * 3 ))

  while true; do
    before_resolved="$(resolved_count)"
    before_archive="$(archive_count)"
    before_failed="$(failed_count)"

    if [[ "$before_resolved" -ge "$total_items" ]]; then
      echo
      echo "Resolved count reached detected playlist size: $before_resolved/$total_items"
      echo "Downloaded: $before_archive | Unavailable/blocked: $before_failed"
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
    echo "Resolved progress: $before_resolved/$total_items"
    echo "Downloaded: $before_archive | Unavailable/blocked: $before_failed"
    echo "────────────────────────────────────────────────────────────────────────────"

    range_log="$(mktemp "${TMPDIR:-/tmp}/yt-full-dl-range.XXXXXX")"

    set +e
    "${ytcmd[@]}" \
      --playlist-start "$start" \
      --playlist-end "$end" \
      "$url" 2>&1 | tee "$range_log"
    yt_status=${PIPESTATUS[0]}
    set -e

    mark_failed_ids_from_log "$range_log"
    rm -f "$range_log"

    after_resolved="$(resolved_count)"
    after_archive="$(archive_count)"
    after_failed="$(failed_count)"

    if [[ "$after_resolved" -gt "$before_resolved" ]]; then
      no_progress_rounds=0
    else
      no_progress_rounds=$(( no_progress_rounds + 1 ))
      echo "No new resolved progress this round. Streak: $no_progress_rounds/$max_no_progress_rounds"
    fi

    if [[ "$yt_status" -ne 0 ]]; then
      echo "yt-dlp exited with status $yt_status for this range; continuing because --ignore-errors is enabled."
    fi

    if [[ "$no_progress_rounds" -ge "$max_no_progress_rounds" ]]; then
      echo
      echo "Stopped after $no_progress_rounds random ranges with no resolved progress."
      echo "Some remaining items may be unavailable, private, region-locked, age-gated, or already failed."
      echo "Resolved: $after_resolved/$total_items"
      echo "Downloaded: $after_archive | Unavailable/blocked: $after_failed"
      break
    fi
  done
}

download_sequential_ranges() {
  total_items="$(get_total_items)"
  batch_size=8

  if [[ -z "$total_items" || "$total_items" -lt 1 ]]; then
    echo "Could not determine playlist/channel size."
    echo "Falling back to normal yt-dlp run."
    echo "────────────────────────────────────────────────────────────────────────────"

    "${ytcmd[@]}" "$url"
    return
  fi

  echo "Detected $total_items playlist/channel items."

  if "$audio_only"; then
    echo "Mode: audio-only m4a with embedded thumbnail."
  else
    echo "Mode: video up to 1080p with embedded thumbnail and metadata."
  fi

  echo "Downloading sequential ranges from first item to last."
  echo "Batch size: $batch_size videos."
  echo "Resolved items are tracked across:"
  echo "$archive_file"
  echo "$failed_file"
  echo "────────────────────────────────────────────────────────────────────────────"

  start=1

  while [[ "$start" -le "$total_items" ]]; do
    before_resolved="$(resolved_count)"
    before_archive="$(archive_count)"
    before_failed="$(failed_count)"

    if [[ "$before_resolved" -ge "$total_items" ]]; then
      echo
      echo "Resolved count reached detected playlist size: $before_resolved/$total_items"
      echo "Downloaded: $before_archive | Unavailable/blocked: $before_failed"
      echo "Done."
      break
    fi

    end=$(( start + batch_size - 1 ))
    if [[ "$end" -gt "$total_items" ]]; then
      end="$total_items"
    fi

    echo
    echo "Sequential range: $start-$end"
    echo "Actual range length: $(( end - start + 1 ))"
    echo "Resolved progress: $before_resolved/$total_items"
    echo "Downloaded: $before_archive | Unavailable/blocked: $before_failed"
    echo "────────────────────────────────────────────────────────────────────────────"

    range_log="$(mktemp "${TMPDIR:-/tmp}/yt-full-dl-range.XXXXXX")"

    set +e
    "${ytcmd[@]}" \
      --playlist-start "$start" \
      --playlist-end "$end" \
      "$url" 2>&1 | tee "$range_log"
    yt_status=${PIPESTATUS[0]}
    set -e

    mark_failed_ids_from_log "$range_log"
    rm -f "$range_log"

    after_resolved="$(resolved_count)"
    after_archive="$(archive_count)"
    after_failed="$(failed_count)"

    if [[ "$yt_status" -ne 0 ]]; then
      echo "yt-dlp exited with status $yt_status for this range; continuing because --ignore-errors is enabled."
    fi

    echo "Resolved now: $after_resolved/$total_items"
    echo "Downloaded: $after_archive | Unavailable/blocked: $after_failed"

    start=$(( end + 1 ))
  done
}

# ─── Run ─────────────────────────────────────────────────────────────────────
echo "Target: $target_dir"
echo "URL: $url"
echo "────────────────────────────────────────────────────────────────────────────"

if "$dry_run"; then
  "${ytcmd[@]}" "$url"
else
  if "$sequential_mode"; then
    download_sequential_ranges
  else
    download_random_ranges
  fi
fi
