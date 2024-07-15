#!/bin/sh

# script to update dwm's statusbar
# applies different statusbar configs
# to different PCs based on hostname

# get pc hostname
hostname=$( cat /etc/hostname )

# pull some useful info for statusbar
# volume level
vol=$( pactl get-sink-volume @DEFAULT_SINK@ | grep --only-matching -P '\d*%' | head -1 )

# date
date=$( date +"%m-%d-%Y" )

# time
time=$( date +"%I:%M%p" )

# battery info
bat0=$( cat /sys/class/power_supply/BAT0/capacity )
bat1=$( cat /sys/class/power_supply/BAT1/capacity )

xsetroot -name "[CPU:X%] [MEM:X%] [VOL:$vol] [BAT:$bat0%] [$time]"

