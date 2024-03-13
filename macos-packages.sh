#!/usr/bin/env bash

package_manager() {
    # Install homebrew.
    [ ! -d "/opt/homebrew/bin" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH="/opt/homebrew/bin:$PATH"
}


core_pkgs() {
    pkgs=(
        anki
        clang-format
        cmake
        dive
        eslint
        fd
        ffmpeg
        fzf
        gnupg
        golang
        google-cloud-sdk # work specific
        htop
        alacritty
        jq
        lazygit
        lf
        lua-language-server
        mpv
        neovim
        newsboat
        nmap
        npm
        p7zip
        pinentry-mac
        ripgrep
        rust
        shellcheck
        stylua  # lua formatter
        tmux
        tree
        wget
        yamllint
        yapf
        yarn
        yt-dlp
        gopls
        golines
        golangci-lint
        dlv
        prettier
        eslint
        pyright
        typescript
        typescript-language-server
        zk
        n
    )

    brew install "${pkgs[@]}"
    brew uninstall --ignore-dependencies node
    sudo n 20 # install node lts version
}

misc_pkgs() {
    # fonts.
    brew tap homebrew/cask-fonts
    brew install --cask font-jetbrains-mono-nerd-font

    # zsh.
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

optional_pkgs() {
    pkgs=(
        qbittorrent
    )

    brew install "${pkgs[@]}"
    brew uninstall --ignore-dependencies node
}

work_pkgs() {
    pkgs=(
        bloomrpc
        devcontainer
        k9s
        kubectl
    )

    brew install "${pkgs[@]}"
    brew uninstall --ignore-dependencies node
}

alacritty_finder_icon() {
    icon_path=/Applications/Alacritty.app/Contents/Resources/alacritty.icns
    if [ ! -f "$icon_path" ]; then
        echo "Can't find existing icon, make sure Alacritty is installed"
        exit 1
    fi

    echo "Backing up existing icon"
    hash="$(shasum $icon_path | head -c 10)"
    mv "$icon_path" "$icon_path.backup-$hash"

    echo "Downloading replacement icon"
    icon_url=https://github.com/hmarr/dotfiles/files/8549877/alacritty.icns.gz
    curl -sL $icon_url | gunzip > "$icon_path"

    touch /Applications/Alacritty.app
    killall Finder
    killall Dock
}


core_pkgs
misc_pkgs
work_pkgs
# alacritty_finder_icon
