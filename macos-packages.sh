#!/usr/bin/env bash


# Install homebrew.
[ ! -d "/opt/homebrew/bin" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
PATH="/opt/homebrew/bin:$PATH"

pkgs=(
    neovim
    # alacritty  # use custom build
    golang
    nodejs
    yarn
    clang-format
    stylua  # lua formatter
    shellcheck
    yamllint
    gnupg
    pinentry-mac
    cmake
    fd
    ffmpeg
    fzf
    htop
    jq
    kubectl
    lazygit
    lf
    mpv
    nmap
    npm
    p7zip
    ripgrep
    tmux
    yt-dlp
    newsboat
    anki
    tree
    typescript
    wget
    eslint
    rust
    google-cloud-sdk # work specific
    sshuttle # work specific
    yapf
    pyright
    lua-language-server
    dive
    zsh-autosuggestions
    zsh-syntax-highlighting
)

brew install "${pkgs[@]}"

brew tap homebrew/cask-fonts
brew install --cask font-iosevka-nerd-font

go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/segmentio/golines@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest

npm install -g typescript-language-server
