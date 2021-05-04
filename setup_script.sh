#!/usr/bin/bash

# This script will install all the packages 
# listed in the 'packages' array and will
# attempt to set everything up automatically.
#
# Steps to take before running this script:
#   1. Complete base install
#   2. Configure network
#   3. Create sudo-capable non-root user and log in
#   4. Enable multilib repository
#   5. Setup and connect git to github
#
# This script must be run with sudo.
#
# The package installs are grouped into different
# batches to make it easier to see what's being
# installed and to add or remove things

# to do:
# firewall
# automate removal of mouse acceleration?
# monitor resolution somehow
# terminal prompt customization

packages=( )

# x.org programs
packages+=(xorg-server xorg-xbacklight xorg-xrandr xorg-xrdb xorg-xinit)

# window manager
packages+=(i3-gaps i3blocks i3lock i3status picom)

# audio stuff
packages+=(pipewire pipewire-alsa pipewire-pulse)

# fonts
packages+=(ttf-dejavu ttf-liberation)

#terminal and terminal apps
packages+=(rxvt-unicode xclip cmus openssh neofetch)

# applications
packages+=(ranger rofi firefox chromium discord)

# gaming stuff
packages+=(steam lutris)

# install everything so far
pacman -Syu ${packages[@]}

# graphics drivers
gpuDrivers=( )

# detect GPU
gpuString=$( lspci -v | grep -A1 -e VGA -e 3D | tr '[:upper:]' '[:lower:]' )

# add appropriate driver packages
if [[ ${gpuString} == *"nvidia"* ]]
then
    gpuDrivers+=(nvidia nvidia-utils lib32-nvidia-utils)
fi

if [[ ${gpuString} == *"intel"* ]]
then
    gpuDrivers+=(mesa lib32-mesa vulkan-intel)
fi

# install GPU driver packages
pacman -Syu ${gpuDrivers[@]}

# github stuff here?

