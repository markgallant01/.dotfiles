#!/bin/bash

# this script sorts out some final settings
# after all the packages have been installed
# and you've setup ssh for github

# ensure home directory
cd ~

# set up some directories
mkdir Screenshots Trash Usb

# configure git
git config --global user.name markgallant01
git config --global user.email markgallant01@gmail.com
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false

# delete default xinit file
rm .xinitrc

# clone dotfiles repo
git clone git@github.com:markgallant01/.dotfiles.git

# symlink settings files
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.xinitrc ~/.xinitrc
ln -sf ~/.dotfiles/.fehbg ~/.fehbg
ln -sf ~/.dotfiles/nvim/ ~/.config/nvim
ln -sf ~/.dotfiles/ssh_config ~/.ssh/config
ln -sf ~/.dotfiles/picom.conf ~/.config/picom.conf

# copy conf files to appropriate folders
sudo cp ~/.dotfiles/etc_conf_files/00-input-devices.conf /etc/X11/xorg.conf.d/
sudo mkdir /etc/pacman.d/hooks/
sudo cp ~/.dotfiles/etc_conf_files/nvidia.hook /etc/pacman.d/hooks/

# setup Yay to use the AUR:
mkdir ~/aur
cd ~/aur
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~

# install any aur programs
yay -S deadbeef

# clock synchronization service
sudo systemctl enable systemd-timesyncd.service

# sound system
systemctl --user enable pipewire-pulse.service

# enable bluetooth
sudo systemctl enable bluetooth

