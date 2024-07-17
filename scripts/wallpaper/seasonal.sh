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

# note: the hours will come back as '05' for 5am, with a leading zero
# for any hour before 10am and after 12:59am. The leading zero makes
# bash interpret it as an octal number. Prefixing with '10#' tells bash
# to interpret the numbers as base 10.

# check for holidays?

# check for season

# check for time of day

echo $image
