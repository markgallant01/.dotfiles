#!/bin/sh

# script to update dwm's statusbar

# get volume level
vol=$( pactl get-sink-volume @DEFAULT_SINK@ | grep --only-matching -P '\d*%' | head -1 )

xsetroot -name "vol: $vol $( date +" %m-%d-%Y %l:%M %p " )"

