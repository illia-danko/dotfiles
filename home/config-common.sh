#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Home configuration
#

# Exports.
[ -z "${XDG_CONFIG_HOME}" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "${XDG_CACHE_HOME}" ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "${XDG_DATA_HOME}" ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "${XDG_STATE_HOME}" ] && export XDG_STATE_HOME="$HOME/.local/state"

export VISUAL=emacs-runner
export EDITOR="$VISUAL"
export BROWSER="open-silently"

export LS_COLORS='di=1;35:ex=01;33'
export SYSTEM_COLOR_THEME="dark"
export CLIPBOARD_COPY_COMMAND="xclip -selection c"
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
    export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!{.git,.svn,.hg,CVS,.bzr,vendor,node_modules,dist,venv,elm-stuff,.clj-kondo,.lsp,.cpcache}'"
    export FZF_NOTES_DIR="$HOME/github.com/illia-danko/org"
fi
