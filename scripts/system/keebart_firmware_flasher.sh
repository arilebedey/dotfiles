#!/bin/bash

set -e

FIRMWARE="$HOME/Downloads/firmware.zip" 
RIGHT_UF2="$HOME/Downloads/nice_view-corne_choc_pro_right-zmk.uf2"
LEFT_UF2="$HOME/Downloads/nice_view-corne_choc_pro_left-zmk.uf2"

unzip -o "$FIRMWARE" -d "$HOME/Downloads/" >/dev/null

if [ ! -f "$RIGHT_UF2" ] || [ ! -f "$LEFT_UF2" ]; then
    echo "Firmware files not found after unzip."
    exit 1
fi

wait_mount() {
    local label="$1"
    echo "Waiting for $label to mount..."
    while [ ! -d "/Volumes/KEEBART" ]; do
        sleep 1
    done
}

wait_eject() {
    local label="$1"
    echo "Waiting for $label to eject..."
    while [ -d "/Volumes/KEEBART" ]; do
        sleep 1
    done
}

flash_side() {
    local file="$1"
    local label="$2"
    wait_mount "$label"
    echo "Copying $label firmware..."
    rsync --checksum --inplace --no-compress --no-times --no-perms \
          "$file" "/Volumes/KEEBART/" >/dev/null 2>&1 || true
    wait_eject "$label"
}

flash_side "$RIGHT_UF2" "right"
flash_side "$LEFT_UF2" "left"

rm "$LEFT_UF2" "$RIGHT_UF2" "$FIRMWARE"

flash_side "$LEFT_UF2" "left"

echo "Done."
