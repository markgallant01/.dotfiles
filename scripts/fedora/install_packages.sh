#!/bin/bash

# echo on
set -x

# this script builds an array of packages section-by-section
# and then calls pacman to install them all together at the end.

# array to store package list
declare -a packages=()

# wifi drivers (add more for other wifi cards)
packages+=("iwlwifi-mvm-firmware")

# window manager and shell
packages+=("niri" "dms")

# niri deps
packages+=("polkit-kde")

# DMS integrations
packages+=("khal" "cups-pk-helper" "power-profiles-daemon")

# terminal
packages+=("foot")

# CLI tools
packages+=("pandoc" "btop" "yt-dlp" "tldr" "texinfo" "fastfetch")
packages+=("neovim")

# VPN port-forward script dep
packages+=("libnatpmp")

# Proton VPN frontend
packages+=("proton-vpn-gnome-desktop")

# neovim deps
packages+=("fd-find")

# development tools
packages+=("cmake" "gdb" "java-latest-openjdk-devel.x86_64")
packages+=("docker" "docker-compose" "uv")

# graphical frontends
packages+=("pavucontrol")

# gaming stuff
packages+=("gamescope" "steam")

# multimedia
packages+=("qbittorrent" "vlc")

# communication
packages+=("discord")

# web browsers
packages+=("firefox")

# misc utilities
packages+=("xdg-user-dirs")

# video drivers depend on GPU manufacturer:
gpu_option=0
while [[ "$gpu_option" != 1 ]] &&
      [[ "$gpu_option" != 2 ]] &&
      [[ "$gpu_option" != 3 ]]
do
  echo "Choose GPU type: [1] Intel" #, [2] AMD, [3] Nvidia..."
  read gpu_option
done

# intel iGPU:
if [[ "$gpu_option" == 1 ]]; then
    packages+=("intel-media-driver")
fi

# AMD CPU GPU? --todo
#if [[ "$option" == 2]]; then
#fi

# nvidia:
#if [[ "$gpu_option" == 3 ]]; then
#    packages+=()
#fi

# install full package list. --exclude=alacritty skips the weak dependency
# for niri that installs alacritty by default. we dont need it since we have
# foot.
sudo dnf install "${packages[@]}" --exclude=alacritty

# install DMS greeter
dms greeter install

