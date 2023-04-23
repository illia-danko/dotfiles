#!/usr/bin/env bash

set -euo pipefail

wallpapers_dir="$HOME/github.com/illia-danko/wallpapers"

img_light=0080.jpg
img_dark=0310.jpg

current_theme="$(cat "$HOME"/.config/custom-appearance/background)"
current_img="$wallpapers_dir/$img_light"
if [ "$current_theme" == dark ]; then current_img="$wallpapers_dir/$img_dark"; fi

command_params="output * bg $current_img fill"
swaymsg -q "$command_params"
