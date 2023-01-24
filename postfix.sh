#!/usr/bin/env bash

set -eo pipefail

if [ "$(uname)" == "Darwin" ]; then
    :
else
    sudo virsh net-autostart default  # libvirt connection
fi
