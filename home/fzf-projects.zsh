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

# Search for local git projects using fdfind and fzf commands.

[ -z "${FZF_PROJECTS_ROOT_DIR-}" ] && FZF_PROJECTS_ROOT_DIR="$HOME"
[ -z "${FZF_PROJECTS_FD_COMMAND-}" ] && FZF_PROJECTS_FD_COMMAND="fdfind --hidden --case-sensitive --absolute-path --exec echo '{//}' ';' '^\.git$' ${FZF_PROJECTS_ROOT_DIR}"
[ -z "${FZF_PROJECTS_FZF_COMMAND-}" ] && FZF_PROJECTS_FZF_COMMAND="fzf"
[ -z "${FZF_PROJECTS_NO_COLORS-}" ] && FZF_PROJECTS_NO_COLORS="0"
[ -z "${FZF_PROJECTS_MATCH_COLOR-}" ] && FZF_PROJECTS_MATCH_COLOR="33"  # yellow

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
    [ "${FZF_PROJECTS_NO_COLORS-}" -eq "1" ] && cat && return
    local esc="$(printf '\033')"
    sed "s/\(.*\)/${esc}[${FZF_PROJECTS_MATCH_COLOR}m\1${esc}[0;0m/"
}

function fzf_projects {
    local line=$(eval ${FZF_PROJECTS_FD_COMMAND} | _fzf_projects_color | eval ${FZF_PROJECTS_FZF_COMMAND} \
        --ansi)
    if [[ -z "$line" ]]; then
        zle && zle fzf_projects_redraw_prompt
        return 1
    fi

    if [ "$#" -gt 0 ]; then
        case $1 in
            '--print') printf "%s\n" "$line";;
        esac
    else
        cd "$line"
    fi
    zle && zle fzf_projects_redraw_prompt || true
}

zle -N fzf_projects

bindkey ${FZF_PROJECTS_TRIGGER_KEYMAP:-'^g'} fzf_projects
