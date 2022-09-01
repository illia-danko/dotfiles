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
    gpick
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
    pulseaudio-alsa
    pulseaudio-bluetooth
    qemu
    ripgrep
    shellcheck
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
    stylua  # lua formatter
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
