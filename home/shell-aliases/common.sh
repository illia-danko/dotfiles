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
