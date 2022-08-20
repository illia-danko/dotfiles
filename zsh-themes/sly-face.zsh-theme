# Init version control info.
autoload -Uz vcs_info
# Format the vcs_info_msg_0_ variable.
zstyle ':vcs_info:git:*' formats '%b'
setopt PROMPT_SUBST # use functions, subst, etc


# %b - to reset bold (opposite to %B).
# %F{default} - to use default (white) font.
local reset_color="%b%F{default}"
local sly_face="%(?.😃.😡)"


if [[ $UID -eq 0 ]]; then
    local user_host="%B%F{magenta}%n@%m${reset_color}"
else
    local user_host="%B%F{blue}%n@%m${reset_color}"
fi

local user_symbol='»'

local current_dir="%B%F{yellow}%~${reset_color}"

refresh_prompt() {
    vcs_info

    local maybe_vc_info=""

    if [[ -n ${vcs_info_msg_0_} ]]; then
        local is_dirty="$(command git status --porcelain 2> /dev/null | tail -n1)"
        if [[ -n $is_dirty ]]; then
            local maybe_vc_info="-(%F{red}${vcs_info_msg_0_}${reset_color})"
        else
            local maybe_vc_info="-(${vcs_info_msg_0_})"
        fi
    fi

    local maybe_py_venv=""
    [ ! -z $VIRTUAL_ENV ] && local maybe_py_venv="$(basename $VIRTUAL_ENV)"
    [ ! -z $maybe_py_venv ] && \
        local maybe_py_venv="-(%B%F{magenta}${maybe_py_venv}${reset_color})"

PROMPT="╭─(${sly_face})-(${user_host})-(${current_dir})${maybe_vc_info}${maybe_py_venv}
╰─%B${user_symbol}%b "
}

precmd() {
    echo
    refresh_prompt
}

# Fix issue when fzf doesn't change cmd but pwd only.
add-zsh-hook chpwd refresh_prompt
