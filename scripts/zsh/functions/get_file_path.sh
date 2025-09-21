# ---------------------------------------------------------------
# get_path - Get the full absolute path of a file using fzf
# ---------------------------------------------------------------
get_path() {
    # Check if fzf is installed
    if ! command -v fzf &> /dev/null; then
        echo "Error: fzf is not installed. Please install it first."
        echo "You can install it using your package manager or from https://github.com/junegunn/fzf"
        return 1
    fi

    # Set the starting directory
    local start_dir="${1:-$(pwd)}"

    if [ ! -d "$start_dir" ]; then
        echo "Error: $start_dir is not a valid directory."
        return 1
    fi

    # Change to the starting directory
    cd "$start_dir" || return 1

    # Use find to get all files (excluding hidden files) and pipe to fzf
    local selected_file
    selected_file=$(find . -type f -not -path "*/\.*" | fzf --height 40% --reverse --prompt="Select a file: ")

    # If user selected a file
    if [ -n "$selected_file" ]; then
        local absolute_path
        absolute_path="$(cd "$(dirname "$selected_file")" && pwd)/$(basename "$selected_file")"
        echo "$absolute_path"

        # Optionally copy to clipboard if a clipboard tool is available
        if command -v xclip &> /dev/null; then
            echo "$absolute_path" | xclip -selection clipboard
            echo "Path copied to clipboard (xclip)."
        elif command -v wl-copy &> /dev/null; then
            echo "$absolute_path" | wl-copy
            echo "Path copied to clipboard (wl-copy)."
        elif command -v pbcopy &> /dev/null; then
            echo "$absolute_path" | pbcopy
            echo "Path copied to clipboard (pbcopy)."
        elif command -v clip.exe &> /dev/null; then
            echo "$absolute_path" | clip.exe
            echo "Path copied to clipboard (clip.exe)."
        fi
    else
        echo "No file selected."
        return 1
    fi
}

# Aliases so you can use short commands
alias gpa='get_path'
alias getpath='get_path'
alias gfp='get_path'
