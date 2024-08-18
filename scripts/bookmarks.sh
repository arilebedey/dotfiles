#!/bin/bash

DB_DIR="/home/ari/Information/bookmarks-db"
DB_EXT=".db"
COMMANDS_DIR="$DB_DIR/bookmark-db-commands"

# Ensure commands directory exists
mkdir -p "$COMMANDS_DIR"

# Function to initialize a new database
initialize_db() {
    local db_path="$1"
    sqlite3 "$db_path" <<EOF
CREATE TABLE IF NOT EXISTS bookmarks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL
);
EOF
}

# Function to list available databases
list_dbs() {
    find "$DB_DIR" -maxdepth 1 -name "*$DB_EXT" -exec basename {} $DB_EXT \;
}

# Function to display the rofi menu for database selection
select_db() {
    DBS=$(list_dbs)
    echo "$DBS" | rofi -dmenu -i -p "Select Database" -kb-custom-1 "Alt+1"
}

# Function to prompt for a new database name and create it
create_db() {
    DB_NAME=$(echo "" | rofi -dmenu -p "Enter New Database Name:")
    [ -z "$DB_NAME" ] && exit
    DB_PATH="$DB_DIR/$DB_NAME$DB_EXT"
    initialize_db "$DB_PATH"
    echo "Created and initialized new database: $DB_NAME"

    # Write command to the commands directory
    COMMAND="bash /home/ari/System/scripts/bookmarks-db-manager.sh \"$DB_PATH\""
    echo "$COMMAND" > "$COMMANDS_DIR/$DB_NAME"
    chmod +x "$COMMANDS_DIR/$DB_NAME"
    echo "Command written to: $COMMANDS_DIR/$DB_NAME"
}

# Function to check if the database is empty
is_db_empty() {
    COUNT=$(sqlite3 "$1" "SELECT COUNT(*) FROM bookmarks;")
    if [ "$COUNT" -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Function to display the rofi menu and get the selected bookmark ID
display_rofi() {
    local db_path="$1"
    BOOKMARKS=$(sqlite3 "$db_path" "SELECT id, title FROM bookmarks ORDER BY title;")
    echo "$BOOKMARKS" | awk -F '|' '{print $2}' | rofi -dmenu -i -p "Bookmarks" -format "s" -kb-custom-1 "Alt+1" -kb-custom-2 "Alt+2" -kb-custom-3 "Alt+3"
}

# Function to add a new bookmark
add_bookmark() {
    local db_path="$1"
    TITLE=$(echo "" | rofi -dmenu -p "Enter Title:")
    [ -z "$TITLE" ] && exit
    CONTENT=$(echo "" | rofi -dmenu -p "Enter Content:")
    [ -z "$CONTENT" ] && exit
    echo "Adding bookmark with title: $TITLE and content: $CONTENT"
    sqlite3 "$db_path" "INSERT INTO bookmarks (title, content) VALUES ('$TITLE', '$CONTENT');"
}

# Function to edit a bookmark title
edit_bookmark() {
    local db_path="$1"
    SELECTION="$2"
    ID=$(sqlite3 "$db_path" "SELECT id FROM bookmarks WHERE title='$SELECTION';")
    NEW_TITLE=$(echo "" | rofi -dmenu -p "Enter New Title:")
    [ -z "$NEW_TITLE" ] && exit
    echo "Updating bookmark with id: $ID to new title: $NEW_TITLE"
    sqlite3 "$db_path" "UPDATE bookmarks SET title='$NEW_TITLE' WHERE id=$ID;"
}

# Function to delete a bookmark
delete_bookmark() {
    local db_path="$1"
    SELECTION="$2"
    ID=$(sqlite3 "$db_path" "SELECT id FROM bookmarks WHERE title='$SELECTION';")
    echo "Deleting bookmark with id: $ID"
    sqlite3 "$db_path" "DELETE FROM bookmarks WHERE id=$ID;"
}

# Function to copy the bookmark content to clipboard
copy_to_clipboard() {
    local db_path="$1"
    SELECTION="$2"
    ID=$(sqlite3 "$db_path" "SELECT id FROM bookmarks WHERE title='$SELECTION';")
    if [ -z "$ID" ]; then
        echo "No valid selection made."
        exit 1
    fi
    CONTENT=$(sqlite3 "$db_path" "SELECT content FROM bookmarks WHERE id=$ID;")
    echo "Copying content to clipboard: $CONTENT"
    echo -n "$CONTENT" | wl-copy
}

# Main function to manage bookmarks in a selected database
manage_bookmarks() {
    local db_path="$1"
    
    if is_db_empty "$db_path"; then
        echo "Database is empty. Prompting to add a bookmark."
        add_bookmark "$db_path"
        exit 0
    fi

    SELECTION=$(display_rofi "$db_path")
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
            add_bookmark "$db_path"
            ;;
        11)
            echo "Edit bookmark selected"
            edit_bookmark "$db_path" "$SELECTION"
            ;;
        12)
            echo "Delete bookmark selected"
            delete_bookmark "$db_path" "$SELECTION"
            ;;
        0)
            echo "Copy to clipboard selected"
            copy_to_clipboard "$db_path" "$SELECTION"
            ;;
        *)
            echo "Unknown action"
            ;;
    esac
}

# Main function
main() {
    DB_SELECTION=$(select_db)
    EXIT_CODE=$?

    echo "Database selection: $DB_SELECTION"
    echo "Exit code: $EXIT_CODE"

    if [ -z "$DB_SELECTION" ] && [ "$EXIT_CODE" -ne 10 ]; then
        exit 0
    fi

    if [ "$EXIT_CODE" -eq 10 ]; then
        create_db
        exit 0
    fi

    DB_PATH="$DB_DIR/$DB_SELECTION$DB_EXT"
    manage_bookmarks "$DB_PATH"
}

main

