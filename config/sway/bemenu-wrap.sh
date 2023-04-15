#!/usr/bin/env bash

set -euo pipefail

read -r -a bemenu_color_opts <<< "--tb=${TTY_COLOR_BG1} \
    --fb=${TTY_COLOR_BG1} --cb=${TTY_COLOR_BG1} \
    --nb=${TTY_COLOR_BG1} --hb=${TTY_COLOR_BG1} \
    --fbb=${TTY_COLOR_BG1} --sb=${TTY_COLOR_BG1} \
    --ab=${TTY_COLOR_BG1} --scb=${TTY_COLOR_BG1} \
    --tf=${TTY_COLOR_RED} --af=${TTY_COLOR_FG1} \
    --ff=${TTY_COLOR_FG1} \
    --nf=${TTY_COLOR_FG1} \
    --hf=${TTY_COLOR_GREEN}"

bemenu_font="pango:UbuntuMono Nerd Bold 14"

case "$1" in
    commands)
        bemenu-run "${bemenu_color_opts[@]}" --fn "${bemenu_font}" \
            -H 30 -n | xargs swaymsg exec --;;
    clipboard)
        cliphist list | cut -f 2- | bemenu "${bemenu_color_opts[@]}" \
            --fn "${bemenu_font}" -H 30 -n -l 999 | cliphist decode | wl-copy
esac
