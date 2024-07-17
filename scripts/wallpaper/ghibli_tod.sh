#!/bin/bash

# grab the current hour
hour=$(date +%H)

# trim leading zero
hour=$(( 10#$hour ))

# if between 4am and 4:59pm (04:00 - 16:59)
if [[ $hour -gt 3 ]] && [[ $hour -lt 17 ]]; then
    # grab a random day time studio ghibli image
    image=$(find $HOME/Pictures/Wallpaper/new_ghibli_testing/Day/ \
        -mindepth 1 | shuf -n 1)
fi

# if between 5pm and 3:59am (17:00 - 03:59)
if [[ $hour -gt 16 ]] || [[ $hour -lt 4 ]]; then
    # grab a random night time studio ghibli image
    image=$(find $HOME/Pictures/Wallpaper/new_ghibli_testing/Night/ \
        -mindepth 1 | shuf -n 1)
fi

echo $image

