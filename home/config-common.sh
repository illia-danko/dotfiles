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
export BROWSER="xdg-open-silently"

# Override man command.
# Use Emacs as a Man page viewer. Custom package modes are:
# - olivetty-mode is used for centering buffer content;
# - hide-mode-line-mode is used to hide modeline.
man() {
    # Show appropriate an error on no manual.
    /usr/bin/man "$*" > /dev/null 2>&1 || /usr/bin/man "$*" || return

    emacs-runner -e "(progn
                      (man \"$1\")
                      (delete-window)
                      (olivetti-mode 1)
                      (hide-mode-line-mode 1)
                      (local-set-key
                        \"q\"
                        (lambda ()
                          (interactive)
                          (kill-this-buffer)
                          (delete-frame))))"
}

export CLIPBOARD_COPY_COMMAND="wl-copy"
[ "$XDG_SESSION_TYPE" = "x11" ] && export CLIPBOARD_COPY_COMMAND="xclip -selection c"
export OPENER=run-mailcap # open/preview with mailcap (using by lf)

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
[ -x "$(command -v shellcheck)" ] && export SHELLCHECK_OPTS='--shell=sh --exclude=SC1090,SC2139,SC2155'
[ -x "$(command -v tmux)" ] && alias tt="[ -z $TMUX ] && tmux new -A -s HACK || tmux detach -E 'tmux new -A -s HACK'"
[ -x "$(command -v tmux)" ] && alias tw="[ -z $TMUX ] && tmux new -A -s WORK || tmux detach -E 'tmux new -A -s WORK'"
[ -x "$(command -v tmux)" ] && alias tm="[ -z $TMUX ] && tmux new -A -s MEDIA || tmux detach -E 'tmux new -A -s MEDIA'"
[ -x "$(command -v emacs)" ] && alias es="pkill emacs || true; emacs --daemon"

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
    --color=gutter:-1,pointer:1,hl:2,hl+:2,bg+:#2c313a
"

    export FZF_PREVIEW_COMMAND="cat {}"
    export FZF_DEFAULT_COMMAND='ag --ignore-dir venv --ignore-dir elm-stuff -g ""'
fi

export FZF_PROJECTS_NO_COLORS=1
export FZF_NOTES_DIR="$my_github/org"
