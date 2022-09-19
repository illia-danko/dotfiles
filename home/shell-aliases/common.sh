#!/bin/sh

# Source https://wiki.archlinux.org/title/Color_output_in_console.

# Common.
[ -n "${EDITOR}" ] && alias e="$EDITOR"
[ -x "$(command -v diff)" ] && alias diff='diff --color=auto'
[ -x "$(command -v grep)" ] && alias grep='grep --color=auto'
[ -x "$(command -v ip)" ] && alias ip='ip -color=auto'
[ -x "$(command -v ls)" ] && alias ls='ls --color=auto'
[ -x "$(command -v bc)" ] && alias bc="bc -l"
[ -x "$(command -v rlwrap)" ] && [ -x "$(command -v sbcl)" ] && alias sbcl="rlwrap sbcl"
[ -x "$(command -v rlwrap)" ] && [ -x "$(command -v bb)" ] && alias bb-repl="rlwrap bb --nrepl-server"
[ -x "$(command -v clj)" ] && alias clj-repl="clj -M:cider/nrepl"
[ -x "$(command -v rlwrap)" ] && [ -x "$(command -v bb)" ] && alias bb="rlwrap bb"
[ -x "$(command -v newsboat)" ] && alias nb="newsboat"
[ -x "$(command -v todo.sh)" ] && alias t="todo.sh"
[ -x "$(command -v dmesg)" ] && alias dmesg='dmesg --color=always | less'
[ -x "$(command -v clj)" ] && alias clj-repl="clj -M:cider/nrepl"
[ -x "$(command -v fdfind)" ] && alias fd="fdfind"
[ -x "$(command -v mpv)" ] && alias mpv="gnome-session-inhibit --inhibit idle mpv"  # https://github.com/mpv-player/mpv/issues/8097
# See https://github.com/elijahdanko/dot-nvim.
[ -x "$(command -v newsboat)" ] && [ -x "$(command -v nvim)" ] && \
    alias nb="nvim -c 'ZenMode' -c 'term newsboat' -c 'startinsert'"
