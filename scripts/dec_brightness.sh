#! /bin/bash

brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
brightness=$(( $brightness - 3200 ))
echo $brightness > /sys/class/backlight/intel_backlight/brightness

