#!/usr/bin/bash

# This script will install all the programs
# listed in the 'programs' array and will
# attempt to set everything up automatically.
# 
# It should be run after the base installation
# is complete, the network has been configured,
# and a sudo-capable non-root user has been 
# setup and logged onto.
#
# This script must be run with sudo.

# The progam installs are grouped into different
# batches to make it easier to see what's being
# installed and to add or remove things


# basic programs for display and sound
basicPrograms=(xorg )

# graphics drivers
# if intel = mesa, lib32-mesa
# if nvidia nvidia, nvidia-utils, lib32-nvidia-utils

# other stuff
otherPrograms=(ranger)

pacman -Syu ${basicPrograms[@]} ${otherPrograms[@]}

