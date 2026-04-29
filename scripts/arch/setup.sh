#!/bin/bash

# echo on
set -x

# run pacman once to generate and sync databases
sudo pacman -Syu --noconfirm

# run reflector once to get fast up to date mirrors
sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist

# call install script to install system packages
~/.dotfiles/scripts/arch/install_packages.sh

# create xdg_usr_dirs
xdg-user-dirs-update

# create some more directories
mkdir ~/Pictures/Screenshots
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
ln -sf ~/.dotfiles/.bashrc      ~/.bashrc
ln -sf ~/.dotfiles/gtk-3.0/     ~/.config/gtk-3.0
ln -sf ~/.dotfiles/nvim/        ~/.config/nvim
ln -sf ~/.dotfiles/ssh_config   ~/.ssh/config
ln -sf ~/.dotfiles/niri         ~/.config/niri
ln -sf ~/.dotfiles/noctalia     ~/.config/noctalia
ln -sf ~/.dotfiles/foot         ~/.config/foot

# copy conf files to appropriate folders
# pacman hooks
sudo mkdir /etc/pacman.d/hooks/
sudo cp ~/.dotfiles/etc_conf_files/nvidia.hook /etc/pacman.d/hooks/
# thunar config
mkdir ~/.config/xfce4
cp ~/.dotfiles/xfce4/helpers.rc ~/.config/xfce4/

# clock synchronization service
sudo systemctl enable systemd-timesyncd.service

# enable weekly cleaning of the pacman cache
sudo systemctl enable paccache.timer

# enable weekly running of reflector
sudo systemctl enable reflector.timer

# enable bluetooth
sudo systemctl enable bluetooth.service

# docker service
sudo systemctl enable docker.socket

# generate new ssh keys for github
ssh-keygen -t ed25519 -C markgallant01@gmail.com
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

