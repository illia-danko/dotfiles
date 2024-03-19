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
[ -x "$(command -v luajit)" ] && [ -x "$(command -v rlwrap)" ] && alias luajit="rlwrap luajit"
s="$HOME/github.com/LuaLS/lua-language-server/3rd/luamake/luamake" && [ -f "$s" ] && alias luamake="$s"

# Print system memory stats in MB.
ps_mb() {
    ps afu | awk 'NR>1 {$5=int($5/1024)"M";}{ print;}'
}

# Use Neovim as a Man page viewer.
man() {
    # Show appropriate an error on no manual.
    local man_cmd="$(whereis man | awk '{print $2}')"
    "$man_cmd" "$*" > /dev/null 2>&1 || "$man_cmd" "$*" || return
    $EDITOR -c "Man $*" -c "only" -c "set laststatus=0" -c "nmap <buffer> q ZQ"
}

alias url_decode='perl -pe '\''s/\+/ /g;'\'' -e '\''s/%(..)/chr(hex($1))/eg;'\'' <<< '
url_encode() {
    printf %s "$1" | jq -sRr @uri
}

unset s
