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
packages+=("feh" "gimp")

# misc utilities
packages+=("network-manager-applet" "udisks2" "neofetch" "zip" "unzip")
packages+=("scrot" "cmus" "celluloid" "neovim" "dmenu" "xdg-user-dirs")
packages+=("xclip" "npm" "wget" "curl")

# file browser
packages+=("ranger" "thunar")

# sound system
packages+=("pipewire" "lib32-pipewire" "wireplumber" "pipewire-pulse")
packages+=("blueman" "sof-firmware")

# hardware monitoring
packages+=("htop")

# music downloader
packages+=("yt-dlp")

# ebooks
packages+=("calibre")

# web browsers
packages+=("firefox" "chromium")

# communication
packages+=("discord" "thunderbird")

# game launchers
packages+=("steam" "lutris")

# wine dependencies
packages+=("wine-staging" "giflib" "lib32-giflib" "libpng")
packages+=("libldap" "lib32-libldap" "gnutls" "lib32-gnutls")
packages+=("lib32-mpg123" "openal" "lib32-openal" "v4l-utils")
packages+=("lib32-v4l-utils" "libpulse" "lib32-libpulse")
packages+=("lib32-libgpg-error" "alsa-plugins" "lib32-alsa-plugins")
packages+=("alsa-lib" "lib32-alsa-lib" "libjpeg-turbo" "mpg123")
packages+=("sqlite" "lib32-sqlite" "libxcomposite" "libgpg-error")
packages+=("libxinerama" "lib32-libgcrypt" "libgcrypt")
packages+=("ncurses" "lib32-ncurses" "ocl-icd" "lib32-ocl-icd")
packages+=("lib32-libxslt" "libva" "lib32-libva" "gtk3" "lib32-gtk3")
packages+=("gst-plugins-base-libs" "lib32-gst-plugins-base-libs")
packages+=("vulkan-icd-loader" "lib32-vulkan-icd-loader" "wine-mono")
packages+=("wine-gecko" "libxslt" "lib32-libxinerama" "lib32-libpng")
packages+=("lib32-libxcomposite" "lib32-libjpeg-turbo")

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
