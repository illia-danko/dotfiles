#!/usr/bin/env bash


# Install homebrew.
[ ! -d "/opt/homebrew/bin" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
PATH="/opt/homebrew/bin:$PATH"

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
    clang-format
    newsboat
)

brew install "${pkgs[@]}"

go install golang.org/x/tools/gopls@latest
go install github.com/segmentio/golines@latest
go install mvdan.cc/gofumpt@latest
curl -L https://git.io/vp6lP | sh  # gometalinter
