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
packages+=("niri" "xdg-desktop-portal-gtk" "xdg-desktop-portal-gnome" "gnome-keyring")
packages+=("polkit-kde-agent" "xwayland-satellite")

# Dank Material Shell deps (non-AUR)
packages+=("dgop" "matugen" "i2c-tools" "wl-clipboard" "cliphist" "cava")
packages+=("qt6-multimedia-ffmpeg")

# do we need polkit-kde-agent? it pulls in a lot of kde stuff.

# CLI tools
packages+=("fastfetch" "unzip" "git")
packages+=("wget" "curl" "zip")
packages+=("btop" "openssh" "yt-dlp")
packages+=("foot")

# misc utilities
packages+=("xdg-user-dirs")

# proton-vpn port forwarding script deps
packages+=("libnatpmp")

# neovim stuff
packages+=("fd" "ripgrep")

# development tools
packages+=("base-devel" "make" "cmake" "gdb")
packages+=("neovim" "jdk-openjdk" "npm")
packages+=("docker" "docker-compose")

# file manager
packages+=("thunar" "thunar-volman" "tumbler")
packages+=("gvfs-mtp" "gvfs" "ffmpegthumbnailer")

# consider trying Nautilus since it comes with the gnome xdg portal

# graphical front-ends
packages+=("proton-vpn-gtk-app" "pavucontrol")

# gaming stuff
packages+=("steam" "gamescope")

# multimedia
packages+=("ffmpeg" "qbittorrent")
packages+=("vlc" "vlc-plugins-all")

# try to figure out if we actually need all those plugins for vlc to work
# with subtitles and stuff

# file system and drive utilities
# (this will be different if not using xfs)
packages+=("dosfstools" "exfatprogs" "exfat-utils" "smartmontools")
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

# install all the compiled packages
sudo pacman -S --noconfirm --needed "${packages[@]}"

# install yay for AUR access
cd
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd

# install DankMaterialShell from the AUR (and dependency)
yay -S dms-shell-bin dsearch-bin

