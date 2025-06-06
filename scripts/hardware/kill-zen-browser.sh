#!/bin/bash
pid=$(pgrep -f "^/opt/zen-browser-bin/zen-bin$")
if [ -n "$pid" ]; then
  kill -15 "$pid"
else
  echo "Zen browser not running"
fi
