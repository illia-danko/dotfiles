#!/usr/bin/env bash

set -euo pipefail

theme="$(cat "$HOME"/.config/appearance/background)"

wallpapers_dir="$HOME/github.com/illia-danko/wallpapers"
img_light=0080.jpg
img_dark=0012.jpg
current_img="$wallpapers_dir/$img_light"
if [ "$theme" == dark ]; then current_img="$wallpapers_dir/$img_dark"; fi
bg_command_params="output * bg $current_img fill"

swaymsg -q "$bg_command_params"
