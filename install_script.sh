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
# figure out brightness control program and add it somewhere

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
packages+=(rxvt-unicode xclip cmus openssh neofetch git)

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
    gpuDrivers+=(nvidia nvidia-utils lib32-nvidia-utils vulkan-icd-loader
    lib32-vulkan-icd-loader)
fi

if [[ ${gpuString} == *"intel"* ]]
then
    gpuDrivers+=(mesa lib32-mesa vulkan-intel lib32-vulkan-intel
    vulkan-icd-loader lib32-vulkan-icd-loader)
fi

# install GPU driver packages
pacman -Syu ${gpuDrivers[@]}

# configure git
git config --global user.name "Mark Gallant"
git config --global user.email "markgallant01@gmail.com"

# generate a new ssh key
ssh-keygen -t ed25519 =C "markgallant01@gmail.com"

# start ssh agent and add new key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

