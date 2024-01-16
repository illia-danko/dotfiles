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
s="$HOME/github.com/LuaLS/lua-language-server/3rd/luamake/luamake" && [ -f "$s" ] && alias luamake="$s"
[ -x "$(command -v emacs)" ] && alias es="pkill -f emacs || true; emacs --daemon"

alias url_decode='perl -pe '\''s/\+/ /g;'\'' -e '\''s/%(..)/chr(hex($1))/eg;'\'' <<< '
url_encode() {
    printf %s "$1" | jq -sRr @uri
}

unset s
