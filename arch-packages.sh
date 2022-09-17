#!/usr/bin/env bash

pkgs=(
    air
    alacritty
    alsa-plugins
    alsa-utils
    amazon-workspaces-bin
    audacity
    bc
    biber  # homepage
    cmake
    docker
    fd
    ffmpeg
    fzf
    gnome-extra
    gnome-icon-theme-extras
    gnome-shell-extension-dash-to-dock
    gnome-shell-extension-unite
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
    parcellite
    pigz
    postgresql
    pulseaudio-alsa
    pulseaudio-bluetooth
    qemu
    ripgrep
    shellcheck
    stylua  # lua formatter
    texlive-bibtexextra
    texlive-fontsextra
    texlive-latexextra
    tmux
    tree
    ttf-iosevka-nerd
    ttf-ms-fonts
    ttf-ubuntu-font-family
    usbutils  # lsusb
    virt-manager
    wireguard-tools
    wireshark-qt
    xclip
    yamllint
    yarn
    yt-dlp
    papirus-icon-theme
    libreoffice-fresh
    libreoffice-fresh-en-gb
    libreoffice-fresh-uk
    tmux-plugin-manager-git
    urlview
)

yay -S "${pkgs[@]}" --noconfirm

# Ubuntu fonts.
yay -Rnsdd bubblewrap --noconfirm || true
yay -S fontconfig-ubuntu --noconfirm
yay -S bubblewrap --noconfirm

sudo -H python3 -m pip install pyright virtualenv yapf flake8
sudo -H npm install -g typescript typescript-language-server eslint prettier

# Post install.
sudo usermod -a -G docker "$USER"
sudo usermod -a -G libvirt "$USER"
sudo usermod -a -G wireshark "$USER"
sudo systemctl enable libvirtd.service --now
sudo systemctl enable docker.service --now
sudo virsh net-autostart default  # libvirt connection
