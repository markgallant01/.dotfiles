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

packages=( )

# x.org programs
packages+=(xorg-server xorg-xrandr xorg-xrdb xorg-xinit)

# window manager
packages+=(i3-gaps i3blocks i3lock i3status picom)

# audio stuff
packages+=(pipewire pipewire-alsa pipewire-pulse)

# fonts
packages+=(ttf-dejavu ttf-liberation)

#terminal and terminal apps
packages+=(rxvt-unicode xclip cmus openssh neofetch git htop light)

# applications
packages+=(ranger rofi firefox chromium discord network-manager-applet)

# gaming stuff
packages+=(steam lutris)

# graphics drivers

# detect GPU
gpuString=$( lspci -v | grep -A1 -e VGA -e 3D | tr '[:upper:]' '[:lower:]' )

# add appropriate driver packages
if [[ ${gpuString} == *"nvidia"* ]]
then
    packages+=(nvidia nvidia-utils lib32-nvidia-utils vulkan-icd-loader
    lib32-vulkan-icd-loader)
fi

if [[ ${gpuString} == *"intel"* ]]
then
    packages+=(mesa lib32-mesa vulkan-intel lib32-vulkan-intel
    vulkan-icd-loader lib32-vulkan-icd-loader)
fi

# wine and wine dependencies
packages+=(wine-staging giflib lib32-giflib libpng lib32-libpng libldap
lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal
v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error
lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib
libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite
lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama
ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt
lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs
lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
wine-gecko wine-mono)

# install all packages
pacman -Syu ${packages[@]}

