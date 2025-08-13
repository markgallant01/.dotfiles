#!/bin/sh

# script to update dwm's statusbar

# various system information is pulled and stored in the following
# variables. Those variables are added to the root_str string which
# gets handed to xsetroot to set the statusbar.

root_str=""

# cpu utilization
cpu_util=$(top -bn1 | grep "Cpu(s)" | \
    sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
    awk '{printf("%4.1f", (100 - $1))}')

#root_str+="[CPU:$cpu_util%] "

# memory utilization
mem_util=$(free | head -n 2 | tail -n 1 | \
    awk '{printf("%4.1f", ($3/$2)*100)}')

#root_str+="[MEM:$mem_util%] "

# volume level
vol=$( pactl get-sink-volume @DEFAULT_SINK@ | \
    grep --only-matching -P '\d*%' | head -1 | \
    awk '{printf("%2d", $1)}')

# volume status icon
if [[ "$vol" -le 33 ]]; then
    root_str+="󰕿 "
elif [[ "$vol" -gt 33 ]] && [[ "$vol" -le 66 ]]; then
    root_str+="󰖀 "
else
    root_str+="󰕾 "
fi

# date
date=$( date +"%m-%d-%Y" )

# check for batteries

bat0=/sys/class/power_supply/BAT0
bat1=/sys/class/power_supply/BAT1
total_pow=0

# if two batteries exist, take their combined value
if [[ -d "$bat0" ]] && [[ -d "$bat1" ]]; then
    # both directories exist, combine values
    bat0_pow=$( cat /sys/class/power_supply/BAT0/capacity | \
        awk '{printf("%2d", $1)}')

    bat1_pow=$( cat /sys/class/power_supply/BAT1/capacity | \
        awk '{printf("%2d", $1)}')

    total_pow=$(( (bat0_pow + bat1_pow) / 2 ))
else
    # take whichever battery exists, not sure if 0 or 1 on a single
    # battery system
    if [ -d "$bat0" ]; then
        # directory exists
        bat0_pow=$( cat /sys/class/power_supply/BAT0/capacity | \
            awk '{printf("%2d", $1)}')

        total_pow=$bat0_pow
    fi

    if [ -d "$bat1" ]; then
        # directory exists
        root_str+="[BAT:$bat1_pow%] "

        bat1_pow=$( cat /sys/class/power_supply/BAT1/capacity | \
            awk '{printf("%2d", $1)}')

        total_pow=$bat1_pow
    fi
fi

# battery status icon
if [[ "$total_pow" -le 10 ]]; then
    bat_stat="󰁺 "
elif [[ "$total_pow" -le 20 ]]; then
    bat_stat="󰁻 "
elif [[ "$total_pow" -le 30 ]]; then
    bat_stat="󰁼 "
elif [[ "$total_pow" -le 40 ]]; then
    bat_stat="󰁽 "
elif [[ "$total_pow" -le 50 ]]; then
    bat_stat="󰁾 "
elif [[ "$total_pow" -le 60 ]]; then
    bat_stat="󰁿 "
elif [[ "$total_pow" -le 70 ]]; then
    bat_stat="󰂀 "
elif [[ "$total_pow" -le 80 ]]; then
    bat_stat="󰂁 "
elif [[ "$total_pow" -le 90 ]]; then
    bat_stat="󰂂 "
else
    bat_stat="󰁹 "
fi

# check if any batteries are charging currently
if [[ -d "$bat0" ]]; then
    if [[ $( cat "$bat0"/status ) -eq "Charging" ]]; then
        bat_stat="󰂄"
    fi
fi

if [[ -d "$bat1" ]]; then
    if [[ $( cat "$bat1"/status ) -eq "Charging" ]]; then
        bat_stat="󰂄"
    fi
fi

root_str+="$bat_stat"

# time
time=$( date +"%I:%M%P" )

root_str+="$time"

# fancy distro icon
root_str+=" "

xsetroot -name "$root_str"

