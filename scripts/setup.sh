#!/bin/bash

# echo on
set -x

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
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.xinitrc ~/.xinitrc
ln -sf ~/.dotfiles/.Xresources ~/.Xresources
ln -sf ~/.dotfiles/.fehbg ~/.fehbg
ln -sf ~/.dotfiles/nvim/ ~/.config/nvim
ln -sf ~/.dotfiles/awesome/ ~/.config/awesome
ln -sf ~/.dotfiles/ssh_config ~/.ssh/config
ln -sf ~/.dotfiles/picom.conf ~/.config/picom.conf
ln -sf ~/.dotfiles/gtk-3.0/ ~/.config/gtk-3.0
ln -sf ~/.dotfiles/deadbeef/ ~/.config/deadbeef

# copy conf files to appropriate folders
sudo cp ~/.dotfiles/etc_conf_files/00-input-devices.conf /etc/X11/xorg.conf.d/
sudo mkdir /etc/pacman.d/hooks/
sudo cp ~/.dotfiles/etc_conf_files/nvidia.hook /etc/pacman.d/hooks/

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
