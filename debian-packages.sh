#!/usr/bin/env bash

pkgs=(
    build-essential
    clangd
    cmake
    cmake-doc
    curl
    dconf-editor
    fd-find
    ffmpeg
    fzf
    git
    git-doc
    gnome-shell-extension-manager
    gnome-shell-extensions-gpaste
    gnome-shell-pomodoro
    gnome-tweaks
    htop
    jq
    libvterm-dev
    libwebkit2gtk-4.0-dev
    mpv
    net-tools
    nmap
    p7zip
    p7zip-rar
    pandoc
    postgresql-client
    python3-pip
    ripgrep
    rlwrap
    sbcl
    shellcheck
    subversion
    tree
    virt-manager
    wireguard-tools
    wireshark-doc
    wireshark-qt
    xclip
    yamllint
    yt-dlp
    zsh
    zsh-doc
)

sudo apt install -f "${pkgs[@]}"

script_name="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "$script_name")"

for receipt in "$script_dir/debian-packages/"*PKGCONFIG; do
    bash "$receipt"
done

sudo -H python3 -m pip install pyright virtualenv yapf flake8
sudo -H npm install -g typescript typescript-language-server eslint prettier

go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
go install github.com/segmentio/golines@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest
