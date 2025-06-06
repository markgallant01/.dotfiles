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
packages+=("base-devel" "clang" "gdb" "npm" "neovim" "jdk-openjdk")

# CLI tools
packages+=("udisks2" "fastfetch" "zip" "unzip" "yt-dlp" "feh")
packages+=("scrot" "xclip" "wget" "curl" "htop" "git" "openssh")
packages+=("usleep")

# fonts
packages+=("ttf-noto-nerd" "noto-fonts-cjk")

# sound system
packages+=("pipewire" "lib32-pipewire" "pipewire-audio" "pipewire-pulse")
packages+=("pipewire-jack" "blueman" "wireplumber" "pavucontrol")

# misc utilities
packages+=("xdg-user-dirs" "pacman-contrib" "xdg-desktop-portal-gtk")
packages+=("picom" "ripgrep")

# display server & X tools
packages+=("xorg-server" "xorg-xinit" "xorg-xrandr" "xorg-xsetroot")

# graphical utilities
packages+=("vlc" "network-manager-applet")

# file manager
packages+=("thunar" "thunar-volman" "gvfs" "gvfs-mtp" "tumbler")
packages+=("ffmpegthumbnailer")

# web browsers
packages+=("firefox" "firefox-developer-edition" "chromium")

# communication
packages+=("discord")

# game launchers
packages+=("steam" "lutris")

# wine dependencies
packages+=("wine-staging" "lib32-giflib" "libpng" "lib32-libpng")
packages+=("giflib" "libldap" "lib32-libldap" "gnutls" "lib32-gnutls")
packages+=("mpg123" "lib32-mpg123" "openal" "lib32-openal" "v4l-utils") 
packages+=("lib32-v4l-utils" "alsa-lib" "libpulse" "sqlite")
packages+=("lib32-libpulse" "libgpg-error" "lib32-libgpg-error")
packages+=("alsa-plugins" "lib32-alsa-plugins" "lib32-alsa-lib")
packages+=("libjpeg-turbo" "lib32-libjpeg-turbo" "lib32-sqlite")
packages+=("libxcomposite" "lib32-libxcomposite" "libxinerama")
packages+=("lib32-libgcrypt" "ocl-icd" "lib32-ocl-icd")
packages+=("libgcrypt" "lib32-libxinerama" "ncurses" "lib32-ncurses")
packages+=("libxslt" "lib32-libxslt" "libva" "lib32-libva" "gtk3")
packages+=("lib32-gtk3" "gst-plugins-base-libs" "vulkan-icd-loader")
packages+=("lib32-vulkan-icd-loader" "lib32-gst-plugins-base-libs")

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
