#!/usr/bin/env bash
#

pushd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -is --noconfirm
rm -rf yay
popd

yay -Syu --noconfirm

pkgs=(
    alacritty
    audacity
    bc
    bemenu
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
    gnupg
    graphviz
    htop
    hugo  # homepage
    inetutils # hostname
    inkscape
    iptables-nft # libvirt
    jq
    kubectl
    lf
    libnotify
    libreoffice-fresh
    libreoffice-fresh-en-gb
    libreoffice-fresh-uk
    libvirt
    lua-language-server
    mako
    mpv
    neofetch
    neovim
    nmap
    nodejs-lts-hydrogen
    noto-color-emoji-fontconfig # fix alacritty emoji
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji  # fix alacritty emoji
    npm
    p7zip
    pandoc
    parcellite
    pigz # docker
    postgresql
    pulsemixer
    python-pip
    qbittorrent
    qemu-emulators-full # libvirt
    qemu # virt-manager
    qt5-wayland
    qt6-wayland
    ripgrep
    shellcheck
    slurp
    stylua  # lua formatter
    texlive-bibtexextra
    texlive-fontsextra
    texlive-latexextra
    tree
    ttf-iosevka-nerd
    ttf-ubuntu-font-family
    usbutils  # lsusb
    virt-manager
    wf-recorder
    wireguard-tools
    wireshark-qt
    wl-clipboard
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xfce4-settings # for xfce4-appearance-settings
    yamllint
    yarn
    yt-dlp
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
)

yay -S "${pkgs[@]}" --noconfirm

# Ubuntu fonts.
# yay -Rnsdd bubblewrap --noconfirm || true
yay -S fontconfig-ubuntu --noconfirm
# yay -S bubblewrap --noconfirm

sudo -H python3 -m pip install pyright virtualenv yapf flake8
sudo -H npm install -g typescript typescript-language-server eslint prettier

sudo usermod -a -G docker "$USER"
sudo usermod -a -G libvirt "$USER"
sudo usermod -a -G wireshark "$USER"
sudo systemctl enable libvirtd.service --now
sudo systemctl enable docker.service --now
sudo systemctl enable cronie.service --now
