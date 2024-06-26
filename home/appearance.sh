#!/usr/bin/env bash

export LS_COLORS='di=1;35:ex=01;33'

s="$HOME"/.config/appearance/background
if [ ! -f "$s" ]; then
    mkdir -p "$HOME"/.config/appearance
    echo light > "$s"
fi

export SYSTEM_COLOR_THEME="$(cat "$s")"
export TTY_FONT_SIZE="10"
export TTY_FONT_FAMILY="JetBrainsMono Nerd Font Mono"
export ALACRITTY_WINDOW_DECORATION="None"
if [ "$(uname)" = "Darwin" ]; then
    export TTY_FONT_SIZE="13"
    export ALACRITTY_WINDOW_DECORATION="Buttonless"
fi

# One Dark Theme.
export TTY_COLOR_BG0_DARK="#282c34"
export TTY_COLOR_BG1_DARK="#000000"
export TTY_COLOR_BG2_DARK="#000000"
export TTY_COLOR_FG0_DARK="#abb2bf"
export TTY_COLOR_FG1_DARK="#eeeeec"
export TTY_COLOR_BLACK_DARK="#181a1f"
export TTY_COLOR_RED_DARK="#e86671"
export TTY_COLOR_GREEN_DARK="#98c379"
export TTY_COLOR_YELLOW_DARK="#e5c07b"
export TTY_COLOR_BLUE_DARK="#61afef"
export TTY_COLOR_MAGENTA_DARK="#c678dd"
export TTY_COLOR_CYAN_DARK="#56b6c2"
export TTY_COLOR_WHITE_DARK="#abb2bf"
export TTY_COLOR_BRIGHT_BLACK_DARK="#5c6370"
export TTY_COLOR_BRIGHT_RED_DARK="#ef9098"
export TTY_COLOR_BRIGHT_GREEN_DARK="#b3d39c"
export TTY_COLOR_BRIGHT_YELLOW_DARK="#efd4a4"
export TTY_COLOR_BRIGHT_BLUE_DARK="#91c7f3"
export TTY_COLOR_BRIGHT_MAGENTA_DARK="#c678dd"
export TTY_COLOR_BRIGHT_CYAN_DARK="#56b6c2"
export TTY_COLOR_BRIGHT_WHITE_DARK="#abb2bf"
export TTY_INACTIVE_PANE_BRIGHTNESS_DARK="0.8"
# One Light Theme.
export TTY_COLOR_BG0_LIGHT="#fafafa"
export TTY_COLOR_BG1_LIGHT="#dfdedb"
export TTY_COLOR_BG2_LIGHT="#dfdedb"
export TTY_COLOR_FG0_LIGHT="#383a42"
export TTY_COLOR_FG1_LIGHT="#000000"
export TTY_COLOR_BLACK_LIGHT="#101012"
export TTY_COLOR_RED_LIGHT="#e45649"
export TTY_COLOR_GREEN_LIGHT="#50a14f"
export TTY_COLOR_YELLOW_LIGHT="#986801"
export TTY_COLOR_BLUE_LIGHT="#4078f2"
export TTY_COLOR_MAGENTA_LIGHT="#a626a4"
export TTY_COLOR_CYAN_LIGHT="#0184bc"
export TTY_COLOR_WHITE_LIGHT="#383a42"
export TTY_COLOR_BRIGHT_BLACK_LIGHT="#a0a1a7"
export TTY_COLOR_BRIGHT_RED_LIGHT="#d73223"
export TTY_COLOR_BRIGHT_GREEN_LIGHT="#3e803d"
export TTY_COLOR_BRIGHT_YELLOW_LIGHT="#cb8b01"
export TTY_COLOR_BRIGHT_BLUE_LIGHT="#0d54f2"
export TTY_COLOR_BRIGHT_MAGENTA_LIGHT="#a626a4"
export TTY_COLOR_BRIGHT_CYAN_LIGHT="#0184bc"
export TTY_COLOR_BRIGHT_WHITE_LIGHT="#383a42"
export TTY_INACTIVE_PANE_BRIGHTNESS_LIGHT="0.93"

if [ "$SYSTEM_COLOR_THEME" = "dark" ]; then
    export TTY_COLOR_BG0="${TTY_COLOR_BG0_DARK}"
    export TTY_COLOR_BG1="${TTY_COLOR_BG1_DARK}"
    export TTY_COLOR_BG2="${TTY_COLOR_BG2_DARK}"
    export TTY_COLOR_FG0="${TTY_COLOR_FG0_DARK}"
    export TTY_COLOR_FG1="${TTY_COLOR_FG1_DARK}"
    export TTY_COLOR_BLACK="${TTY_COLOR_BLACK_DARK}"
    export TTY_COLOR_RED="${TTY_COLOR_RED_DARK}"
    export TTY_COLOR_GREEN="${TTY_COLOR_GREEN_DARK}"
    export TTY_COLOR_YELLOW="${TTY_COLOR_YELLOW_DARK}"
    export TTY_COLOR_BLUE="${TTY_COLOR_BLUE_DARK}"
    export TTY_COLOR_MAGENTA="${TTY_COLOR_MAGENTA_DARK}"
    export TTY_COLOR_CYAN="${TTY_COLOR_CYAN_DARK}"
    export TTY_COLOR_WHITE="${TTY_COLOR_WHITE_DARK}"
    export TTY_COLOR_BRIGHT_BLACK="${TTY_COLOR_BRIGHT_BLACK_DARK}"
    export TTY_COLOR_BRIGHT_RED="${TTY_COLOR_BRIGHT_RED_DARK}"
    export TTY_COLOR_BRIGHT_GREEN="${TTY_COLOR_BRIGHT_GREEN_DARK}"
    export TTY_COLOR_BRIGHT_YELLOW="${TTY_COLOR_BRIGHT_YELLOW_DARK}"
    export TTY_COLOR_BRIGHT_BLUE="${TTY_COLOR_BRIGHT_BLUE_DARK}"
    export TTY_COLOR_BRIGHT_MAGENTA="${TTY_COLOR_BRIGHT_MAGENTA_DARK}"
    export TTY_COLOR_BRIGHT_CYAN="${TTY_COLOR_BRIGHT_CYAN_DARK}"
    export TTY_COLOR_BRIGHT_WHITE="${TTY_COLOR_BRIGHT_WHITE_DARK}"
    export TTY_INACTIVE_PANE_BRIGHTNESS="0.8"
else
    export TTY_COLOR_BG0="${TTY_COLOR_BG0_LIGHT}"
    export TTY_COLOR_BG1="${TTY_COLOR_BG1_LIGHT}"
    export TTY_COLOR_BG2="${TTY_COLOR_BG2_LIGHT}"
    export TTY_COLOR_FG0="${TTY_COLOR_FG0_LIGHT}"
    export TTY_COLOR_FG1="${TTY_COLOR_FG1_LIGHT}"
    export TTY_COLOR_BLACK="${TTY_COLOR_BLACK_LIGHT}"
    export TTY_COLOR_RED="${TTY_COLOR_RED_LIGHT}"
    export TTY_COLOR_GREEN="${TTY_COLOR_GREEN_LIGHT}"
    export TTY_COLOR_YELLOW="${TTY_COLOR_YELLOW_LIGHT}"
    export TTY_COLOR_BLUE="${TTY_COLOR_BLUE_LIGHT}"
    export TTY_COLOR_MAGENTA="${TTY_COLOR_MAGENTA_LIGHT}"
    export TTY_COLOR_CYAN="${TTY_COLOR_CYAN_LIGHT}"
    export TTY_COLOR_WHITE="${TTY_COLOR_WHITE_LIGHT}"
    export TTY_COLOR_BRIGHT_BLACK="${TTY_COLOR_BRIGHT_BLACK_LIGHT}"
    export TTY_COLOR_BRIGHT_RED="${TTY_COLOR_BRIGHT_RED_LIGHT}"
    export TTY_COLOR_BRIGHT_GREEN="${TTY_COLOR_BRIGHT_GREEN_LIGHT}"
    export TTY_COLOR_BRIGHT_YELLOW="${TTY_COLOR_BRIGHT_YELLOW_LIGHT}"
    export TTY_COLOR_BRIGHT_BLUE="${TTY_COLOR_BRIGHT_BLUE_LIGHT}"
    export TTY_COLOR_BRIGHT_MAGENTA="${TTY_COLOR_BRIGHT_MAGENTA_LIGHT}"
    export TTY_COLOR_BRIGHT_CYAN="${TTY_COLOR_BRIGHT_CYAN_LIGHT}"
    export TTY_COLOR_BRIGHT_WHITE="${TTY_COLOR_BRIGHT_WHITE_LIGHT}"
    export TTY_INACTIVE_PANE_BRIGHTNESS="0.93"
fi

