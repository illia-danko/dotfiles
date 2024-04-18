#!/usr/bin/env bash

set -euo pipefail

random_file_from_dir() {
    find "$1" -type f | shuf -n 1
}

nitrogen --set-scaled "$(random_file_from_dir "$1")"
