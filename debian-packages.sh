#!/usr/bin/env bash

pkgs=(
    build-essential
    clangd
    cmake
    fd-find  # fd
    ffmpeg
    firefox
    fonts-noto-color-emoji
    git
    git-doc
    gridsite-clients # urlencode
    htop
    jq
    libvterm-dev
    mpv
    net-tools
    nmap
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
    zsh-autosuggestions
    zsh-doc
    zsh-syntax-highlighting
)

pkgs_i3=(
    bash-completion
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

/usr/local/go/bin/go install golang.org/x/tools/gopls@latest
/usr/local/go/bin/go install mvdan.cc/gofumpt@latest
/usr/local/go/bin/go install github.com/segmentio/golines@latest
/usr/local/go/bin/go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
/usr/local/go/bin/go install github.com/gokcehan/lf@latest
/usr/local/go/bin/go install github.com/jesseduffield/lazygit@latest
/usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest
