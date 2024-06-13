#!/bin/bash

# this script builds an array of packages section-by-section
# and then calls pacman to install them all together at the end.

# after that it does some prelimenary setup

# array to store package list
declare -a packages=()

# git stuff
packages+=("git" "openssh")

# display server and some x-tools
packages+=("xorg-server" "xorg-xinit" "xorg-xrandr")

# development tools
packages+=("base-devel" "clang" "gdb" "npm")

# media viewing tools
packages+=("feh" "vlc")

# misc utilities
packages+=("network-manager-applet" "udisks2" "fastfetch" "zip" "unzip")
packages+=("scrot" "neovim" "xdg-user-dirs" "xclip" "wget" "curl")

# file browser
packages+=("thunar")

# sound system
packages+=("pipewire" "lib32-pipewire" "pipewire-audio" "pipewire-pulse")
packages+=("blueman" "wireplumber")

# hardware monitoring
packages+=("htop")

# video / music downloader
packages+=("yt-dlp")

# web browsers
packages+=("firefox" "chromium")

# communication
packages+=("discord")

# game launchers
packages+=("steam" "lutris")

# video drivers depend on GPU manufacturer:
# nvidia:
packages+=("nvidia" "nvidia-utils" "lib32-nvidia-utils")
packages+=("nvidia-settings")

# intel iGPU:
packages+=("mesa-amber" "lib32-mesa-amber" "vulkan-intel")
packages+=("lib32-vulkan-intel")

# AMD CPU GPU?

# window manager
packages+=("awesome")

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
