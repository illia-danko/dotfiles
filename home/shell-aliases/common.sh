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
[ -x "$(command -v tmux)" ] && alias t="tmux new -d -s HACK; tmux new -d -s WORK; tmux new -d -s MEDIA; tmux attach -t HACK"
[ -x "$(command -v clj)" ] && alias clj_repl="clj -M:cider/nrepl"
[ -x "$(command -v wget)" ] && alias getpage="wget -qO-"
[ -x "$(command -v lsof)" ] && alias listen_ports="lsof -i -P | grep LISTEN"
[ -x "$(command -v emacs)" ] && alias es="pkill -f emacs || true; emacs --daemon"

# Print system memory stats in MB.
ps_mb() {
    ps afu | awk 'NR>1 {$5=int($5/1024)"M";}{ print;}'
}

# Use Emacs as a Man page viewer. Custom package modes are:
# - olivetti-mode for centering buffer content;
# - hide-mode-line-mode for hiding modeline.
man() {
    # Show appropriate an error on no manual.
    /usr/bin/man "$*" > /dev/null 2>&1 || /usr/bin/man "$*" || return

    emacs-runner -e "(progn
                      (man \"$1\")
                      (delete-window)
					  (olivetti-mode)
					  (hide-mode-line-mode)
                      (local-set-key
                        \"q\"
                        (lambda ()
                          (interactive)
                          (kill-this-buffer)
                          (delete-frame))))"
}

alias url_decode='perl -pe '\''s/\+/ /g;'\'' -e '\''s/%(..)/chr(hex($1))/eg;'\'' <<< '
url_encode() {
    printf %s "$1" | jq -sRr @uri
}

