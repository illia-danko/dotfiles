#!/usr/bin/env bash


# Install homebrew.
[ ! -d "/opt/homebrew/bin" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
PATH="/opt/homebrew/bin:$PATH"

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
    iterm2
    jq
    kubectl
    lazygit
    lf
    lua-language-server
    mpv
    neovim
    newsboat
    nmap
    nodejs
    npm
    p7zip
    pinentry-mac
    pyright
    redis@6.2
    ripgrep
    rust
    shellcheck
    sshuttle # work specific
    stylua  # lua formatter
    tmux
    tree
    typescript
    wget
    yamllint
    yapf
    yarn
    yt-dlp
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
