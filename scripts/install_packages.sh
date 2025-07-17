#!/bin/bash

# echo on
set -x

# this script builds an array of packages section-by-section
# and then calls pacman to install them all together at the end.

# array to store package list
declare -a packages=()

# file system programs (this will be different if not using xfs)
packages+=("xfsprogs" "papirus-icon-theme")

# development tools
packages+=("base-devel" "make" "cmake" "clang" "gdb" "npm" "neovim" "jdk-openjdk")

# CLI tools
packages+=("udisks2" "fastfetch" "zip" "unzip" "yt-dlp")
packages+=("maim" "xclip" "wget" "curl" "htop" "git" "openssh")
packages+=("usleep" "alacritty")

# fonts
packages+=("noto-fonts noto-fonts-cjk" "ttf-nerd-fonts-symbols")

# sound system
packages+=("pipewire" "lib32-pipewire" "pipewire-audio" "pipewire-pulse")
packages+=("pipewire-jack" "blueman" "wireplumber" "pavucontrol")

# misc utilities
packages+=("xdg-user-dirs" "pacman-contrib" "xdg-desktop-portal-gtk")
packages+=("picom" "ripgrep" "fd" "gnome-keyring" "proton-vpn-gtk-app" "qbittorrent")
packages+=("libnatpmp" "polkit-gnome")

# display server & X tools
packages+=("xorg-server" "xorg-xinit" "xorg-xrandr" "xorg-xsetroot")
packages+=("awesome")

# graphical utilities
packages+=("mpv" "network-manager-applet")

# file manager
packages+=("thunar" "thunar-volman" "gvfs" "gvfs-mtp" "tumbler")
packages+=("ffmpegthumbnailer")

# web browsers
packages+=("chromium")

# communication
packages+=("discord")

# game launchers
packages+=("steam" "dolphin-emu")

# random fun stuff
packages+=("cava")

# video drivers depend on GPU manufacturer:
option=0
while [[ "$option" != 1 ]] &&
      [[ "$option" != 2 ]] &&
      [[ "$option" != 3 ]]
do
  echo "Choose GPU type: [1] Nvidia, [2] Intel, [3] AMD..."
  read option
done

# nvidia:
if [[ "$option" == 1 ]]; then
  packages+=("nvidia" "nvidia-utils" "lib32-nvidia-utils")
  packages+=("nvidia-settings")
fi

# intel iGPU:
if [[ "$option" == 2 ]]; then
  packages+=("mesa" "lib32-mesa" "vulkan-intel")
  packages+=("lib32-vulkan-intel" "intel-media-driver")
fi

# AMD CPU GPU? --todo
#if [[ "$option" == 3]]; then
#fi

# install all the compiled packages
sudo pacman -S --needed "${packages[@]}"

