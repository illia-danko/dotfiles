#!/bin/sh

lxsession &
picom &
dunst &
volumeicon &
nm-applet &
dbus-update-activation-environment DISPLAY && blueman-applet &
nitrogen --restore &
copyq &
xrandr --output eDP-1 --off
