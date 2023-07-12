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
    k9s
    kubectl
    lazygit
    lf
    lua-language-server
    mpv
    neovim
    newsboat
    nmap
    node@18
    npm
    p7zip
    pinentry-mac
    redis@6.2
    ripgrep
    rust
    shellcheck
    sshuttle # work specific
    stylua  # lua formatter
    tmux
    tree
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
brew install --cask font-jetbrains-mono-nerd-font

go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/segmentio/golines@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# NOTE: On `zsh: bad CPU type in executable: node` consider to install `softwareupdate --install-rosetta`.
npm install -g n vscode-langservers-extracted typescript-language-server typescript pyright eslint prettier emmet-ls
brew uinstall node@18  # use `sudo n 18` over brew node package
