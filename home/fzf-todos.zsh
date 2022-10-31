# Copyright (c) 2022 Illia Danko

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
[ -z "${FZF_TODOS_PROMPT-}" ] && FZF_TODOS_PROMPT='Todos> '
[ -z "${FZF_TODOS_COPY_COMMAND-}" ] && FZF_TODOS_COPY_COMMAND="$CLIPBOARD_COPY_COMMAND"

# Ensure precmds are run after cd.
function _fzf_todos_redraw_prompt {
    local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
    zle reset-prompt
}
zle -N _fzf_todos_redraw_prompt

function _fzf_todos_preview {
    states=("${(s[|])FZF_TODOS_PREVIEW_WINDOW}")
    [ "${#states[@]}" -eq 1 ] && echo "${FZF_TODOS_PREVIEW_WINDOW}" && return
    [ "${#states[@]}" -gt 2 ] && echo "${FZF_TODOS_PREVIEW_WINDOW}" && return
    [ $(tput cols) -lt "${FZF_TODOS_PREVIEW_THRESHOLD}" ] && echo "${states[2]}" && return
    echo "${states[1]}"
}

function fzf_todos {
    local new_entry_key=${FZF_TODOS_NEW_NOTE_KEY:-ctrl-o}
    local toggle_entry_key=${FZF_TODOS_TOGGLE_ENTRY_KEY:-ctrl-u}
    local delete_entry_key=${FZF_TODOS_DELETE_ENTRY_KEY:-ctrl-d}
    local lines=$(eval "$FZF_PREVIEW_BIN" --todo-tags ${FZF_TODOS_FILE} | fzf \
        --prompt "${FZF_TODOS_PROMPT}" \
        --print-query \
        --tac \
        --delimiter=": " \
        --with-nth='3..' \
        --ansi \
        --multi \
        --query="$*" \
        --expect="$new_entry_key,$toggle_entry_key,$delete_entry_key" \
        --header="${new_entry_key}:new, ${toggle_entry_key}:toggle, ${delete_entry_key}:delete" \
        --preview="echo {3..}" \
        --preview-window=$(_fzf_todos_preview) \
    )
    if [[ -z "$lines" ]]; then
        zle && zle _fzf_todos_redraw_prompt
        return 1
    fi

    local key="$(head -n2 <<< "$lines" | tail -n1)"
    local line_number=${"$(tail -n1 <<< "${lines}" | awk '{print $1}')"%?}
    case "$key" in
        "$new_entry_key") _fzf_todos_new_entry "$(head -n1 <<< "${lines}")";;
        "$toggle_entry_key") _fzf_todos_toggle_entry "$line_number";;
        "$delete_entry_key") _fzf_todos_delete_entry "$line_number";;
        *) _fzf_todos_jump "$line_number";;
    esac

    zle && zle _fzf_todos_redraw_prompt || true
}

function _fzf_todos_new_entry {
    echo "# TODO: $1" >> "$FZF_TODOS_FILE"
}

function _fzf_todos_toggle_entry {
    local values=("TODO" "DONE")
    local line="$(head -n$1 "${FZF_TODOS_FILE}" | tail -n1)"
    case "$(awk '{print substr($2, 1, length($2)-1)}' <<< "$line")" in
        DONE) values=("DONE" "TODO");;
    esac
    perl -i -p -e "s/^# ${values[1]}/# ${values[2]}/ if ${1} .. ${1}" "${FZF_TODOS_FILE}"
}

function _fzf_todos_delete_entry {
    perl -i -p -e "s/.*\R// if ${1} .. ${1}" "${FZF_TODOS_FILE}"
}

function _fzf_todos_jump {
    $EDITOR +$1 ${FZF_TODOS_FILE}
}

zle -N fzf_todos

bindkey ${FZF_TODOS_TRIGGER_KEYMAP:-'^q'} fzf_todos
