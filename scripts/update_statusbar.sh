#!/bin/sh

# script to update dwm's statusbar
# applies different statusbar configs
# to different PCs based on hostname

# get pc hostname
hostname=$( cat /etc/hostname )

# pull some useful info for statusbar
# volume level
vol=$( pactl get-sink-volume @DEFAULT_SINK@ | grep --only-matching -P '\d*%' | head -1 )

# brightness level
bright=$( xbacklight | xargs printf "%.f" )

# date
date=$( date +"%m-%d-%Y" )

# time
time=$( date +"%l:%M%p" )

# battery info
bat0=$( cat /sys/class/power_supply/BAT0/capacity )
bat1=$( cat /sys/class/power_supply/BAT1/capacity )

xsetroot -name "vol:$vol $(date +"%m-%d-%Y %l:%M%p" )"

# archt450s statusbar
if [ "$hostname" == "archt450s" ]
then
  xsetroot -name "vol:$vol bri:$bright% bat:$bat0/$bat1$time "
fi

# desktop statusbar
if [ "$hostname" == "archDesk" ]
then
  xsetroot -name "vol:$vol $time"
fi

