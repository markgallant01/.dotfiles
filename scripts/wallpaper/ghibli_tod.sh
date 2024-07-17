#!/bin/bash

# grab the current hour
hour=$(date +%H)

# note: the hours will come back as '05' for 5am, with a leading zero
# for any hour before 10am and after 12:59am. The leading zero makes
# bash interpret it as an octal number. Prefixing with '10#' tells bash
# to interpret the numbers as base 10.

# if between 4am and 4:59pm (04:00 - 16:59)
if [[ $((10#"$hour")) -gt 3 ]] && [[ $((10#"$hour")) -lt 17 ]]; then
    # grab a random day time studio ghibli image
    image=$(find $HOME/Pictures/Wallpaper/new_ghibli_testing/Day/ \
        -mindepth 1 | shuf -n 1)
fi

# if between 5pm and 3:59am (17:00 - 03:59)
if [[ $((10#"$hour")) -gt 16 ]] || [[ $(("$hour")) -lt 4 ]]; then
    # grab a random night time studio ghibli image
    image=$(find $HOME/Pictures/Wallpaper/new_ghibli_testing/Night/ \
        -mindepth 1 | shuf -n 1)
fi

echo $image

