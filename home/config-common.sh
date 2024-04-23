#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Home configuration
#

# Exports.
[ -z "${XDG_CONFIG_HOME}" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "${XDG_CACHE_HOME}" ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "${XDG_DATA_HOME}" ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "${XDG_STATE_HOME}" ] && export XDG_STATE_HOME="$HOME/.local/state"

export VISUAL=nvim
export EDITOR="$VISUAL"
export CLIPBOARD_COPY_COMMAND="xclip -in -selection c"
[ "$(uname)" = "Darwin" ] && export CLIPBOARD_COPY_COMMAND="pbcopy"

[ -d "/usr/local/sbin" ] && export PATH="$PATH:/usr/local/sbin"
[ -d "/usr/local/mysql/bin" ] && export PATH="$PATH:/usr/local/mysql/bin"
[ -d "/usr/local/go/bin" ] && export PATH="/usr/local/go/bin:$PATH"
[ -d "$HOME/go/bin" ] && export PATH="$HOME/go/bin:$PATH"
[ -d "/usr/local/opt/openjdk" ] && export PATH="/usr/local/opt/openjdk/bin:$PATH"
[ -d "/usr/local/opt/llvm/bin" ] && export PATH="/usr/local/opt/llvm/bin:$PATH"
[ -d "/opt/homebrew/opt/redis@6.2/bin" ] && export PATH="/opt/homebrew/opt/redis@6.2/bin:$PATH"
[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"
[ -d "$HOME/.bin" ] && export PATH="$HOME/.bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.mix/escripts" ] && export PATH="$HOME/.mix/escripts:$PATH"
s="$HOME/github.com/LuaLS/lua-language-server/bin" && [ -d "$s" ] && export PATH="$s:$PATH"
s="/usr/local/bin" && [ -d "$s" ] && export PATH="$s:$PATH"
s="$HOME/.google-cloud-sdk/path.zsh.inc"; [ -f "$s" ] && . "$s"
s="$HOME/.krew/bin" && [ -d "$s" ] && export PATH="$s:$PATH"
[ -x "$(command -v minikube)" ] && eval '$(minikube docker-env)'
[ -x "$(command -v bat)" ] && export BAT_STYLE="plain"  # used by Bat previewer
[ -x "$(command -v shellcheck)" ] && export SHELLCHECK_OPTS='--shell=bash --exclude=SC1090,SC2139,SC2155'
[ -x "$(command -v iex)" ] && export ERL_AFLAGS="-kernel shell_history enabled"
[ -x "$(command -v gnome-shell)" ] && [ -f "/etc/arch-release" ] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# NixOS.
if grep -q 'NAME=NixOS' /etc/os-release; then
    [ -x "$(command -v xhost)" ] && xhost + &> /dev/null # share clipboard between docker and host machine using xclip
fi

# SSL termination firefox.
# Terminate TLS (Firefox/Chrome).
export SSLKEYLOGFILE="$HOME/.sslkeylog"
export NSS_ALLOW_SSLKEYLOGFILE=1
export MOZ_ENABLE_WAYLAND=1 # run firefox on wayland naively
export CLOUDSDK_PYTHON=/usr/bin/python3
export ZK_NOTEBOOK_DIR="$HOME/github.com/illia-danko/zettelkasten"
if [ -x "$(command -v fzf)" ]; then
    export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
    --no-mouse
    --layout=reverse
    --height 40%
    --border
    --multi
    --exact
    --preview-window=hidden
    --bind='alt-w:execute-silent(echo -n {} | $CLIPBOARD_COPY_COMMAND)'
    --bind='ctrl-e:print-query'
    --bind='ctrl-b:half-page-up'
    --bind='ctrl-f:half-page-down'
    --bind='ctrl-u:preview-half-page-up'
    --bind='ctrl-d:preview-half-page-down'
    --bind='alt-p:toggle-preview'
    --bind='ctrl-a:toggle-all'
    --color=gutter:-1,fg:-1,fg+:-1,pointer:1,hl:2,hl+:2,bg+:8
"

    export FZF_PREVIEW_COMMAND="cat {}"
    export RG_OPTS_FILTER='--hidden --glob=!{.git,.svn,.hg,CVS,.bzr,vendor,node_modules,dist,venv,elm-stuff,.clj-kondo,.lsp,.cpcache}'
    export FZF_DEFAULT_COMMAND="rg --files $RG_OPTS_FILTER"
    export FZF_NOTES_DIR="$HOME/github.com/illia-danko/zettelkasten"
    export FZF_PROJECTS_ROOT_DIRS=" \
        $HOME/github.com \
        $HOME/gitlab.com \
        $HOME/codeberg.org \
        $HOME/.config/nvim \
        $HOME/.local/share/nvim \
        $HOME/bitbucket.org \
        $HOME/bitbucket.dentsplysirona.com"
    export FZF_PROJECTS_PATTERNS=".git"
fi

# Clean up.
unset s
