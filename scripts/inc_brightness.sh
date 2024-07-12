#! /bin/bash

brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
brightness=$(( $brightness + 6400 ))
echo $brightness > /sys/class/backlight/intel_backlight/brightness

