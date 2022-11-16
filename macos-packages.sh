#!/usr/bin/env bash

pkgs=(
    alacritty
    cmake
    fd
    ffmpeg
    fzf
    htop
    jq
    kubectl
    lazygit
    lf
    mpv
    neovim
    nmap
    npm
    p7zip
    ripgrep
    shellcheck
    stylua  # lua formatter
    tmux
    yamllint
    yarn
    yt-dlp
)

brew install "${pkgs[@]}"
