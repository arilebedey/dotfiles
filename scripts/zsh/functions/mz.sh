mz() {
  # Check if the user provided a directory path as an argument
  if [ -z "$1" ]; then
    echo "Usage: mz <directory>"
    return 1
  fi

  # Create the directory with -p to avoid errors if it already exists
  mkdir -p "$1"

  # Change to the newly created directory using z
  z "$1"
}
