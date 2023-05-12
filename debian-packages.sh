#!/usr/bin/env bash

pkgs=(
    clangd
    cmake
    fd-find  # fd
    ffmpeg
    firefox
    git
    git-doc
    gridsite-clients # urlencode
    htop
    jq
    libvterm-dev
    mpv
    net-tools
    nmap
    p7zip
    p7zip-rar
    pandoc
    postgresql-client
    python3-pip
    qbittorrent
    ripgrep
    shellcheck
    subversion
    tmux-plugin-manager
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

pkgs_i3=(
    bash-completion
    build-essential
    fonts-ubuntu
    i3
    lxappearance
    neovim
    suckless-tools
    thunar
    unzip
    x11-xserver-utils
    xclip
    xdg-utils
    xinit
    xrandr
    xterm
    zip
)


sudo apt install -f "${pkgs[@]}"

script_name="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "$script_name")"

for receipt in "$script_dir/debian/packages/"*PKGCONFIG; do
    bash "$receipt"
done

# NOTE: On `zsh: bad CPU type in executable: node` consider to install `softwareupdate --install-rosetta`.
sudo npm install -g n vscode-css-languageserver-bin typescript-language-server typescript pyright eslint prettier

go install golang.org/x/tools/gopls@latest
go install mvdan.cc/gofumpt@latest
go install github.com/segmentio/golines@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/gokcehan/lf@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/go-delve/delve/cmd/dlv@latest

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
