#!/bin/bash

# this script builds an array of packages section-by-section
# and then calls pacman to install them all together at the end.

# after that it does some prelimenary setup

# array to store package list
declare -a packages=()

# file system programs (this will be different if not using xfs)
packages+=("xfsprogs")

# development tools
packages+=("base-devel" "clang" "gdb" "npm" "neovim")

# CLI tools
packages+=("udisks2" "fastfetch" "zip" "unzip" "yt-dlp" "feh")
packages+=("scrot" "xclip" "wget" "curl" "htop" "git" "openssh")

# fonts
packages+=("noto-fonts" "noto-fonts-cjk")

# sound system
packages+=("pipewire" "lib32-pipewire" "pipewire-audio" "pipewire-pulse")
packages+=("blueman" "wireplumber")

# video drivers depend on GPU manufacturer:
# nvidia:
packages+=("nvidia" "nvidia-utils" "lib32-nvidia-utils")
packages+=("nvidia-settings")

# intel iGPU:
packages+=("mesa-amber" "lib32-mesa-amber" "vulkan-intel")
packages+=("lib32-vulkan-intel")

# AMD CPU GPU?

# misc utilities
packages+=("xdg-user-dirs")

# display server, x-tools, window manager
packages+=("xorg-server" "xorg-xinit" "xorg-xrandr" "awesome")

# graphical utilities
packages+=("thunar" "gvfs" "ffmpegthumbnailer" "vlc" "network-manager-applet")

# web browsers
packages+=("firefox" "chromium")

# communication
packages+=("discord")

# game launchers
packages+=("steam" "lutris")

# install all the compiled packages
sudo pacman -S --needed "${packages[@]}"

# ensure home directory
cd ~

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
