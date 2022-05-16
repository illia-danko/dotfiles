#!/bin/sh

# Source https://wiki.archlinux.org/title/Color_output_in_console.

# Common.
[ -n "${EDITOR}" ] && alias e="$EDITOR"
[ -x "$(command -v diff)" ] && alias diff='diff --color=auto'
[ -x "$(command -v grep)" ] && alias grep='grep --color=auto'
[ -x "$(command -v ip)" ] && alias ip='ip -color=auto'
if [ -x "$(command -v ls)" ]; then
    [ "$(uname)" = "Linux" ] && alias ls='ls --color=auto'
    [ "$(uname)" = "Darwin" ] && alias ls='ls -G'
fi
[ -x "$(command -v nvim)" ] && alias vim="nvim"
[ -x "$(command -v bc)" ] && alias bc="bc -l"
[ -x "$(command -v rlwrap)" ] && [ -x "$(command -v sbcl)" ] && alias sbcl="rlwrap sbcl"
[ -x "$(command -v rlwrap)" ] && [ -x "$(command -v bb)" ] && alias bb-repl="rlwrap bb --nrepl-server"
[ -x "$(command -v clj)" ] && alias repl="clj -M:cider/nrepl"
[ -x "$(command -v rlwrap)" ] && [ -x "$(command -v bb)" ] && alias bb="rlwrap bb"
[ -x "$(command -v newsboat)" ] && alias nb="newsboat"
[ -x "$(command -v todo.sh)" ] && alias t="todo.sh"
[ -x "$(command -v dmesg)" ] && alias dmesg='dmesg --color=always | less'
[ -x "$(command -v clj)" ] && alias clj-repl="clj -M:cider/nrepl"
[ -x "$(command -v fdfind)" ] && alias fd="fdfind"
