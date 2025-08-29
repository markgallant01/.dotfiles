#!/bin/bash

# echo on
set -x

# this script builds an array of packages section-by-section
# and then calls pacman to install them all together at the end.

# array to store package list
declare -a packages=()

# CLI tools
packages+=("fastfetch" "udisks2"  "unzip" "git")
packages+=("maim" "xclip" "wget" "curl" "zip")
packages+=("usleep" "btop" "openssh" "yt-dlp" "alacritty")

# misc utilities
packages+=("xdg-user-dirs" "pacman-contrib" "fd" "rofi")
packages+=("ripgrep" "gnome-keyring" "libnatpmp")
packages+=("polkit-gnome" "xdg-desktop-portal-gtk")

# sound system
packages+=("pipewire" "lib32-pipewire" "pipewire-audio" )
packages+=("pipewire-jack" "pipewire-pulse" "wireplumber")
packages+=("blueman")

# development tools
packages+=("base-devel" "make" "cmake" "gdb")
packages+=("neovim" "jdk-openjdk" "npm")

# file manager
packages+=("thunar" "thunar-volman" "tumbler")
packages+=("gvfs-mtp" "gvfs" "ffmpegthumbnailer")

# display server & X tools
packages+=("xorg-server" "xorg-xinit")
packages+=("xorg-xrandr" "qtile" "picom")

# graphical front-ends
packages+=("network-manager-applet" "arandr")
packages+=("proton-vpn-gtk-app" "pavucontrol" "pasystray")

# gaming stuff
packages+=("steam" "dolphin-emu" "duckstation" "pcsx2-git")

# multimedia
packages+=("mpv" "ffmpeg" "feh" "qbittorrent" "deadbeef")

# file system and drive utilities
# (this will be different if not using xfs)
packages+=("xfsprogs" "dosfstools" "smartmontools")

# language servers
packages+=("bash-language-server" "clang")
packages+=("lua-language-server" "pyright")

# fonts
packages+=("ttf-liberation" "noto-fonts-cjk" "ttf-nerd-fonts-symbols")

# cosmetic
packages+=("papirus-icon-theme")

# web browsers
packages+=("firefox")

# communication
packages+=("discord")

# random fun stuff
packages+=("cava")

# chaotic-aur
packages+=()

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

