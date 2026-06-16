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

# terminal & shell
packages+=("foot" "fish")

# CLI tools
packages+=("fastfetch" "unzip" "git")
packages+=("wget" "curl" "zip" "pandoc")
packages+=("btop" "openssh" "yt-dlp" "tldr")
packages+=("man-db" "man-pages" "texinfo")

# misc utilities
packages+=("xdg-user-dirs")

# prototon vpn port-forwarding script deps
packages+=("libnatpmp")

# neovim stuff
packages+=("fd" "ripgrep" "tree-sitter-cli")

# programming languages & programming language utilities
packages+=("gcc" "gdb")
packages+=("nodejs" "npm" "typescript")
packages+=("python" "python-pip" "uv")
packages+=("jdk-openjdk")
packages+=("lua" "luarocks")

# development tools
packages+=("base-devel" "make" "cmake")
packages+=("neovim")
packages+=("docker" "docker-compose")

# graphical front-ends
packages+=("proton-vpn-gtk-app" "pavucontrol" "gnome-disk-utility")
packages+=("nautilus")

# gaming stuff
packages+=("steam" "gamescope")

# multimedia
packages+=("ffmpeg" "qbittorrent")
packages+=("vlc" "vlc-plugins-all")

# file system and drive utilities
# (this will be different if not using xfs)
packages+=("dosfstools" "exfatprogs" "smartmontools")
packages+=("e2fsprogs")

# fonts
packages+=("ttf-jetbrains-mono-nerd" "noto-fonts" "noto-fonts-cjk")

# communication
packages+=("discord")

# web browser
packages+=("firefox")

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
  echo "Choose GPU type: [1] Intel, [2] AMD, [3] Nvidia..."
  read gpu_option
done

# intel iGPU:
if [[ "$gpu_option" == 1 ]]; then
  packages+=("mesa" "lib32-mesa" "vulkan-intel")
  packages+=("lib32-vulkan-intel" "intel-media-driver")
fi

# AMD CPU GPU? --todo
#if [[ "$option" == 2]]; then
#fi

# nvidia:
if [[ "$gpu_option" == 3 ]]; then
  packages+=("nvidia-open" "nvidia-settings")
  packages+=("nvidia-utils" "lib32-nvidia-utils")
fi

# install arch repo packages
sudo pacman -S --noconfirm --needed "${packages[@]}"

# install yay for AUR access
cd
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd

# array to store AUR package list
declare -a aur_packages=()

# noctalia shell + noctalia deps
aur_packages+=("noctalia-qs" "noctalia-shell")

# install AUR packages
yay -S --noconfirm "${aur_packages[@]}"

