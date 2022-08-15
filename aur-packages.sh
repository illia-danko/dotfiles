#!/usr/bin/env bash

makepkg_install() {
    makepkg -si --noconfirm \
        "https://aur.archlinux.org/yay.git" \
        "https://aur.archlinux.org/ttf-ms-fonts.git"
}

yay_install() {
    sudo pacman -Rdd bublewrap # required for fontconfig-ubuntu
    yay -S \
        ttf-ms-fonts \
        fontconfig-ubuntu
}

makepkg_install
yay_install
