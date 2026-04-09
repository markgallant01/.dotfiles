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
packages+=("power-profiles-daemon")

# CLI tools
packages+=("fastfetch" "unzip" "git")
packages+=("wget" "curl" "zip")
packages+=("btop" "openssh" "yt-dlp")
packages+=("foot" "man-db" "man-pages" "texinfo")

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

# cpu microcode depnds on CPU manufacturer:
cpu_option=0
while [[ "$cpu_option" != 1 ]] &&
      [[ "$cpu_option" != 2 ]]
do
    echo "Choose CPU type: [1] Intel, [2] AMD..."
    read cpu_option
done

# intel CPU microcode
if [[ "$cpu_option" == 1 ]]; then
    packages+=("intel-ucode")
fi


# AMD CPU microcode
if [[ "$cpu_option" == 2 ]]; then
    packages+=("amd-ucode")
fi

# video drivers depend on GPU manufacturer:
gpu_option=0
while [[ "$gpu_option" != 1 ]] &&
      [[ "$gpu_option" != 2 ]] &&
      [[ "$gpu_option" != 3 ]]
do
  echo "Choose GPU type: [1] Nvidia, [2] Intel, [3] AMD..."
  read gpu_option
done

# nvidia:
if [[ "$gpu_option" == 1 ]]; then
  packages+=("nvidia-open" "nvidia-settings")
  packages+=("nvidia-utils" "lib32-nvidia-utils")
fi

# intel iGPU:
if [[ "$gpu_option" == 2 ]]; then
  packages+=("mesa" "lib32-mesa" "vulkan-intel")
  packages+=("lib32-vulkan-intel" "intel-media-driver")
fi

# AMD CPU GPU? --todo
#if [[ "$option" == 3]]; then
#fi

# install arch repo packages
sudo pacman -S --needed "${packages[@]}"

# install yay for AUR access
cd
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd

# install Noctalia shell + AUR deps from AUR
yay -S noctalia-qs noctalia-shell

