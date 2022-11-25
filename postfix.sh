#!/usr/bin/env bash

# Replace file tokens with environment variables using 'envsubst' command.

subsitute_file_environments() {
    local tmp="$(mktemp)"
    envsubst < "$1" > "$tmp"
    mv "$tmp" "$1"
}

if [ "$(uname)" = "Darwin" ]; then
    export ALACRITTY_WINDOW_STARTUP_MODE="SimpleFullscreen"
    export ALACRITTY_WINDOW_DECORATIONS="None"
    export ALACRITTY_FONT_SIZE="16"
    export TMUX_STATUS_BG="#000000"
else
    export ALACRITTY_WINDOW_STARTUP_MODE="Maximized"
    export ALACRITTY_WINDOW_DECORATIONS="None"
    export ALACRITTY_FONT_SIZE="11.5"
    export TMUX_STATUS_BG="#131313"
fi

subsitute_file_environments "$HOME/.config/alacritty/alacritty.yml"
subsitute_file_environments "$HOME/.tmux.conf"
