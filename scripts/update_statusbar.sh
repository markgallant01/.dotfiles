#!/bin/sh

# script to update dwm's statusbar

# various system information is pulled and stored in the following
# variables. Those variables are added to the root_str string which
# gets handed to xsetroot to set the statusbar.

root_str=""

# cpu utilization
cpu_util=$(top -bn1 | grep "Cpu(s)" | \
    sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
    awk '{printf("% 4.1f", (100 - $1))}')

root_str+="[CPU:$cpu_util%] "

# memory utilization
mem_util=$(free | head -n 2 | tail -n 1 | \
    awk '{printf("%.1f", ($3/$2)*100)}')

root_str+="[MEM:$mem_util%] "

# volume level
vol=$( pactl get-sink-volume @DEFAULT_SINK@ | \
    grep --only-matching -P '\d*%' | head -1 )

root_str+="[VOL:$vol%] "

# date
date=$( date +"%m-%d-%Y" )

# check for batteries

bat0=/sys/class/power_supply/BAT0
if [ -d "$bat0" ]; then
    # directory exists
    bat0_pow=$( cat /sys/class/power_supply/BAT0/capacity )
    root_str+="[BAT0:$bat0_pow%] "
fi

bat1=/sys/class/power_supply/BAT1
if [ -d "$bat1" ]; then
    # directory exists
    bat1_pow=$( cat /sys/class/power_supply/BAT1/capacity )
    root_str+="[BAT1:$bat1_pow%] "
fi

# time
time=$( date +"%I:%M%p" )

root_str+="[$time]"

xsetroot -name "$root_str"

