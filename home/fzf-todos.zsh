# Copyright (c) 2022 Elijah Danko

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

command -v fzf >/dev/null 2>&1 || return
[ -z "${FZF_TODOS_FILE-}" ] && >&2 echo "FZF_TODOS_FILE env is required." && return
[ -z "${FZF_PREVIEW_LINES-}" ] && FZF_PREVIEW_LINES="14"
[ -z "${FZF_PREVIEW_BIN-}" ] && FZF_PREVIEW_BIN="fzf-preview-bin"
[ -z "${FZF_TODOS_PREVIEW_WINDOW-}" ] && FZF_TODOS_PREVIEW_WINDOW="nohidden|hidden,down"
[ -z "${FZF_TODOS_PREVIEW_THRESHOLD-}" ] && FZF_TODOS_PREVIEW_THRESHOLD="160"
[ -z "${FZF_TODOS_COPY_COMMAND-}" ] && FZF_TODOS_COPY_COMMAND="wl-copy"
[ "$XDG_SESSION_TYPE" = "x11" ] && FZF_TODOS_COPY_COMMAND="xclip -selection c"
[ -z "${FZF_TODOS_PROMPT-}" ] && FZF_TODOS_PROMPT='Agenda> '
[ "$(uname)" = "Darwin" ] && FZF_TODOS_COPY_COMMAND="pbcopy"

# Ensure precmds are run after cd.
function fzf_todos_redraw_prompt {
    local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
    zle reset-prompt
}
zle -N fzf_todos_redraw_prompt

function fzf_todos_preview {
    states=("${(s[|])FZF_TODOS_PREVIEW_WINDOW}")
    [ "${#states[@]}" -eq 1 ] && echo "${FZF_TODOS_PREVIEW_WINDOW}" && return
    [ "${#states[@]}" -gt 2 ] && echo "${FZF_TODOS_PREVIEW_WINDOW}" && return
    [ $(tput cols) -lt "${FZF_TODOS_PREVIEW_THRESHOLD}" ] && echo "${states[2]}" && return
    echo "${states[1]}"
}

function fzf_todos {
    local copy_key=${FZF_TODOS_COPY_KEY:-alt-w}
    local new_entry_key=${FZF_TODOS_NEW_NOTE_KEY:-ctrl-o}
    local toggle_entry_key=${FZF_TODOS_TOGGLE_ENTRY_KEY:-ctrl-u}
    local delete_entry_key=${FZF_TODOS_DELETE_ENTRY_KEY:-ctrl-d}
    local fzf_todos_file_dir=$(dirname ${FZF_TODOS_FILE})
    local fzf_todos_file_base=$(basename ${FZF_TODOS_FILE})
    local lines=$(eval cat -n ${FZF_TODOS_FILE} | fzf \
        --prompt "${FZF_TODOS_PROMPT}" \
        --print-query \
        --ansi \
        --multi \
        --query="$*" \
        --expect="$new_entry_key" \
        --header="${new_entry_key}:new, ${toggle_entry_key}:toggle, ${delete_entry_key}:delete" \
        --preview="${FZF_PREVIEW_BIN} -np ${fzf_todos_file_dir} ${fzf_todos_file_base} {1} ${FZF_PREVIEW_LINES}" \
        --preview-window=$(fzf_todos_preview) \
    )
    if [[ -z "$lines" ]]; then
        zle && zle fzf_todos_redraw_prompt
        return 1
    fi

    local key="$(head -n2 <<< "$lines" | tail -n1)"
    if [[ "$key" == "$new_entry_key" ]]; then
        fzf_todos_new_entry "$(head -n1 <<< "${lines}")"
    else
        fzf_todos_jump "$(tail -n1 <<< "${lines}" | awk '{print $1}')"
    fi
    zle && zle fzf_todos_redraw_prompt || true
}

function fzf_todos_new_entry {
    local line="# TODO: $1"
    echo "\n$line" >> "$FZF_TODOS_FILE"
}

function fzf_todos_jump {
    $EDITOR +$1 ${FZF_TODOS_FILE}
}

zle -N fzf_todos

bindkey ${FZF_TODOS_TRIGGER_KEYMAP:-'^v'} fzf_todos
