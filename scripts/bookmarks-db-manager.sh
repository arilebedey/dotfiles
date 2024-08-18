#!/bin/bash

DB_PATH="$1"

# Function to check if the database is empty
is_db_empty() {
    COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM bookmarks;")
    if [ "$COUNT" -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Function to display the rofi menu and get the selected bookmark ID
display_rofi() {
    BOOKMARKS=$(sqlite3 "$DB_PATH" "SELECT id, title FROM bookmarks ORDER BY title;")
    echo "$BOOKMARKS" | awk -F '|' '{print $2}' | rofi -dmenu -i -p "Bookmarks" -format "s" -kb-custom-1 "Alt+1" -kb-custom-2 "Alt+2" -kb-custom-3 "Alt+3"
}

# Function to add a new bookmark
add_bookmark() {
    TITLE=$(echo "" | rofi -dmenu -p "Enter Title:")
    [ -z "$TITLE" ] && exit
    CONTENT=$(echo "" | rofi -dmenu -p "Enter Content:")
    [ -z "$CONTENT" ] && exit
    echo "Adding bookmark with title: $TITLE and content: $CONTENT"
    sqlite3 "$DB_PATH" "INSERT INTO bookmarks (title, content) VALUES ('$TITLE', '$CONTENT');"
}

# Function to edit a bookmark title
edit_bookmark() {
    SELECTION="$1"
    ID=$(sqlite3 "$DB_PATH" "SELECT id FROM bookmarks WHERE title='$SELECTION';")
    NEW_TITLE=$(echo "" | rofi -dmenu -p "Enter New Title:")
    [ -z "$NEW_TITLE" ] && exit
    echo "Updating bookmark with id: $ID to new title: $NEW_TITLE"
    sqlite3 "$DB_PATH" "UPDATE bookmarks SET title='$NEW_TITLE' WHERE id=$ID;"
}

# Function to delete a bookmark
delete_bookmark() {
    SELECTION="$1"
    ID=$(sqlite3 "$DB_PATH" "SELECT id FROM bookmarks WHERE title='$SELECTION';")
    echo "Deleting bookmark with id: $ID"
    sqlite3 "$DB_PATH" "DELETE FROM bookmarks WHERE id=$ID;"
}

# Function to copy the bookmark content to clipboard
copy_to_clipboard() {
    SELECTION="$1"
    ID=$(sqlite3 "$DB_PATH" "SELECT id FROM bookmarks WHERE title='$SELECTION';")
    if [ -z "$ID" ]; then
        echo "No valid selection made."
        exit 1
    fi
    CONTENT=$(sqlite3 "$DB_PATH" "SELECT content FROM bookmarks WHERE id=$ID;")
    echo "Copying content to clipboard: $CONTENT"
    echo -n "$CONTENT" | wl-copy
}

# Main function to manage bookmarks in a selected database
manage_bookmarks() {
    
    if is_db_empty "$DB_PATH"; then
        echo "Database is empty. Prompting to add a bookmark."
        add_bookmark
        exit 0
    fi

    SELECTION=$(display_rofi)
    EXIT_CODE=$?

    echo "Selection: $SELECTION"
    echo "Exit code: $EXIT_CODE"

    if [ -z "$SELECTION" ]; then
        exit 0
    fi

    # Detect the exit code to determine which custom key was pressed
    case "$EXIT_CODE" in
        10)
            echo "Add bookmark selected"
            add_bookmark
            ;;
        11)
            echo "Edit bookmark selected"
            edit_bookmark "$SELECTION"
            ;;
        12)
            echo "Delete bookmark selected"
            delete_bookmark "$SELECTION"
            ;;
        0)
            echo "Copy to clipboard selected"
            copy_to_clipboard "$SELECTION"
            ;;
        *)
            echo "Unknown action"
            ;;
    esac
}

manage_bookmarks

