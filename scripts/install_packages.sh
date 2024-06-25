#!/bin/bash

# echo on
set -x

# this script builds an array of packages section-by-section
# and then calls pacman to install them all together at the end.

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
packages+=("blueman" "wireplumber" "pavucontrol")

# misc utilities
packages+=("xdg-user-dirs" "pacman-contrib")

# display server, x-tools, window manager
packages+=("xorg-server" "xorg-xinit" "xorg-xrandr" "awesome" "picom")

# graphical utilities
packages+=("thunar" "gvfs" "ffmpegthumbnailer" "vlc" "network-manager-applet")

# web browsers
packages+=("firefox" "firefox-developer-edition" "chromium")

# communication
packages+=("discord")

# game launchers
packages+=("steam" "lutris")

# wine dependencies
packages+=("wine-staging" "giflib" "lib32-giflib" "libpng" "lib32-libpng")
packages+=("libldap" "lib32-libldap" "gnutls" "lib32-gnutls" "mpg123")
packages+=("lib32-mpg123" "openal" "lib32-openal" "v4l-utils" "lib32-v4l-utils")
packages+=("libpulse" "lib32-libpulse" "libgpg-error" "lib32-libgpg-error")
packages+=("alsa-plugins" "lib32-alsa-plugins" "alsa-lib" "lib32-alsa-lib")
packages+=("libjpeg-turbo" "lib32-libjpeg-turbo" "sqlite" "lib32-sqlite")
packages+=("libxcomposite" "lib32-libxcomposite" "libxinerama" "lib32-libgcrypt")
packages+=("libgcrypt" "lib32-libxinerama" "ncurses" "lib32-ncurses" "ocl-icd")
packages+=("lib32-ocl-icd" "libxslt" "lib32-libxslt" "libva" "lib32-libva" "gtk3")
packages+=("lib32-gtk3" "gst-plugins-base-libs" "lib32-gst-plugins-base-libs")
packages+=("vulkan-icd-loader" "lib32-vulkan-icd-loader")

# video drivers depend on GPU manufacturer:
option=0
while [[ "$option" != 1 ]] && [[ "$option" != 2 ]] && [[ "$option" != 3 ]]
do
  echo "Choose GPU type: [1] Nvidia, [2] Intel, [3] AMD..."
  read option
done

# nvidia:
if [[ "$option" == 1]]; then
  packages+=("nvidia" "nvidia-utils" "lib32-nvidia-utils")
  packages+=("nvidia-settings")
fi

# intel iGPU:
if [[ "$option" == 2]]; then
  packages+=("mesa-amber" "lib32-mesa-amber" "vulkan-intel")
  packages+=("lib32-vulkan-intel")
fi

# AMD CPU GPU? --todo
#if [[ "$option" == 3]]; then
#fi

# install all the compiled packages
sudo pacman -S --needed "${packages[@]}"
