#!/bin/bash
# this script chooses an appropriate wallpaper based on a number of
# different conditions. If it's a holiday period, it will choose an
# appropriate wallpaper corresponding to that holiday disregarding
# the time of day. For non-holiday periods it will consider the current
# season and time of day.

# seasons are determined based on the meteorological periods, not the
# astronomical ones, as follows:
# Spring: March 1 - May 31
# Summer: June 1 - August 31
# Fall:   September 1 - November 30
# Winter: December 1 - February 28

# seasons as their day of the year:
# Spring: 060-151
# Summer: 152-243
# Fall:   244-334
# Winter: 335-059

# Holidays we care about as their day of the year:
# This is for NON LEAP YEARS:
# New Years eve + day:  001 + 365
# Independence Day:     185
# Thanksgiving:         332
# Halloween week:       298-304
# Christmas 2 weeks:    354-364

# pull some useful info. Current hour and day of the year.
hour=$(date +%H)
day_of_year=$(date +%j)

# strip leading zeros
hour=$(( 10#$hour ))
day_of_year=$(( 10#$day_of_year ))

# wallpaper path
image="$HOME/Pictures/Wallpaper/PC/"

# check for holidays

if [[ $day_of_year == 1 ]] || [[ $day_of_year == 365 ]]; then
    # new years eve / day
    image+="Seasonal/Holiday/NewYears/"

elif [[ $day_of_year == 185 ]]; then
    # Independence Day
    image+="Seasonal/Holiday/IndependenceDay/"

elif [[ $day_of_year == 332 ]]; then
    # Thanksgiving
    image+="Seasonal/Holiday/Thanksgiving/"

elif [[ $day_of_year -ge 298 ]] && [[ $day_of_year -le 304 ]]; then
    # Halloween week
    image+="Seasonal/Holiday/Halloween/"

elif [[ $day_of_year -ge 354 ]] && [[ $day_of_year -le 364 ]]; then
    # Christmas 2 weeks
    image+="Seasonal/Holiday/Christmas/"

# holidays done, start checking seasons
elif [[ $day_of_year -ge 60 ]] && [[ $day_of_year -le 151 ]]; then
    # Spring
    if [[ $hour -gt 3 ]] && [[ $hour -lt 17 ]]; then
        # between 4am and 4:59pm (04:00 - 16:59)
        image+="Seasonal/Spring/Day/"
    else
        image+="Seasonal/Spring/Night/"
    fi

elif [[ $day_of_year -ge 152 ]] && [[ $day_of_year -le 243 ]]; then
    # Summer
    if [[ $hour -gt 4 ]] && [[ $hour -lt 19 ]]; then
        # between 5am and 6:59pm (04:00 - 16:59)
        image+="Seasonal/Summer/Day/"
    else
        image+="Seasonal/Summer/Night/"
    fi

elif [[ $day_of_year -ge 244 ]] && [[ $day_of_year -le 334 ]]; then
    # Fall
    if [[ $hour -gt 3 ]] && [[ $hour -lt 17 ]]; then
        # between 4am and 4:59pm (04:00 - 16:59)
        image+="Seasonal/Fall/Day/"
    else
        image+="Seasonal/Fall/Night/"
    fi

elif [[ $day_of_year -ge 335 ]] || [[ $day_of_year -le 59 ]]; then
    # Winter
    if [[ $hour -gt 3 ]] && [[ $hour -lt 17 ]]; then
        # between 4am and 4:59pm (04:00 - 16:59)
        image+="Seasonal/Winter/Day"
    else
        image+="Seasonal/Winter/Night"
    fi
fi

# return selected image based on prior conditions
image=$(find $image -mindepth 1 | shuf -n 1)
echo $image
