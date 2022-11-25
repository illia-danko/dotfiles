#!/usr/bin/env bash

pkgs=(
    gridsite-clients # urlencode
    jq
    yamllint
    shellcheck
    rlwrap
    sbcl
    net-tools
    fd-find  # fd
    xclip
    ripgrep
    libvterm-dev
    virt-manager
    subversion
    wireguard-tools
    copyq
    dconf-editor
    wireshark-doc
    wireshark-qt
    zsh
    zsh-doc
    postgresql-client
    nmap
    htop
    pandoc
    cmake
    clangd
    newsboat
    python3-pip
    ffmpeg
    p7zip
    p7zip-rar
    mpv
    yt-dlp
    tree
)

sudo apt install -f "${pkgs[@]}"

script_name="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "$script_name")"

for receipt in "$script_dir/debian-packages/"*PKGCONFIG; do
    bash "$receipt"
done

go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
go install github.com/segmentio/golines@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/gokcehan/lf@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/go-delve/delve/cmd/dlv@latest
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
