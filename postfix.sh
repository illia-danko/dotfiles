#!/usr/bin/env bash

set -eo pipefail

update_alacritty_icon_mac() {
    local icon_path=/Applications/Alacritty.app/Contents/Resources/alacritty.icns
    if [ ! -f "$icon_path" ]; then
        echo "Can't find existing icon, make sure Alacritty is installed"
        exit 1
    fi

    local backup_prefix="$icon_path.backup"
    for backup in "$backup_prefix"*; do
        test -f "$backup" && return  # already applied
    done

    echo "Backing up existing icon"
    local hash="$(shasum $icon_path | head -c 10)"
    mv "$icon_path" "$backup_prefix-$hash"

    echo "Downloading replacement icon"
    local icon_url=https://github.com/hmarr/dotfiles/files/8549877/alacritty.icns.gz
    curl -sL $icon_url | gunzip > "$icon_path"

    touch /Applications/Alacritty.app
    killall Finder
    killall Dock
}

[ "$(uname)" == "Darwin" ] && update_alacritty_icon_mac
