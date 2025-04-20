#!/bin/zsh

# nxf - Create or edit a file, make it executable, and open with nvim
# Usage: nxf <filename>

nxf() {
  if [ $# -ne 1 ]; then
    echo "Usage: nxf <filename>"
    return 1
  fi

  filename="$1"

  # Create the file if it doesn't exist
  if [ ! -f "$filename" ]; then
    # Add shebang line if we're creating a new .sh file
    if [[ "$filename" == *.sh ]]; then
      echo "#!/bin/bash" > "$filename"
      echo "" >> "$filename"
    fi
    echo "Created new file: $filename"
  fi

  # Make the file executable
  chmod +x "$filename"
  echo "Made executable: $filename"

  # Open the file with nvim
  nvim "$filename"
}
