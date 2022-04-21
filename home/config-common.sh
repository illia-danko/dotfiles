#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Home configuration
#

# Exports.
[ -z "${XDG_CONFIG_HOME}" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "${XDG_CACHE_HOME}" ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "${XDG_DATA_HOME}" ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "${XDG_STATE_HOME}" ] && export XDG_STATE_HOME="$HOME/.local/state"

export VISUAL="nvim"
export EDITOR="$VISUAL"

# Use Emacs as a Man page viewer. Custom package modes are:
# - olivetty-mode is used for centring buffer conent;
# - hide-mode-line-mode is used to hide modeline.
man() {
    nvim -c "Man $1" -c "only"
}

export CLIPBOARD_COPY_COMMAND="wl-copy"
[ "$XDG_SESSION_TYPE" = "x11" ] && export CLIPBOARD_COPY_COMMAND="xclip -selection c"
export OPENER=run-mailcap # open/preview with mailcap (using by lf)
[ -f "/etc/arch-release" ] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

my_github="$HOME/github.com/elijahdanko"

[ -d "/usr/local/sbin" ] && export PATH="$PATH:/usr/local/sbin"
[ -d "/usr/local/mysql/bin" ] && export PATH="$PATH:/usr/local/mysql/bin"
[ -d "/usr/local/go/bin" ] && export PATH="/usr/local/go/bin:$PATH"
[ -d "$HOME/go/bin" ] && export PATH="$HOME/go/bin:$PATH"
[ -d "/usr/local/opt/openjdk" ] && export PATH="/usr/local/opt/openjdk/bin:$PATH"
[ -d "/usr/local/opt/llvm/bin" ] && export PATH="/usr/local/opt/llvm/bin:$PATH"
[ -d "$my_github/dotfiles/bin" ] && export PATH="$my_github/dotfiles/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -x "$(command -v minikube)" ] && eval '$(minikube docker-env)'
[ -x "$(command -v bat)" ] && export BAT_STYLE="plain"  # Using by Bat previewer.
[ -x "$(command -v gpg)" ] && export GPG_TTY="$(tty)"  # Using by vim-gnupg
[ -x "$(command -v shellcheck)" ] && export SHELLCHECK_OPTS='--shell=sh --exclude=SC1090,SC2139,SC2155'
[ -x "$(command -v tmux)" ] && alias tmuxs="tmux new -s TMUX"
[ -x "$(command -v tmux)" ] && alias tx="tmux list-sessions && tmux attach -t TMUX || tmux new -s TMUX"
[ -x "$(command -v tmux)" ] && alias tmuxw="tmux attach -t TMUX"
[ -x "$(command -v tmux)" ] && alias tmuxa="tmux attach -t "
[ -x "$(command -v tmux)" ] && alias tmuxls="tmux ls"


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
    --bind='ctrl-b:preview-half-page-up'
    --bind='ctrl-f:preview-half-page-down'
    --bind='ctrl-u:half-page-up'
    --bind='ctrl-d:half-page-down'
    --bind='alt-p:toggle-preview'
    --bind='ctrl-a:toggle-all'
    --color=gutter:-1,hl:2,hl+:2
"

    export FZF_PREVIEW_COMMAND="cat {}"
    export FZF_DEFAULT_COMMAND='ag --ignore-dir venv --ignore-dir elm-stuff -g ""'
fi

export FZF_NOTES_DIR="$my_github/org"
