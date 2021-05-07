#!/usr/bin/bash

# get PC hostname
hostname=$( cat /etc/hostname )

# define PC-specific configuration

# desktop
if [ "$hostname" == "archDesk" ]
then
    # do stuff
fi

# thinkpad-t450s laptop
if [ "$hostname" == "thinkpad-t450s" ]
then
    # do stuff
fi

# dell xps 13 laptop
if [ "$hostname" == "whatever" ]
then
    # do stuff
fi

