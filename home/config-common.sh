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
export BROWSER="open-silently"

export LS_COLORS='di=1;35:ex=01;33'
export SYSTEM_COLOR_THEME="$(cat "$HOME"/.config/custom-appearance/background)"
export CLIPBOARD_COPY_COMMAND="wl-copy"
[ "$(uname)" = "Darwin" ] && export CLIPBOARD_COPY_COMMAND="pbcopy"
export OPENER=run-mailcap # open/preview with mailcap (used by lf)

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
[ -x "$(command -v minikube)" ] && eval '$(minikube docker-env)'
[ -x "$(command -v bat)" ] && export BAT_STYLE="plain"  # used by Bat previewer
[ -x "$(command -v shellcheck)" ] && export SHELLCHECK_OPTS='--shell=bash --exclude=SC1090,SC2139,SC2155'

# SSL termination firefox.
# Terminate TLS (Firefox/Chrome).
export SSLKEYLOGFILE="$HOME/.sslkeylog"
export NSS_ALLOW_SSLKEYLOGFILE=1
[ -n "$SWAYSOCK" ] && export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh

if [ "$SYSTEM_COLOR_THEME" = "dark" ]; then
    # One Dark Theme.
    export TTY_COLOR_BG0="#24283b"
    export TTY_COLOR_BG1="#2b2b2b"
    export TTY_COLOR_FG0="#c0caf5"
    export TTY_COLOR_FG1="#eeeeec"
    export TTY_COLOR_BLACK="#1d202f"
    export TTY_COLOR_RED="#f7768e"
    export TTY_COLOR_GREEN="#9ece6a"
    export TTY_COLOR_YELLOW="#e0af68"
    export TTY_COLOR_BLUE="#7aa2f7"
    export TTY_COLOR_MAGENTA="#bb9af7"
    export TTY_COLOR_CYAN="#7dcfff"
    export TTY_COLOR_WHITE="#a9b1d6"
    export TTY_COLOR_BRIGHT_BLACK="#414868"
    export TTY_COLOR_BRIGHT_RED="#f7768e"
    export TTY_COLOR_BRIGHT_GREEN="#9ece6a"
    export TTY_COLOR_BRIGHT_YELLOW="#e0af68"
    export TTY_COLOR_BRIGHT_BLUE="#7aa2f7"
    export TTY_COLOR_BRIGHT_MAGENTA="#bb9af7"
    export TTY_COLOR_BRIGHT_CYAN="#7dcfff"
    export TTY_COLOR_BRIGHT_WHITE="#c0caf5"
else
    # One Light Theme.
    export TTY_COLOR_BG0="#e1e2e7"
    export TTY_COLOR_BG1="#e0dcd9"
    export TTY_COLOR_FG0="#3760bf"
    export TTY_COLOR_FG1="#2e3436"
    export TTY_COLOR_BLACK="#e9e9ed"
    export TTY_COLOR_RED="#f52a65"
    export TTY_COLOR_GREEN="#587539"
    export TTY_COLOR_YELLOW="#8c6c3e"
    export TTY_COLOR_BLUE="#2e7de9"
    export TTY_COLOR_MAGENTA="#9854f1"
    export TTY_COLOR_CYAN="#007197"
    export TTY_COLOR_WHITE="#6172b0"
    export TTY_COLOR_BRIGHT_BLACK="#a1a6c5"
    export TTY_COLOR_BRIGHT_RED="#f52a65"
    export TTY_COLOR_BRIGHT_GREEN="#587539"
    export TTY_COLOR_BRIGHT_YELLOW="#8c6c3e"
    export TTY_COLOR_BRIGHT_BLUE="#2e7de9"
    export TTY_COLOR_BRIGHT_MAGENTA="#9854f1"
    export TTY_COLOR_BRIGHT_CYAN="#007197"
    export TTY_COLOR_BRIGHT_WHITE="#3760bf"
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
    --bind='ctrl-u:half-page-up'
    --bind='ctrl-d:half-page-down'
    --bind='ctrl-b:preview-half-page-up'
    --bind='ctrl-f:preview-half-page-down'
    --bind='alt-p:toggle-preview'
    --bind='ctrl-a:toggle-all'
    --color=gutter:-1,fg:-1,fg+:-1,pointer:1,hl:2,hl+:2,bg+:8
"

    export FZF_PREVIEW_COMMAND="cat {}"
    export RG_OPTS_FILTER='--hidden --glob=!{.git,.svn,.hg,CVS,.bzr,vendor,node_modules,dist,venv,elm-stuff,.clj-kondo,.lsp,.cpcache}'
    export FZF_DEFAULT_COMMAND="rg --files $RG_OPTS_FILTER"
    export FZF_NOTES_DIR="$HOME/github.com/illia-danko/docs"
fi
