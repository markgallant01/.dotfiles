#!/bin/bash

# this script sorts out some final settings
# after all the packages have been installed
# and you've setup ssh for github

# ensure home directory
cd ~

# set up home directories
xdg-user-dirs-update
mkdir Screenshots Trash Usb

# uninstall bad dwm repo and delete directory
cd dwm/
sudo make uninstall
cd ~
sudo rm -r dwm/

# uninstall bad st repo and delete directory
cd st/
sudo make uninstall
cd ~
sudo rm -r st/

# configure git
git config --global user.name markgallant01
git config --global user.email markgallant01@gmail.com
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false

# clone the proper repositories now that we're authenticated
git clone git@github.com:markgallant01/dwm.git
git clone git@github.com:markgallant01/st.git

# build and install dwm
cd dwm/
make
sudo make clean install
cd ~

# build and install st
cd st/
make
sudo make clean install
cd ~

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

# clock synchronization service
sudo systemctl enable --now systemd-timesyncd.service

# enable bluetooth
sudo systemctl enable bluetooth

