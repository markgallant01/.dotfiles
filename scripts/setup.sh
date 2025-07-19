#!/bin/bash

# echo on
set -x

# enable chaotic AUR
# retrieve primary key
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

# install keyring and mirrorlist packages
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# enable chaotic-aur in pacman.conf
echo "" | sudo tee -a /etc/pacman.conf >/dev/null
echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf >/dev/null
echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
echo "" | sudo tee -a /etc/pacman.conf >/dev/null

# run pacman once to generate and sync databases
sudo pacman -Syu

# run reflector once to get fast up to date mirrors
sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist

# call install script to install system packages
~/.dotfiles/scripts/install_packages.sh

# create some directories
mkdir ~/Usb
mkdir ~/Screenshots
mkdir ~/Trash
mkdir ~/.config
mkdir ~/.ssh

# configure git
git config --global user.name markgallant01
git config --global user.email markgallant01@gmail.com
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false

# symlink settings files
ln -sf ~/.dotfiles/alacritty/ ~/.config/alacritty
ln -sf ~/.dotfiles/awesome/ ~/.config/awesome
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/gtk-3.0/ ~/.config/gtk-3.0
ln -sf ~/.dotfiles/nvim/ ~/.config/nvim
ln -sf ~/.dotfiles/picom.conf ~/.config/picom.conf
ln -sf ~/.dotfiles/ssh_config ~/.ssh/config
ln -sf ~/.dotfiles/.xinitrc ~/.xinitrc

# copy conf files to appropriate folders
# pacman hooks
sudo mkdir /etc/pacman.d/hooks/
sudo cp ~/.dotfiles/etc_conf_files/nvidia.hook /etc/pacman.d/hooks/
# xorg configuration files
sudo cp ~/.dotfiles/etc_conf_files/00-input-devices.conf /etc/X11/xorg.conf.d/
sudo cp ~/.dotfiles/etc_conf_files/10-extensions.conf /etc/X11/xorg.conf.d/
sudo cp ~/.dotfiles/etc_conf_files/10-serverflags.conf /etc/X11/xorg.conf.d/
# udev rules
sudo cp ~/.dotfiles/etc_conf_files/backlight.rules /etc/udev/rules.d/

# clock synchronization service
sudo systemctl enable systemd-timesyncd.service

# sound system
systemctl --user enable pipewire-pulse.service

# enable bluetooth
sudo systemctl enable bluetooth

# generate new ssh keys for github
ssh-keygen -t ed25519 -C markgallant01@gmail.com
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

