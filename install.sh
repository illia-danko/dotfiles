#!/usr/bin/env bash

# Copyright 2021 Illia Danko

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# This script prepare environment being ready for use.

set -eo pipefail

[ $# -lt 1 ] && >&2 echo "Target should be specified." && exit 1

script_name="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "$script_name")"

url2dir() {
    echo "$1" | perl -p -e 's/\.git$//;' -p -e 's/^(https?:\/\/|git@)//;' -p -e 's/:/\//g;'
}

install_pkg() {
     pkg_path="$(url2dir "$1")"
     pkg_name="$(basename "$pkg_path")"
     root_dir="$HOME/$(dirname "$pkg_path")"
     mkdir -p "$root_dir"
     pushd "$root_dir"
     rm -rf "$pkg_name"
     git clone "$1" "$pkg_name"
     pushd "$pkg_name"
     shift
     eval "$*"
     popd
     popd
}

github_repos() {
    echo "Github packages..."

    while IFS= read -r line; do
        install_cmd="$(awk '{$1=""; print}' <<< "$line")"
        [ -z "$install_cmd" ] && install_cmd="make install || true"
        install_pkg "$(awk '{print $1}' <<< "$line")" "$install_cmd"
    done < "$script_dir/github-repos"

    echo "Done"
}

packages() {
    local packages_script="$script_dir"/debian-packages.sh
    if [ "$(uname)" = "Darwin" ]; then
        packages_script="$script_dir"/macos-packages.sh
	fi
    sh -c "$packages_script"
}

copy_content() {
    path="$1"
    dest="$2"
    prefix="${3:-""}"

    printf "Configuring %s...\n" "$(basename "$path")"
    mkdir -p "$dest"
    pushd "$dest" 1>/dev/null

    for entity in "$path/"*; do
        entity_name=$(basename "$entity")
        echo "Configuring $entity_name..."
        copy_to="$dest/$prefix$entity_name"
        # Copy only content if it's a dir.
        if [ -d "$entity" ]; then
            mkdir -p "$copy_to"
            cp -R "$entity"/* "$copy_to"
        else
            cp -R "$entity" "$copy_to"
        fi
    done

    popd 1>/dev/null
    echo "Done"
}

zsh_theme() {
    echo "Configuring zsh theme..."
    cp -R "$script_dir"/zsh-themes/sly-face.zsh-theme "$HOME/.zsh-theme"
    echo "Configuring done..."
}

config_home() {
    copy_content "$script_dir"/home "$HOME" "."
    . "$HOME"/.config-common.sh # hack to make `envsusbs` work in a single pass
    zsh_theme
}

config_root() {
    copy_root_files "$script_dir/root"
}

config_common() {
    copy_content "$script_dir"/config "$HOME/.config"
}

copy_root_files() {
    files="$(cd "$1" && find . -type f | perl -pe 's/^\.//;')"
    for file in "${files[@]}"; do
        echo "Coping $file..."
        sudo cp -R "$1/$file" "$file"
    done
}

# sub_env substitutes environment variables with values.
sub_env() {
    local perms="$(getfacl "$1" 2>/dev/null)" # save acl
    # See config-common.sh.
    (rm -rf "$1" && envsubst\
        '${TTY_COLOR_BG0}\
        ${TTY_COLOR_BG1}\
        ${TTY_COLOR_FG0}\
        ${TTY_COLOR_FG1}\
        ${TTY_COLOR_BLACK}\
        ${TTY_COLOR_RED}\
        ${TTY_COLOR_GREEN}\
        ${TTY_COLOR_YELLOW}\
        ${TTY_COLOR_BLUE}\
        ${TTY_COLOR_MAGENTA}\
        ${TTY_COLOR_CYAN}\
        ${TTY_COLOR_WHITE}\
        ${TTY_COLOR_BRIGHT_BLACK}\
        ${TTY_COLOR_BRIGHT_RED}\
        ${TTY_COLOR_BRIGHT_GREEN}\
        ${TTY_COLOR_BRIGHT_YELLOW}\
        ${TTY_COLOR_BRIGHT_BLUE}\
        ${TTY_COLOR_BRIGHT_MAGENTA}\
        ${TTY_COLOR_BRIGHT_CYAN}\
        ${TTY_COLOR_BRIGHT_WHITE}' > "$1" ) < "$1"
    setfacl --set-file=- <<< "$perms" "$1" # restore acl
}

sub_env_dir() {
    for file in $(find $1 -type f); do
        sub_env "$file"
    done
}

config() {
    config_home
    config_common
    [ "$(uname)" = "Darwin" ] && return

    config_root

    # Rewrite env tokens using envsubst command.
    ([ -x "$(command -v alacritty)" ] && sub_env_dir "$HOME/.config/alacritty") || true
}

iterm2_action() {
    name="com.googlecode.iterm2.plist"
    path="$script_dir"/assets/iterm2/"$name"
    defaults "$1" "$name" "$path"
}

dump_iterm2() {
    iterm2_action export
}

config_iterm2() {
    iterm2_action import
}


case "$1" in
    github-repos) github_repos;;
    sub-packages) sub_packages;;
    packages) packages;;
    zsh-theme) zsh_theme;;
    config-home) config_home;;
    config-common) config_common;;
    config-root) config_root;;
    config) config;;
    dump-iterm2) dump_iterm2;;
    config-iterm2) config_iterm2;;
    *) >&2 echo "'$1' target is not defined." && exit 1;;
esac
