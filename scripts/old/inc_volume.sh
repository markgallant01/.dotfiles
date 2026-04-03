#!/bin/bash

# this command grabs the current volume from pactl. there is probably
# a cleaner way to do this without the head and second grep call but
# this works for now
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o "[0-9]*%" | head -n 1 | grep -o "[0-9]*")

# we don't want the volume to go over 100 so check if its <= 95 before
# deciding how to increase it
if [[ "$vol" -le 95 ]]; then
    pactl set-sink-volume @DEFAULT_SINK@ +5%
else
    pactl set-sink-volume @DEFAULT_SINK@ 100%
fi
