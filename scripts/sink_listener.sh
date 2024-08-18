#!/usr/bin/bash

# This script monitors the /tmp/current_sink file for changes.
# When a new default sink (output) is set, it moves all current sink inputs (sources) to the new default sink (-output).
# It runs in a loop, checking for updates every second.
# To get your available outputs connect them and run `pactl list sinks short`
# On my machine a different script sets the new sink as well as connects to bluetooth devices

CURRENT_SINK_FILE="/tmp/current_sink"
LAST_SINK=""

change_sink() {
    local new_sink=$1
    pactl set-default-sink $new_sink
    LAST_SINK=$new_sink
}

move_sink_inputs() {
    sink_inputs=$(pactl list short sink-inputs)
    if [ -n "$sink_inputs" ]; then
        for input in $(echo "$sink_inputs" | cut -f1); do
            current_sink=$(pactl list sink-inputs | grep -A 15 "Sink Input #$input" | grep "Sink: " | cut -d' ' -f2)
            if [ "$current_sink" != "$LAST_SINK" ]; then
                pactl move-sink-input "$input" "$LAST_SINK"
            fi
        done
    fi
}

while true; do
    if [ -f "$CURRENT_SINK_FILE" ]; then
        NEW_SINK=$(cat "$CURRENT_SINK_FILE")
        if [ "$NEW_SINK" != "$LAST_SINK" ]; then
            change_sink "$NEW_SINK"
        fi
        move_sink_inputs
    fi
    sleep 1  # Check every second
done

