#!/bin/bash

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf is required but not installed. Please install it."
    exit 1
fi

# Select MKV files using fzf
files=$(find . -maxdepth 1 -type f -name "*.mkv" | fzf --multi)

# Check if files were selected
if [ -z "$files" ]; then
    echo "No files selected."
    exit 0
fi

# Convert each selected file
while IFS= read -r mkv_file; do
    if [ ! -f "$mkv_file" ]; then
        echo "File not found: $mkv_file"
        continue
    fi
    mp4_file="${mkv_file%.*}.mp4"
    ffmpeg -i "$mkv_file" -c:v copy -c:a copy "$mp4_file" && echo "Converted: $mkv_file -> $mp4_file" || echo "Error converting $mkv_file"
done <<< "$files"
