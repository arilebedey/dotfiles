# Function to replace the last command with a new command while preserving arguments
function replace-cmd() {
    # Skip the rc command itself by looking back in history
    local LAST_COMMAND=""
    local HISTORY_INDEX=1
    
    # Keep looking back until we find a non-rc command
    while true; do
        LAST_COMMAND=$(fc -ln -$HISTORY_INDEX -$HISTORY_INDEX)
        FIRST_WORD=$(echo "$LAST_COMMAND" | awk '{print $1}')
        if [[ "$FIRST_WORD" != "rc" && "$FIRST_WORD" != "replace-cmd" ]]; then
            break
        fi
        ((HISTORY_INDEX++))
        # Safety check to avoid infinite loop
        if [[ $HISTORY_INDEX -gt 50 ]]; then
            echo "Couldn't find a suitable command in recent history."
            return 1
        fi
    done
    
    # If no command was found
    if [[ -z "$LAST_COMMAND" ]]; then
        echo "No previous command found in history."
        return 1
    fi
    
    # Extract the first word (the command)
    local ORIGINAL_CMD=$(echo "$LAST_COMMAND" | awk '{print $1}')
    
    # Extract the arguments (everything after the first word)
    local ARGS=$(echo "$LAST_COMMAND" | cut -d' ' -f2-)
    
    # Use fzf to select a command from history
    local NEW_CMD=$(fc -l -n 1 | awk '{print $1}' | grep -v "^rc$" | grep -v "^replace-cmd$" | sort | uniq | fzf --height 40% --reverse)
    
    # If user didn't select anything, exit
    if [[ -z "$NEW_CMD" ]]; then
        return 1
    fi
    
    # Construct the new command with the original arguments
    local NEW_COMMAND="$NEW_CMD $ARGS"
    
    # Print the chosen command
    echo "Chosen command: $NEW_CMD"
    
    # Use zle to replace the current command line buffer
    print -z "$NEW_COMMAND"
}

# Create an alias rc for the replace-cmd function
alias rc="replace-cmd"
