#!/bin/bash

# this script builds an array of packages section-by-section
# and then calls pacman to install them all together at the end.

# after that it does some prelimenary setup

# array to store package list
declare -a packages=()

# git stuff
packages+=("git" "openssh")

# display server and some x-tools
packages+=("xorg-server" "xorg-xsetroot" "xorg-xbacklight")
packages+=("xorg-xinit" "xorg-xrandr")

# window manager dependencies
packages+=("libxft" "libxinerama" "ttf-dejavu-nerd")

# development tools for building from source
packages+=("base-devel" "clang" "gdb")

# image viewing and processing tools
packages+=("feh")

# misc utilities
packages+=("network-manager-applet" "udisks2" "fastfetch" "zip" "unzip")
packages+=("scrot" "cmus" "celluloid" "neovim" "dmenu" "xdg-user-dirs")
packages+=("xclip" "npm" "wget" "curl")

# file browser
packages+=("thunar")

# sound system
packages+=("pipewire" "lib32-pipewire" "wireplumber" "pipewire-audio" "pipewire-pulse")
packages+=("blueman" "sof-firmware")

# hardware monitoring
packages+=("htop")

# music downloader
packages+=("yt-dlp")

# ebooks
packages+=("calibre")

# web browsers
packages+=("firefox")

# communication
packages+=("discord")

# game launchers
packages+=("steam" "lutris")

# grab the computer's host name
hostname=$( cat /etc/hostname )

# pc-specific packages go here
# desktop-NVIDIA GPU
if [ "$hostname" == "archDesk" ]
then
  packages+=("nvidia" "nvidia-utils" "lib32-nvidia-utils")
  packages+=("nvidia-settings")
fi

# laptop-intel iGPU
if [ "$hostname" == "archt450s" ]
then
  packages+=("mesa-amber" "lib32-mesa-amber" "vulkan-intel")
  packages+=("lib32-vulkan-intel")
fi

# install all the compiled packages
sudo pacman -S --needed "${packages[@]}"

# ensure home directory
cd ~

# download dwm and st
git clone https://github.com/markgallant01/dwm
git clone https://github.com/markgallant01/st

# build and install dwm and st
cd dwm
make
sudo make clean install
cd
cd st
make
sudo make clean install
cd

# pull temporary xinit file for the first boot
curl -LJO https://github.com/markgallant01/.dotfiles/raw/main/.xinitrc

# pull final setup script and make it executable for later
curl -LJO https://github.com/markgallant01/.dotfiles/raw/main/\
scripts/final_setup.sh
chmod +x  ~/final_setup.sh

# generate new ssh keys for github
ssh-keygen -t ed25519 -C markgallant01@gmail.com
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
