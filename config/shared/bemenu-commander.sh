#!/usr/bin/env bash

set -euo pipefail

bemenu_font="Ubuntu Mono Bold 14"
execute_command="i3-msg -t run_command exec"
clipboard_paste_command="xclip -selection c"
if [ ! -n "$DISPLAY" ]; then
    execute_command="swaymsg exec"
    clipboard_paste_command="wl-copy"
fi

read -r -a bemenu_color_opts <<< "--tb=${TTY_COLOR_BG1} \
    --fb=${TTY_COLOR_BG1} --cb=${TTY_COLOR_BG1} \
    --nb=${TTY_COLOR_BG1} --hb=${TTY_COLOR_BG1} \
    --fbb=${TTY_COLOR_BG1} --sb=${TTY_COLOR_BG1} \
    --ab=${TTY_COLOR_BG1} --scb=${TTY_COLOR_BG1} \
    --tf=${TTY_COLOR_RED} --af=${TTY_COLOR_FG1} \
    --ff=${TTY_COLOR_FG1} \
    --nf=${TTY_COLOR_FG1} \
    --hf=${TTY_COLOR_GREEN}"

case "$1" in
    commands)
        bemenu-run "${bemenu_color_opts[@]}" --fn "${bemenu_font}" \
            -H 26 -n | \
            xargs "$execute_command" --;;
    cliphist)
        cliphist list | \
            bemenu "${bemenu_color_opts[@]}" --fn "${bemenu_font}" -H 26 -n -l 999 | \
            cliphist decode | \
            # Remove 'return' character in the end of the output if any.
            sed -e 's/\n$//' | \
            eval "$clipboard_paste_command";;
esac
