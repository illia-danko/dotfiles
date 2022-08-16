#!/bin/sh

picom &
dunst &
volumeicon &
nm-applet &
dbus-update-activation-environment DISPLAY && blueman-applet &
nitrogen --restore &
