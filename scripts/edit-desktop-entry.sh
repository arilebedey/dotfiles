# Function to copy and edit desktop entries
copy_and_edit_desktop_entry() {
    # Ensure the user's applications directory exists
    mkdir -p ~/.local/share/applications/

    # Use fzf to select a desktop entry file from system applications
    selected_desktop_file=$(find /usr/share/applications -name "*.desktop" | fzf --preview "cat {}" --height 60% --border)

    # Exit if no file was selected (user pressed ESC)
    if [ -z "$selected_desktop_file" ]; then
        echo "No desktop file selected. Exiting."
        return 1
    fi

    # Get just the filename without the path
    filename=$(basename "$selected_desktop_file")

    # Copy the selected file to user's applications directory
    cp "$selected_desktop_file" ~/.local/share/applications/

    # Confirm the copy
    echo "Copied $filename to ~/.local/share/applications/"

    # Open the copied file with nvim
    nvim ~/.local/share/applications/"$filename"
}
