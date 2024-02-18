#!/usr/bin/env bash
package_manager() {
    pushd /tmp || return
    git clone https://aur.archlinux.org/yay.git
    cd yay || return
    makepkg -is --noconfirm
    rm -rf yay
    popd || return

    yay -Syu --noconfirm
}

core_pkgs() {
    pkgs=(
        bc
        cmake
        cronie  # crontab
        dmidecode  # virt-manager
        dnsmasq  # virt-manager
        docker
        docker-compose
        docker-scan # scan vulnerabilities
        elixir
        elixir-ls
        erlang
        fd
        ffmpeg
        firefox
        flake8
        fzf
        gnupg
        google-chrome
        graphviz
        htop
        hunspell-en_us
        inetutils # hostname
        inotify-tools  # used by elixir
        intel-media-driver # required by Firefox
        jq
        lazygit
        lf # cli file navigator
        libvirt
        lua-language-server
        mpv
        neofetch
        nmap
        nodejs-lts-hydrogen
        noto-color-emoji-fontconfig # fix alacritty emoji
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji  # fix alacritty emoji
        npm
        nvim
        p7zip
        pandoc
        perl-file-mimeinfo # provides mimeopen and mimetype (see https://wiki.archlinux.org/title/default_applications#perl-file-mimeinfo)
        pigz # docker
        postgresql
        python-pip
        python-virtualenv
        qemu # virt-manager
        qemu-emulators-full # libvirt
        ripgrep
        rsync
        rust
        rust-analyzer
        shellcheck
        speech-dispatcher  # required by firefox
        stylua
        thunderbird
        tmux
        tree
        ttf-ms-fonts # Microsoft fonts
        ttf-ubuntu-font-family
        unzip
        usbutils  # lsusb
        virt-manager
        viu # preview images in the terminal
        wireguard-tools
        yamllint
        yapf
        yarn
        yarr # rss browser reader
        yt-dlp
        zip
        zsh-autosuggestions
        zsh-syntax-highlighting
    )

    yay -S "${pkgs[@]}"

    sudo usermod -a -G libvirt "$USER"
    sudo systemctl enable libvirtd.service --now
    sudo systemctl enable cronie.service --now
    sudo usermod -a -G docker "$USER"
    sudo systemctl enable docker.service --now
}

work_pkgs() {
    pkgs=(
        google-cloud-cli # work related
        google-cloud-cli-gke-gcloud-auth-plugin # work related
        k9s # cli k8s frontend
        kubectl
        slack-desktop
        devcontainer-cli
    )

    yay -S "${pkgs[@]}"
}

gnome_pkgs() {
    pkgs=(
        gnome-shell-extension-dash-to-dock
        gpaste # clipboard manager, gnome shell extension
        obsidian-icon-theme
        xclip
    )

    yay -S "${pkgs[@]}"
}

sway_pkgs() {
    pkgs=(
        autotiling-rs  # spiral tiling sway/i3
        bemenu # wayland menu / runner
        blueman # bluetooth manager
        brightnessctl # part of sway wm
        cliphist # persistent clipboard history
        fontconfig-ubuntu # alternative to fontconfig
        gnome-keyring # required by auto unlock gpg, ssh keys
        greetd # greeter manager
        greetd-tuigreet # required by greetd
        grim # for color-pick
        gtk-engine-murrine # required for arc theme
        gvfs-mtp  # android mtp
        imagemagick # required by grim
        imv # image viewer
        libsecret # required by auto unlock gpg, ssh keys
        mako # notification service
        man-pages # posix pages
        mtpfs # android mtp
        nwg-look # change theme style for gtk, kde and xwayland
        otf-font-awesome  # required by waybar
        pipewire-pulse
        pulsemixer # sound cli interface
        python-i3ipc # sway rpc
        qt5-wayland
        qt6-wayland
        seahorse # required by auto unlock gpg, ssh keys
        slurp  # select regeion on Wayland
        swaybg  # set background from terminal
        swayidle  # see sway/config
        swaylock  # see sway/config
        thunar  # gui file manager
        ttf-roboto  # required by waybar
        ttf-roboto-mono  # required by waybar
        ttf-ubuntu-font-family
        ttf-ubuntu-mono-nerd
        ttf-ubuntu-nerd
        waybar # part of sway wm
        wev-git # transcribe keyboard and mouth events
        wf-recorder  # audio and screen recording for Wayland
        wl-clipboard
        wlsunset # day/night gamma adjustments
        xdg-desktop-portal
        xdg-desktop-portal-wlr  # (powered by wireplumber) required for screen sharing on Wayland
        xdg-utils # xdg-open
        xfce4-settings # as nwg-look is in use, we still need the package since it still has useful gnome dependencies.
        xorg-server-xvfb  # required by cypress javascript library to run a virtual desktop
        xorg-xwayland
    )

    yay -S "${pkgs[@]}"

    systemctl --user enable wireplumber --now  # audio
    systemctl --user enable pipewire-pulse.service --now  # bluetooth

    # Auto open on login ssh and gpg keys.
    sudo perl -i -p -e 's/components=".*"/components="pkcs11,secrets,ssh"/;' \
        /usr/lib/systemd/user/gnome-keyring-daemon.service
    systemctl --user enable gcr-ssh-agent.service
    systemctl --user enable gnome-keyring-daemon.service --now
    f="/etc/pam.d/login"
    s="auth optional pam_gnome_keyring.so"
    grep -q "$s" "$f" || (echo "$s" | sudo tee -a "$f")
    s="session optional pam_gnome_keyring.so auto_start"
    grep -q "$s" "$f" || (echo "$s" | sudo tee -a "$f")
    unset f s

    ## Login Manager.
    sudo perl -i -p -e 's/command = ".*"/command = "tuigreet --cmd sway"/;' \
        /etc/greetd/config.toml || true
    sudo chmod -R go+r /etc/greetd/
    sudo usermod -a -G greetd "$USER"
    sudo systemctl enable greetd.service

    # Disable hibernation on lid closed when logout.
    # sudo echo "HandleLidSwitchExternalPower=ignore" >> /etc/systemd/logind.conf
}

wm_pkgs() {
    [ -x "$(command -v gnome-shell)" ] && gnome_pkgs
    [ -n "$SWAYSOCK" ] && sway_pkgs
}

optional_pkgs() {
    pkgs=(
        # anki
        audacity
        biber  # required by homepage
        gimp # gimp-devel is a good alternative supported hidpi and requires compilation
        hugo  # homepage
        inkscape
        libreoffice-fresh
        libreoffice-fresh-en-gb
        libreoffice-fresh-uk
        qbittorrent
        texlive-bibtexextra # homepage
        texlive-fontsextra # homepage
        texlive-latexextra # homepage
        wireshark-qt
        telegram-desktop
        zapzap # whatsapp clone
    )

    yay -S "${pkgs[@]}"
    sudo usermod -a -G wireshark "$USER"
}

node_pkgs() {
    sudo -H npm install -g n vscode-css-languageserver-bin vscode-langservers-extracted typescript typescript-language-server eslint prettier pyright
}

go_pkgs() {
    go install golang.org/x/tools/gopls@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install github.com/segmentio/golines@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install github.com/illia-danko/fdir@latest
}

misc_pkgs() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

# Install packages.
package_manager
core_pkgs
# wm_pkgs
node_pkgs
go_pkgs
# work_pkgs
# optional_pkgs
misc_pkgs
