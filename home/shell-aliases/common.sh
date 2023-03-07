#!/bin/sh

# Source https://wiki.archlinux.org/title/Color_output_in_console.

# Common.
[ -n "${EDITOR}" ] && alias e="$EDITOR"
[ -x "$(command -v diff)" ] && alias diff='diff --color=auto'
[ -x "$(command -v grep)" ] && alias grep='grep --color=auto'
[ -x "$(command -v ip)" ] && alias ip='ip -color=auto'
[ -x "$(command -v ls)" ] && alias ls='ls --color=auto'
[ -x "$(command -v bc)" ] && alias bc="bc -l"
[ -x "$(command -v dmesg)" ] && alias dmesg='dmesg --color=always | less'
[ -x "$(command -v fdfind)" ] && alias fd="fdfind"
[ -x "$(command -v newsboat)" ] && alias nb="newsboat"
[ -x "$(command -v tmux)" ] && alias t="tmux new -d -s HACK; tmux new -d -s WORK; tmux new -d -s MEDIA; tmux attach -t HACK"
[ -x "$(command -v clj)" ] && alias clj-repl="clj -M:cider/nrepl"
[ -x "$(command -v mpv)" ] && alias mpv="gnome-session-inhibit --inhibit idle mpv"  # https://github.com/mpv-player/mpv/issues/8097

# Use Neovim as a Man page viewer.
man() {
    # Show appropriate an error on no manual.
    /usr/bin/man "$*" > /dev/null 2>&1 || /usr/bin/man "$*" || return
    $EDITOR -c "Man $*" -c "only" -c "set laststatus=0" -c "nmap <buffer> q ZQ"
}
