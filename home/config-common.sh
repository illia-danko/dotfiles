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
export LS_COLORS='di=1;35:ex=01;33'

s="$HOME"/.config/appearance/background
if [ ! -f "$s" ]; then
    mkdir -p "$HOME"/.config/appearance
    echo light > "$s"
fi
export SYSTEM_COLOR_THEME="$(cat "$s")"
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
[ -x "$(command -v xhost)" ] && xhost + &> /dev/null # share clipboard between docker and host machine using xclip (special case for nixos)
[ -x "$(command -v gnome-shell)" ] && [ -f "/etc/arch-release" ] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# SSL termination firefox.
# Terminate TLS (Firefox/Chrome).
export SSLKEYLOGFILE="$HOME/.sslkeylog"
export NSS_ALLOW_SSLKEYLOGFILE=1
export MOZ_ENABLE_WAYLAND=1 # run firefox on wayland naively
export CLOUDSDK_PYTHON=/usr/bin/python3
export ZK_NOTEBOOK_DIR="$HOME/github.com/illia-danko/zettelkasten"
export TTY_FONT_SIZE="11.5"
[ "$(uname)" = "Darwin" ] && export TTY_FONT_SIZE="13"

if [ "$SYSTEM_COLOR_THEME" = "dark" ]; then
    # One Dark Theme.
    export TTY_COLOR_BG0="#282c34"
    export TTY_COLOR_BG1="#000000"
    export TTY_COLOR_BG2="#000000"
    export TTY_COLOR_FG0="#abb2bf"
    export TTY_COLOR_FG1="#eeeeec"
    export TTY_COLOR_BLACK="#181a1f"
    export TTY_COLOR_RED="#e86671"
    export TTY_COLOR_GREEN="#98c379"
    export TTY_COLOR_YELLOW="#e5c07b"
    export TTY_COLOR_BLUE="#61afef"
    export TTY_COLOR_MAGENTA="#c678dd"
    export TTY_COLOR_CYAN="#56b6c2"
    export TTY_COLOR_WHITE="#abb2bf"
    export TTY_COLOR_BRIGHT_BLACK="#5c6370"
    export TTY_COLOR_BRIGHT_RED="#e86671"
    export TTY_COLOR_BRIGHT_GREEN="#98c379"
    export TTY_COLOR_BRIGHT_YELLOW="#e5c07b"
    export TTY_COLOR_BRIGHT_BLUE="#61afef"
    export TTY_COLOR_BRIGHT_MAGENTA="#c678dd"
    export TTY_COLOR_BRIGHT_CYAN="#56b6c2"
    export TTY_COLOR_BRIGHT_WHITE="#abb2bf"
    export TTY_INACTIVE_PANE_BRIGHTNESS="0.7"
else
    # One Light Theme.
    export TTY_COLOR_BG0="#fafafa"
    export TTY_COLOR_BG1="#dfdedb"
    export TTY_COLOR_BG2="#dfdedb"
    export TTY_COLOR_FG0="#383a42"
    export TTY_COLOR_FG1="#2e3436"
    export TTY_COLOR_BLACK="#101012"
    export TTY_COLOR_RED="#e45649"
    export TTY_COLOR_GREEN="#50a14f"
    export TTY_COLOR_YELLOW="#986801"
    export TTY_COLOR_BLUE="#4078f2"
    export TTY_COLOR_MAGENTA="#a626a4"
    export TTY_COLOR_CYAN="#0184bc"
    export TTY_COLOR_WHITE="#383a42"
    export TTY_COLOR_BRIGHT_BLACK="#a0a1a7"
    export TTY_COLOR_BRIGHT_RED="#e45649"
    export TTY_COLOR_BRIGHT_GREEN="#50a14f"
    export TTY_COLOR_BRIGHT_YELLOW="#986801"
    export TTY_COLOR_BRIGHT_BLUE="#4078f2"
    export TTY_COLOR_BRIGHT_MAGENTA="#a626a4"
    export TTY_COLOR_BRIGHT_CYAN="#0184bc"
    export TTY_COLOR_BRIGHT_WHITE="#383a42"
    export TTY_INACTIVE_PANE_BRIGHTNESS="0.9"
fi

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
