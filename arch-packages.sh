#!/usr/bin/env bash
#

pushd /tmp || return
git clone https://aur.archlinux.org/yay.git
cd yay || return
makepkg -is --noconfirm
rm -rf yay
popd || return

yay -Syu --noconfirm

pkgs=(
	emacs
	hunspell-en_us
	neovim
    audacity
    bc
    betterbird-bin  # thunderbird but better
    biber  # homepage
    ccls  # C/C++ Language Server Protocol
    cmake
    cronie  # crontab
    dmidecode  # virt-manager
    dnsmasq  # virt-manager
    docker
    docker-compose
    docker-scan # scan vulnerabilities
    fd
    ffmpeg
    fzf
    gnome-terminal
    gnupg
    gpaste  # clipboard manager
    graphviz
    htop
    hugo  # homepage
    inetutils # hostname
    inkscape
    jq
    kubectl
    libreoffice-fresh
    libreoffice-fresh-en-gb
    libreoffice-fresh-uk
    libvirt
    mpv
    neofetch
    nmap
    nodejs-lts-hydrogen
    noto-color-emoji-fontconfig # fix alacritty emoji
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji  # fix alacritty emoji
    npm
    obsidian-icon-theme
    p7zip
    pandoc
    pigz # docker
    pomatez  # pomodoro app
    postgresql
    python-pip
    qbittorrent
    qemu # virt-manager
    qemu-emulators-full # libvirt
    qt5-wayland
    qt6-wayland
    ripgrep
    rust
    rust-analyzer
    shellcheck
    stylua  # lua formatter
    texlive-bibtexextra
    texlive-fontsextra
    texlive-latexextra
    tmux
    tree
    ttf-iosevka-nerd
    usbutils  # lsusb
    virt-manager
    wireguard-tools
    wireshark-qt
    wl-clipboard
    xclip
    yamllint
    yarn
    yt-dlp
    zsh-autosuggestions
    zsh-syntax-highlighting
)

yay -S "${pkgs[@]}" --noconfirm

# Ubuntu fonts.
yay -Rnsdd bubblewrap --noconfirm || true
yay -S fontconfig-ubuntu
yay -S bubblewrap --noconfirm

sudo -H python3 -m pip install pyright virtualenv yapf flake8
sudo -H npm install -g typescript typescript-language-server eslint prettier

go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/segmentio/golines@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest

sudo usermod -a -G docker "$USER"
sudo usermod -a -G libvirt "$USER"
sudo usermod -a -G wireshark "$USER"
sudo systemctl enable libvirtd.service --now
sudo systemctl enable docker.service --now
sudo systemctl enable cronie.service --now
