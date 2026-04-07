#!/bin/bash

# echo on
set -x

# this script builds an array of packages section-by-section
# and then calls pacman to install them all together at the end.

# array to store package list
declare -a packages=()

# pacman
packages+=("pacman-contrib")

# sound system
packages+=("pipewire" "lib32-pipewire" "pipewire-audio" )
packages+=("pipewire-jack" "pipewire-pulse" "wireplumber")
packages+=("bluez" "bluez-utils")

# Niri deps
packages+=("niri" "xdg-desktop-portal-gtk" "xdg-desktop-portal-gnome")
packages+=("gnome-keyring" "polkit-kde-agent" "xwayland-satellite")

# Noctalia shell deps (non-AUR)
packages+=("brightnessctl" "imagemagick")

# Noctalia shell optional deps (non-AUR)
packages+=("cliphist" "cava" "ddcutil" "wlsunset" "evolution-data-server")

# CLI tools
packages+=("fastfetch" "unzip" "git")
packages+=("wget" "curl" "zip")
packages+=("btop" "openssh" "yt-dlp")
packages+=("foot")

# misc utilities
packages+=("xdg-user-dirs")

# prototon vpn port-forwarding script deps
packages+=("libnatpmp")

# neovim stuff
packages+=("fd" "ripgrep")

# development tools
packages+=("base-devel" "make" "cmake" "gdb")
packages+=("neovim" "jdk-openjdk" "npm")
packages+=("docker" "docker-compose" "uv")

# file manager
packages+=("thunar" "thunar-volman" "tumbler")
packages+=("gvfs-mtp" "gvfs" "ffmpegthumbnailer")

# graphical front-ends
packages+=("proton-vpn-gtk-app" "pavucontrol")

# gaming stuff
packages+=("steam" "gamescope")

# multimedia
packages+=("ffmpeg" "qbittorrent")
packages+=("vlc" "vlc-plugins-all")

# file system and drive utilities
# (this will be different if not using xfs)
packages+=("dosfstools" "exfatprogs" "smartmontools")
packages+=("e2fsprogs")

# language servers
packages+=("bash-language-server" "clang")
packages+=("lua-language-server" "pyright")

# fonts
packages+=("ttf-liberation" "noto-fonts-cjk" "ttf-nerd-fonts-symbols")

# cosmetic
packages+=("papirus-icon-theme")

# web browsers
packages+=("firefox" "chromium")

# communication
packages+=("discord")

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
  packages+=("nvidia-open" "nvidia-settings")
  packages+=("nvidia-utils" "lib32-nvidia-utils")
fi

# intel iGPU:
if [[ "$option" == 2 ]]; then
  packages+=("mesa" "lib32-mesa" "vulkan-intel")
  packages+=("lib32-vulkan-intel" "intel-media-driver")
fi

# AMD CPU GPU? --todo
#if [[ "$option" == 3]]; then
#fi

# install yay for AUR access
cd
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd

# Noctalia shell + AUR deps
packages+=("noctalia-qs" "noctalia-shell")

# install all the packages
yay -S --noconfirm --needed "${packages[@]}"

