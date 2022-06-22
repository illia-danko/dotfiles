#!/usr/bin/env bash

# Copyright 2021 Elijah Danko

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

set -euo pipefail

script_name="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "$script_name")"
is_archlinux=""
[ -f "/etc/arch-release" ] && is_archlinux="enabled"

url2dir() {
    echo "$1" | perl -pe 's/\.git$//;' -pe 's/^(https?:\/\/|git@)//;' -pe 's/:/\//g;'
}

deb_packages() {
    for receipt in "$script_dir/debian/"*PKGCONFIG; do
        bash "$receipt"
    done
}

distro_packages() {
    # default debian|ubuntu.
    packages_file="$script_dir/deb-packages"
    install_cmd="sudo apt install -yy"

    if [ -n "$is_archlinux" ]; then
        packages_file="$script_dir/pacman-packages"
        install_cmd="sudo pacman -S --noconfirm"
    else
        deb_packages
    fi

    read -ra pkgs <<< "$(awk '{print $1}' "$packages_file" | \
        tr '\n' ' ')"
    eval "$(printf "%s %s" "$install_cmd" "${pkgs[*]}")"
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

# walk_packages clones and installs packages.
walk_packages() {
    install_cmd="$1"
    shift
    for pkg in "$@"; do
        install_pkg "$pkg" "$install_cmd"
    done
}

aur_packages() {
    [ -z "$is_archlinux" ] && return

    echo "Aur packages..."
    read -ra pkgs <<< "$(cat "$script_dir/aur-packages" | tr '\n' ' ')"
    walk_packages "makepkg -si --noconfirm" "${pkgs[@]}"
    echo "Done"
}

editor() {
    path="$HOME/.config/nvim"
    [ -d "$path" ] && return
    echo "Configuring editor..."
    rm -rf "$path"
    git clone "git@github.com:elijahdanko/dot-nvim.git" "$HOME/.config/nvim"
    echo "Done"
}

github_packages() {
    echo "Github packages..."

    while IFS= read -r line; do
        install_cmd="$(awk '{$1=""; print}' <<< "$line")"
        [ -z "$install_cmd" ] && install_cmd="make install || true"
        install_pkg "$(awk '{print $1}' <<< "$line")" "$install_cmd"
    done < "$script_dir/github-packages"

    echo "Done"
}

sub_packages() {
    echo "Sub packages..."
    sudo npm install -g typescript typescript-language-server eslint prettier neovim
    sudo -H python3 -m pip install --upgrade pip pyright virtualenv yapf flake8 pynvim
    go install golang.org/x/tools/gopls@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install github.com/gokcehan/lf@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
    sudo curl https://dl.min.io/client/mc/release/linux-amd64/mc --output /usr/local/bin/mcli && sudo chmod +x /usr/local/bin/mcli
    echo "Done"
}

packages() {
    distro_packages
    [ -n "$is_archlinux" ] && aur_packages
    github_packages
    sub_packages
}

copy_content() {
    path="$1"
    dest="$2"
    prefix="${3:-""}"

    printf "Configuring %s...\n" "$(basename "$path")"
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

os_fix_laptop_lid_suspend() {
    file=/etc/systemd/logind.conf
    [ ! -f "$file" ] && return
    sudo perl -pi -e 's/#(HandleLidSwitchExternalPower)=\w+/\1=ignore/;' "$file"
}

# Append to file if token wasn't found in the file.
append_to() {
    if [ -z "$(grep "$2" "$1")" ]; then
        echo "$2" | sudo tee -a "$1"
    fi
}

copy_root_files() {
    files="$(cd "$1" && find . -type f | perl -pe 's/^\.//;')"
    for file in "${files[@]}"; do
        echo "Coping $file..."
        sudo cp -R "$1/$file" "$file"
    done
}

os() {
    eval "$script_dir/bin/mod-switch win-alt"  # swap RAlt with RWin
    if [ -n "$is_archlinux" ]; then
        os_fix_laptop_lid_suspend
        # # Fix `libvirt` DNS (used by dnsmasq).
        # nameservers=("nameserver 1.1.1.1" "nameserver 8.8.8.8" "nameserver 8.8.4.4")
        # for ns in "${nameservers[@]}"; do
        #     append_to /etc/resolv.conf "$ns"
        # done
    fi
}

config_home() {
    copy_content "$script_dir"/home "$HOME" "."
    zsh_theme
}

config_common() {
    copy_content "$script_dir"/config "$HOME/.config"
}

config_ssh() {
    echo "Configuring ssh..."
    mkdir -p "$HOME/.ssh"
    cp "$script_dir/ssh/config" "$HOME/.ssh/config"
    echo "Done"
}

config() {
    # Make sure it's executed after packages().
    config_home
    config_common
    config_ssh
    os
    editor
}

# Steps are required after reboot.
post_config() {
    if [ -n "$is_archlinux" ]; then
        echo "Configure archlinux settings..."
        sudo usermod -a -G libvirt "$USER"
        sudo systemctl enable libvirtd.service
        sudo systemctl enable docker.service
        echo "Done"
    fi

    chsh -s "$(which zsh)"
    sudo chsh -s "$(which zsh)"
    sudo usermod -a -G docker "$USER"
    sudo usermod -a -G wireshark "$USER"
    sudo virsh net-autostart default  # libvirt connection
}


[ $# -lt 1 ] && >&2 echo "entry should be specified." && exit 1

case "$1" in
    distro-packages) distro_packages;;
    aur-packages) aur_packages;;
    github-packages) github_packages;;
    sub-packages) sub_packages;;
    packages) packages;;
    zsh-theme) zsh_theme;;
    editor) editor;;
    os) os;;
    config-home) config_home;;
    config-common) config_common;;
    config-ssh) config_ssh;;
    config) config;;
    post-config) post_config;;
    *) >&2 echo "'$1' entry is not defined." && exit 1;;
esac
