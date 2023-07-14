#!/bin/bash

# this script sorts out some final settings
# after all the packages have been installed
# and you've setup ssh for github

# ensure home directory
cd ~

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

# clone the proper repositories now that we're authenticated
git clone git@github:markgallant01/dwm.git
git clone git@github:markgallant01/st.git

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

# clone dotfiles repo
git clone git@github.com:markgallant01/.dotfiles.git

# symlink settings files
ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.xinitrc ~/.xinitrc
ln -sf ~/.dotfiles/picom.conf ~/.config/picom.conf
ln -sf ~/.dotfiles/.fehbg ~/.fehbg
ln -sf ~/.dotfiles/nvim/ ~/.config/nvim

# copy conf files to appropriate folders
sudo cp ~/.dotfiles/00-input-devices.conf /etc/X11/xorg.conf.d/
sudo cp ~/.dotfiles/nvidia.hook /etc/pacman.d/hooks/

# setup Yay to use the AUR:
git clone https://aur.archlinux.org/yay.git
cd yay
sudo makepkg -si

# install any aur programs
yay -S cava

