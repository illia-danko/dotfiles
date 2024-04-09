#!/usr/bin/env bash

set -eo pipefail

if [ "$(uname)" != "Darwin" ]; then
    sudo virsh net-autostart default  # libvirt connection
fi
