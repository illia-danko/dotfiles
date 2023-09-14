#!/usr/bin/env bash

set -euo pipefail

filename="screenshot-`date +%F-%T`"
destination_folder="$HOME/Pictures"
filepath="$destination_folder/${filename}.png"

mkdir -p "$destination_folder"

case "$1" in
    select)
        grim -g "$(slurp)" "$filepath"
        wl-copy -t image/png < "$filepath";;
esac

notify-send "Screenshort $filepath"
