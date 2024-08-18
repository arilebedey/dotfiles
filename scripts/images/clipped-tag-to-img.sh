#!/usr/bin/env bash

# Get the last Wayland clipboard entry
html=$(wl-paste)

# Extract the image URL or base64 data using awk
url=$(echo $html | awk -F 'src="' '{print $2}' | awk -F '"' '{print $1}' | grep -oP '(http[s]?://[^\s"<>]+(?:\.jpg|\.jpeg|\.png|\.gif|\.webp))')
base64_data=$(echo $html | awk -F 'src="' '{print $2}' | awk -F '"' '{print $1}' | grep -oP '(data:image\/[a-zA-Z]+;base64,[^"]+)')

# Check if URL is found
if [[ -n "$url" ]]; then
  # Prompt the user for a filename using rofi -dmenu
  filename=$(echo "" | rofi -dmenu -p "Enter filename:")

  # Define the output file path
  output_file="/home/ari/Images/Clipboard/${filename}.jpg"

  # Create the directory if it does not exist
  mkdir -p /home/ari/Images/Clipboard

  # Download the image using curl and save to the output file
  curl -o "$output_file" "$url"
  echo "Image downloaded and saved to $output_file"

elif [[ -n "$base64_data" ]]; then
  # Prompt the user for a filename using rofi -dmenu
  filename=$(echo "" | rofi -dmenu -p "Enter filename:")

  # Define the output file path
  output_file="/home/ari/Images/Clipboard/${filename}.jpg"

  # Create the directory if it does not exist
  mkdir -p /home/ari/Images/Clipboard

  # Decode the base64 data and save to the output file
  echo "${base64_data#*,}" | base64 -d > "$output_file"
  echo "Base64 image decoded and saved to $output_file"
else
  echo "No valid image URL or base64 data found in the clipboard content."
fi

