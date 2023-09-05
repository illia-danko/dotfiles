#!/usr/bin/env bash

# Turn off eDP-1 and eDP-2 if any.
# Scale screen to $1.

set -exuo pipefail

export SWAYSOCK="$(sway --get-socketpath)"
builtin_screens=("eDP-1" "eDP-2")
read -ra screens <<< "$(swaymsg -t get_outputs --raw | jq '.[].name' \
    --raw-output | tr '\n' ' ')"

screen_off() {
    for screen in "${builtin_screens[@]}"; do
        swaymsg output "$screen" disable
    done
}

for screen in "${screens[@]}"; do
    swaymsg output "$screen" subpixel rgb
    swaymsg output "$screen" scale "$1"
done

# Turn off builtin screen if extra ones are plugged in.
[ "${#screens[@]}" -gt 1 ] && screen_off

