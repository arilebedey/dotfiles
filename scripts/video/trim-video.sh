#!/bin/bash

# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf is required but not installed. Please install fzf."
    exit 1
fi

# Check if ffmpeg is installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "ffmpeg is required but not installed. Please install ffmpeg."
    exit 1
fi

# Select multiple video files using fzf
videos=$(find . -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" \) | sed 's|./||' | fzf -m)

if [ -z "$videos" ]; then
    echo "No videos selected."
    exit 1
fi

# Process each selected video
while IFS= read -r video; do
    if [ -f "$video" ]; then
        output="${video%.*}_trimmed.${video##*.}"
        ffmpeg -i "$video" -ss 0:07 -to 1:05 -c:v copy -c:a copy "$output"
        echo "Trimmed: $video -> $output"
    else
        echo "File not found: $video"
    fi
done <<< "$videos"
