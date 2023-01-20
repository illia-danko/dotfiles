#!/usr/bin/env bash

set -eou pipefail

pkg_uri="https://github.com/emacs-mirror/emacs.git"
git_branch="emacs-28.2"

url2dir() {
    echo "$1" | perl -pe 's/\.git$//;' -pe 's/^(https?:\/\/|git@)//;' -pe 's/:/\//g;'
}

pkg_path="$(url2dir "$pkg_uri")"
pkg_name="$(basename "$pkg_path")"
root_dir="$HOME/$(dirname "$pkg_path")"

mkdir -p "$root_dir"
pushd "$root_dir"
rm -rf "$pkg_name"
git clone --depth=1 --branch="$git_branch" "$pkg_uri" "$pkg_name"
pushd "$pkg_name"

sudo apt build-dep emacs libwebkit2gtk-4

sh autogen.sh
./configure --with-xwidgets --with-json --with-imagemagick --with-no-titlebar
make -j$(nproc)