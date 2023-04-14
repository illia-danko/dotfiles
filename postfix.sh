#!/usr/bin/env bash

set -eo pipefail

script_name="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "$script_name")"

tic -x -o ~/.terminfo "$script_dir"/assets/emacs/terminfo-custom.src

if [ "$(uname)" != "Darwin" ]; then
    sudo virsh net-autostart default  # libvirt connection
fi
