#!/bin/bash

# Path to .zsh_history file
ZSH_HISTORY_FILE="$HOME/.local/.zshhistory"

# Check if the history file exists
if [ ! -f "$ZSH_HISTORY_FILE" ]; then
    echo "Error: $ZSH_HISTORY_FILE not found."
    exit 1
fi

# Get the last command from the history file
# zsh history format can be complex, often with timestamps and other metadata
# This extracts the actual command part
LAST_COMMAND=$(tail -1 "$ZSH_HISTORY_FILE" | sed 's/^[^;]*;//' | sed 's/^[ \t]*//')

# If no command was found
if [ -z "$LAST_COMMAND" ]; then
    echo "No previous command found in history."
    exit 1
fi

# Extract the first word (the command)
ORIGINAL_CMD=$(echo "$LAST_COMMAND" | awk '{print $1}')

# Extract the arguments (everything after the first word)
ARGS=$(echo "$LAST_COMMAND" | cut -d' ' -f2-)

echo "Last command: $LAST_COMMAND"
echo "Original command: $ORIGINAL_CMD"
echo "Arguments: $ARGS"

# Prompt for the new command
read -p "Enter new command to replace '$ORIGINAL_CMD': " NEW_CMD

# If user didn't enter anything, exit
if [ -z "$NEW_CMD" ]; then
    echo "No command provided. Exiting."
    exit 1
fi

# Construct the new command with the original arguments
NEW_COMMAND="$NEW_CMD $ARGS"

echo "New command: $NEW_COMMAND"
read -p "Execute this command? (y/n): " CONFIRM

if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
    echo "Executing: $NEW_COMMAND"
    eval "$NEW_COMMAND"
else
    echo "Command not executed."
fi
