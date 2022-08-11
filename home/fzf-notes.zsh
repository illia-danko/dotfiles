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
[ -z "${FZF_NOTES_DIR-}" ] && >&2 echo "FZF_NOTES_DIR env is required." && return
[ -z "${FZF_PREVIEW_LINES-}"] && FZF_PREVIEW_LINES="14"
[ -z "${FZF_PREVIEW_BIN-}" ] && FZF_PREVIEW_BIN="fzf-preview-bin"
[ -z "${FZF_NOTES_PREVIEW_WINDOW-}" ] && FZF_NOTES_PREVIEW_WINDOW="nohidden|hidden,down"
[ -z "${FZF_NOTES_PREVIEW_THRESHOLD-}" ] && FZF_NOTES_PREVIEW_THRESHOLD="160"
[ -z "${FZF_NOTES_COPY_COMMAND-}" ] && FZF_NOTES_COPY_COMMAND="wl-copy"
[ "$XDG_SESSION_TYPE" = "x11" ] && FZF_NOTES_COPY_COMMAND="xclip -selection c"
[ -z "${FZF_NOTES_PROMPT-}" ] && FZF_NOTES_PROMPT='Notes> '
[ "$(uname)" = "Darwin" ] && FZF_NOTES_COPY_COMMAND="pbcopy"
[ -z "${FZF_NOTES_RG_COMMAND-}" ] && FZF_NOTES_RG_COMMAND="rg \
    --no-column \
    --line-number \
    --no-heading \
    --color=always \
    --colors='match:none' \
    --smart-case \
    -- '\S'"

# Ensure precmds are run after cd.
function fzf_notes_redraw_prompt {
    local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
    zle reset-prompt
}
zle -N fzf_notes_redraw_prompt

function fzf_notes_preview {
    states=("${(s[|])FZF_NOTES_PREVIEW_WINDOW}")
    [ "${#states[@]}" -eq 1 ] && echo "${FZF_NOTES_PREVIEW_WINDOW}" && return
    [ "${#states[@]}" -gt 2 ] && echo "${FZF_NOTES_PREVIEW_WINDOW}" && return
    [ $(tput cols) -lt "${FZF_NOTES_PREVIEW_THRESHOLD}" ] && echo "${states[2]}" && return
    echo "${states[1]}"
}

function fzf_notes {
    local copy_key=${FZF_NOTES_COPY_KEY:-alt-w}
    local new_note_key=${FZF_NOTES_NEW_NOTE_KEY:-ctrl-o}
    local lines=$(eval ${FZF_NOTES_RG_COMMAND} ${FZF_NOTES_DIR} | \
        ${FZF_PREVIEW_BIN} -ns ${FZF_NOTES_DIR} | fzf \
        --prompt "${FZF_NOTES_PROMPT}" \
        --print-query \
        --ansi \
        --delimiter=":" \
        --multi \
        --query="$*" \
        --expect="$new_note_key" \
        --bind "${copy_key}:execute-silent(echo -n {3..} | ${FZF_NOTES_COPY_COMMAND})" \
        --header="${copy_key}:copy, ${new_note_key}:new" \
        --preview="${FZF_PREVIEW_BIN} -np ${FZF_NOTES_DIR} {1} {2} ${FZF_PREVIEW_LINES}" \
        --preview-window=$(fzf_notes_preview) \
    )
    if [[ -z "$lines" ]]; then
        zle && zle fzf_notes_redraw_prompt
        return 1
    fi

    local key="$(head -n2 <<< "$lines" | tail -n1)"
    if [[ "$key" == "$new_note_key" ]]; then
        fzf_notes_new_entry "$(head -n1 <<< "${lines}")"
    else
        fzf_notes_jump "$(tail -n1 <<< "${lines}")"
    fi
    zle && zle fzf_notes_redraw_prompt || true
}

function fzf_notes_new_entry {
    mkdir -p $(dirname ${FZF_NOTES_DIR}/$1)
    $EDITOR ${FZF_NOTES_DIR}/$1
}

function fzf_notes_jump {
    file=$(cut -d':' -f1 <<< "$1")
    column=$(cut -d':' -f2 <<< "$1")
    # vim compatible editor.
    $EDITOR +$column ${FZF_NOTES_DIR}/$file
}

zle -N fzf_notes

bindkey ${FZF_NOTES_TRIGGER_KEYMAP:-'^s'} fzf_notes
