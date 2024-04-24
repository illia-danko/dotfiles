#!/usr/bin/env bash

random_file_from_dir() {
    find "$1" -type f -iname "*.jpg" -o -iname "*.png" | shuf -n 1
}

nitrogen --set-scaled "$(random_file_from_dir "$1")" &> /dev/null
