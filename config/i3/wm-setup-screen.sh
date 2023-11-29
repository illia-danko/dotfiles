#!/bin/sh

# Disable Embedded DisplayPort (eDP) if any, when connected to HDMI.
# (https://www.intel.com.br/content/dam/www/public/us/en/documents/white-papers/validation-methodology-paper.pdf)

turn_off_laptop_screen() {
    for edp in eDP-1 eDP-2; do
        xrandr --output "$edp" --off
    done
}

turn_off_laptop_screen_on_external_screen() {
    for screen in DP HDMI; do
        xrandr | grep -qE "^$screen.* connected" && turn_off_laptop_screen && exit 0
    done
}

turn_off_laptop_screen_on_external_screen
