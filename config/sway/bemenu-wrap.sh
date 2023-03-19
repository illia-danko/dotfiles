#!/usr/bin/env bash

read -a bemenu_color_opts <<< "--tb=${TTY_COLOR_BLACK} \
    --fb=${TTY_COLOR_BLACK} --cb=${TTY_COLOR_BLACK} \
    --nb=${TTY_COLOR_BLACK} --hb=${TTY_COLOR_BLACK} \
    --fbb=${TTY_COLOR_BLACK} --sb=${TTY_COLOR_BLACK} \
    --ab=${TTY_COLOR_BLACK} --scb=${TTY_COLOR_BLACK} \
    --tf=${TTY_COLOR_RED} \
    --ff=${TTY_COLOR_FG1} \
    --nf=${TTY_COLOR_FG1} \
    --hf=${TTY_COLOR_GREEN}"

bemenu_font="pango:UbuntuMono Nerd Bold 12"

case "$1" in
    commands)
        bemenu-run "${bemenu_color_opts[@]}" --fn "${bemenu_font}" \
            -H 30 -n | xargs swaymsg exec --;;
    clipboard)
        cliphist list | cut -f 2- | bemenu "${bemenu_color_opts[@]}" \
            --fn "${bemenu_font}" -H 30 -n -l 999 | wl-copy
esac
