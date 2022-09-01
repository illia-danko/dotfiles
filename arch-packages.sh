#!/usr/bin/env bash

pkgs=(
    air
    alacritty
    audacity
    bc
    biber  # homepage
    cmake
    docker
    fd
    ffmpeg
    fzf
    gnome-themes-extra
    gnupg
    graphviz
    gtk-engines
    htop
    hugo  # homepage
    inetutils # hostname
    jq
    kubectl
    lazygit
    lf
    libpcap
    minio-client
    mosquitto
    mpv
    neofetch
    neovim
    nmap
    nodejs-lts-gallium
    npm
    p7zip
    pandoc
    pigz
    postgresql
    qemu
    ripgrep
    shellcheck
    texlive-bibtexextra
    texlive-fontsextra
    texlive-latexextra
    tmux
    tree
    ttf-ubuntu-font-family
    usbutils  # lsusb
    virt-manager
    wireguard-tools
    wireshark-qt
    xclip
    yamllint
    yarn
    yt-dlp
    ttf-iosevka-nerd
    ttf-ms-fonts
    gpick
    amazon-workspaces-bin
    gnome-shell-extension-unite
    gnome-shell-extension-dash-to-dock
    gnome-extra
    gnome-icon-theme-extras
)

yay -S "${pkgs[@]}" --noconfirm

# Ubuntu fonts.
yay -Rnsdd bubblewrap --noconfirm || true
yay -S fontconfig-ubuntu  --noconfirm

sudo -H python3 -m pip install pyright virtualenv yapf flake8
sudo -H npm install -g typescript typescript-language-server eslint prettier

# Post install.
sudo usermod -a -G docker "$USER"
sudo usermod -a -G libvirt "$USER"
sudo usermod -a -G wireshark "$USER"
sudo systemctl enable libvirtd.service --now
sudo systemctl enable docker.service --now
sudo virsh net-autostart default  # libvirt connection
