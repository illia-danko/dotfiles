#!/usr/bin/env bash

core_pkgs() {
    pkgs=(
        build-essential
        clangd
        cmake
        curl
        dconf-editor
        fd-find  # fd
        ffmpeg
        fonts-noto-color-emoji
        gimp
        gimp-help-en
        git
        git-doc
        gridsite-clients # urlencode
        htop
        inotify-tools # required by elixir
        jq
        kazam
        libvterm-dev
        mpv
        neofetch
        net-tools
        nmap
        pandoc
        pkg-config
        postgresql
        python3
        python3-pip
        qbittorrent
        ripgrep
        rlwrap
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
        zsh
        zsh-autosuggestions
        zsh-doc
        zsh-syntax-highlighting
    )

    sudo apt install -f "${pkgs[@]}"
    sudo apt purge yt-dlp
}

gnome_pkgs() {
    pkgs=(
	    gnome-tweaks
        gnome-shell-extension-gpaste
        gnome-shell-extensions
    )

    sudo apt install -f "${pkgs[@]}"
}

mint_pkgs() {
    pkgs=(
        parcellite
    )

    sudo apt install -f "${pkgs[@]}"
}

# Make qt application look the same as gtk apps.
qt_look_and_feel_pkgs() {
    pkgs=(
        libcanberra-gtk-module
        qt5ct
        qt5-gtk2-platformtheme
        qt5-gtk-platformtheme
        qt5-style-plugins
    )
    sudo apt install -f "${pkgs[@]}"
}

custom_pkgs() {
    script_name="$(readlink -f "${BASH_SOURCE[0]}")"
    script_dir="$(dirname "$script_name")"

    for receipt in "$script_dir/debian/packages/"*PKGCONFIG; do
        bash "$receipt"
    done
}

node_pkgs() {
    sudo npm install -g n yarn vscode-css-languageserver-bin typescript-language-server typescript pyright eslint prettier
}

go_pkgs() {
    /usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest
    /usr/local/go/bin/go install github.com/gokcehan/lf@latest
    /usr/local/go/bin/go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    /usr/local/go/bin/go install github.com/jesseduffield/lazygit@latest
    /usr/local/go/bin/go install github.com/segmentio/golines@latest
    /usr/local/go/bin/go install golang.org/x/tools/cmd/goimports@latest
    /usr/local/go/bin/go install golang.org/x/tools/gopls@latest
    /usr/local/go/bin/go install mvdan.cc/gofumpt@latest
    /usr/local/go/bin/go install github.com/illia-danko/fdir@latest
}

rust_pkgs() {
   cargo install stylua
}

python_pkgs() {
    sudo pip3 install yt-dlp
}

misc_pkgs() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

work_pkgs() {
    sudo npm install -g @devcontainers/cli
    /usr/local/go/bin/go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest # grpc cli client
}

core_pkgs
# custom_pkgs
# gnome_pkgs
# mint_pkgs
# qt_look_and_feel_pkgs # run qt5ct to configure gtk2 theme
node_pkgs
go_pkgs
rust_pkgs
python_pkgs
misc_pkgs
work_pkgs
