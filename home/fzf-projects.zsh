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

# Search for local git projects using fd(find) and fzf commands.

[ -x "$(command -v fd)" ] && cmd="fd" || cmd="fdfind"
[ -z "${FZF_PROJECTS_ROOT_DIR-}" ] && FZF_PROJECTS_ROOT_DIR="$HOME"
[ -z "${FZF_PROJECTS_FD_PATTERN-}" ] && FZF_PROJECTS_FD_PATTERN="'^\.git$|^\.hg$|^\.bzr$|^\.svn$|^_darcs$|^Makefile$|^go.mod$|^package.json$'"
[ -z "${FZF_PROJECTS_FD_CMD-}" ] && FZF_PROJECTS_FD_CMD="$cmd --hidden --case-sensitive --base-directory ${FZF_PROJECTS_ROOT_DIR} --relative-path --exec echo '{//}' ';' ${FZF_PROJECTS_FD_PATTERN}"
[ -z "${FZF_PROJECTS_COLORS-}" ] && FZF_PROJECTS_COLORS="0"
[ -z "${FZF_PROJECTS_MATCH_COLOR_FG-}" ] && FZF_PROJECTS_MATCH_COLOR_FG="34"
[ -z "${FZF_PROJECTS_PREVIEW_CONFIG-}" ] && FZF_PROJECTS_PREVIEW_CONFIG="nohidden|hidden,down"
[ -z "${FZF_PROJECTS_PREVIEW_THRESHOLD-}" ] && FZF_PROJECTS_PREVIEW_THRESHOLD="160"
[ -z "${FZF_PROJECTS_PROMPT-}" ] && FZF_PROJECTS_PROMPT='Projects> '

# Ensure precmds are run after cd.
function fzf_projects_redraw_prompt {
    local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
    zle reset-prompt
}
zle -N fzf_projects_redraw_prompt

function _fzf_projects_color {
    [ "${FZF_PROJECTS_COLORS-}" -eq "0" ] && cat && return
    local esc="$(printf '\033')"
    perl -p -e "s/(.*)/${esc}[${FZF_PROJECTS_MATCH_COLOR_FG}m\1${esc}[0;0m/;"
}

function _fzf_projects_preview_window {
    states=("${(s[|])FZF_PROJECTS_PREVIEW_CONFIG}")
    [ "${#states[@]}" -eq 1 ] && echo "${FZF_PROJECTS_PREVIEW_CONFIG}" && return
    [ "${#states[@]}" -gt 2 ] && echo "${FZF_PROJECTS_PREVIEW_CONFIG}" && return
    [ $(tput cols) -lt "${FZF_PROJECTS_PREVIEW_THRESHOLD}" ] && echo "${states[2]}" && return
    echo "${states[1]}"
}

function fzf-projects {
    local line=$(eval ${FZF_PROJECTS_FD_CMD} | \
        cut -c 3- | \
        # Unique stream.
        awk '!x[$0]++' | \
        _fzf_projects_color | \
        fzf \
        --ansi \
        --prompt "${FZF_PROJECTS_PROMPT}" \
        --preview="tree -C -L 1 $FZF_PROJECTS_ROOT_DIR/{}" \
        --preview-window=$(_fzf_projects_preview_window))

    if [ "$line" != "" ] && [ -d "$FZF_PROJECTS_ROOT_DIR/$line" ]; then
        if [ "$#" -gt 0 ]; then
            case $1 in
                '--print') printf "%s\n" "$line";;
            esac
        else
            cd "$FZF_PROJECTS_ROOT_DIR/$line"
        fi
    fi

    zle && zle fzf_projects_redraw_prompt || true
}

zle -N fzf-projects

bindkey ${FZF_PROJECTS_TRIGGER_KEYMAP:-'^g'} fzf-projects
