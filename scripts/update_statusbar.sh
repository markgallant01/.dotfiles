#!/bin/sh

# script to update dwm's statusbar

# various system information is pulled and stored in the following
# variables. Those variables are then used to build the statusbar
# in the xsetroot call.

# volume level
vol=$( pactl get-sink-volume @DEFAULT_SINK@ | grep --only-matching -P '\d*%' | head -1 )

# date
date=$( date +"%m-%d-%Y" )

# time
time=$( date +"%I:%M%p" )

# check for batteries
bat0=$( cat /sys/class/power_supply/BAT0/capacity )
bat1=$( cat /sys/class/power_supply/BAT1/capacity )

bat0=/sys/class/power_supply/BAT0
bat1=/sys/class/power_supply/BAT1

if [ -d "$bat0" ]; then
    # directory exists
else
    # directory doesn't exist
fi

# cpu utilization
cpu_util=$(top -bn1 | grep "Cpu(s)" | \
    sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
    awk '{print 100 - $1}')

# memory utilization
mem_util=$(free | head -n 2 | tail -n 1 | \
    awk '{printf("%.1f", ($3/$2)*100)}')

xsetroot -name "[CPU:$cpu_util%] [MEM:$mem_util%] [VOL:$vol] [BAT:$bat0%] [$time]"

