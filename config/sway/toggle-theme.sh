#!/usr/bin/env bash

# Toggle system theme to `dark` or 'light' mode:
# - change sway wallpapers (see ./set-wallpaper.sh)
# - toggle $HOME"/.config/appearance/background to 'dark' or 'light'
# - toggle gtk theme
# - reload user configuration
# - reload sway

# NOTE: alacritty automatically monitor config file change.
# neovim uses fwatch.nvim plugin to monitor $HOME"/.config/appearance/background.

set -euo pipefail

theme="$(cat "$HOME"/.config/appearance/background)"

gtk_theme="Adwaita"
if [ "$theme" == "light" ]; then
    theme="dark" && gtk_theme="Adwaita-dark"
else
    theme="light" && gtk_theme="Adwaita"
fi

# Apply changes.
echo "$theme" > ~/.config/appearance/background
gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
make -C "$HOME/github.com/illia-danko/dotfiles" config
swaymsg reload
# https://github.com/swaywm/sway/issues/3769
# export SWAYSOCK="$(sway --get-socketpath)"
