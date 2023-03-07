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
    # gnome-terminal
    # obsidian-icon-theme
    audacity
    bc
    betterbird-bin  # thunderbird but better
    biber  # required by homepage
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
    gpaste  # clipboard manager
    graphviz
    htop
    hugo  # homepage
    hunspell-en_us
    hunspell-en_us
    inetutils # hostname
    inkscape
    jq
    kubectl
    lazygit
    lf
    libreoffice-fresh
    libreoffice-fresh-en-gb
    libreoffice-fresh-uk
    libvirt
    lua-language-server
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
    ttf-jetbrains-mono-nerd
    usbutils  # lsusb
    virt-manager
    wireguard-tools
    wireshark-qt
    wl-clipboard
    xclip
    xdg-desktop-portal
    xdg-desktop-portal-wlr  # (powered by wireplumber) required for screen sharing on Wayland
    yamllint
    yarn
    yt-dlp
    zsh-autosuggestions
    zsh-syntax-highlighting
)

sway_pkgs=(
    bemenu
    xdg-utils # xdg-open
    pipewire-pulse
    pulsemixer # sound cli interface
    slurp  # select regeion on Wayland
    wf-recorder  # audio and screen recording for Wayland
    xfce4-settings  # for xfce4-appearance-settings
    thunar  # gui file manager
    brightnessctl
    mako  # notification service
    swaylock  # see sway/config
    swayidle  # see sway/config
    imv  # image viewer
    waybar
    otf-font-awesome  # required by waybar
    ttf-roboto  # required by waybar
    ttf-roboto-mono  # required by waybar
    mtpfs  # android mtp
    gvfs-mtp  # android mtp
)


## Ubuntu fonts.
[ -x "$(command -v gnome-shell)" ] && yay -Rnsdd bubblewrap --noconfirm || true
yay -S fontconfig-ubuntu
[ -x "$(command -v gnome-shell)" ] && yay yay -S bubblewrap --noconfirm || true

# Install packages.
yay -S "${pkgs[@]}" --noconfirm
[ -n "$SWAYSOCK" ] && yay -S "${sway_pkgs[@]}" --noconfirm

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
systemctl --user enable wireplumber --now
