#!/bin/bash

hostname=$(cat /etc/hostname)
brightness=$(cat /sys/class/backlight/intel_backlight/brightness)

if [[ "$hostname" == "archThinkpad" ]]; then
    brightness=$(( $brightness - 71 ))
else
    brightness=$(( $brightness - 3200 ))
fi

echo $brightness > /sys/class/backlight/intel_backlight/brightness

