#!/usr/bin/env bash

pkgs=(
    neovim
    alacritty
    kubectl
    pinentry-mac
    minio-mc
    node@16
    lf
    yamllint
    shellcheck
    htop
    golang
    lazygit
    tree
    ripgrep
    fd
    fzf
    tmux
    gnupg
    p7zip
    pandoc
    yt-dlp
    mpv
    mosquitto
    postgresql
    libpcap
    cmake
    nmap
    jq
    ffmpeg
    audacity
    graphviz
    anki
    hugo  # homepage
    biber  # homepage
    texlive  # homepage
)

brew install "${pkgs[@]}"
brew services stop postgresql
