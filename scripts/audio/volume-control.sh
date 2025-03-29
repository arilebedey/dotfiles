#!/bin/bash

# Get the ID of the active sink (the one that's actually in use)
ACTIVE_SINK=$(pactl get-default-sink)

# Check if audio is playing, and if so, determine where it's playing
PLAYING_SINK=$(pactl list short sink-inputs | head -n 1 | cut -f2)

# If something is playing, use that sink; otherwise use the default sink
if [ ! -z "$PLAYING_SINK" ]; then
  TARGET_SINK=$PLAYING_SINK
else
  TARGET_SINK=$ACTIVE_SINK
fi

# Apply volume change to the determined sink
if [ "$1" = "up" ]; then
  pactl set-sink-volume $TARGET_SINK +5%
elif [ "$1" = "down" ]; then
  pactl set-sink-volume $TARGET_SINK -5%
fi
