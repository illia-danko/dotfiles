#!/usr/bin/env bash

set -euo pipefail

filename="screenshot-`date +%F-%T`"
filepath="$HOME/Pictures/${filename}.png"

case "$1" in
    select)
        grim -g "$(slurp)" "$filepath"
        wl-copy -t image/png < "$filepath";;
esac

notify-send "Screenshort $filepath"
