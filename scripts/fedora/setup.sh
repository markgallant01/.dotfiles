#!/bin/bash

# echo on
set -x

# set up repos
# enable DMS COPR repo:
sudo dnf copr enable -y avengemedia/dms

# enable RPM Fusion repos for discord and steam:
# free repo:
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# non-free repo:
sudo dnf install -y \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# config for steam:
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# proton-vpn
# download the package with the repo info and keys:
wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm"

# install proton-vpn repo:
sudo dnf install -y \
    ./protonvpn-stable-release-1.0.3-1.noarch.rpm && sudo dnf check-update --refresh

# call install script to install system packages
~/.dotfiles/scripts/fedora/install_packages.sh

# create xdg-user-dirs
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
ln -sf ~/.dotfiles/foot         ~/.config/foot

# enable DMS service
systemctl --user enable dms

# clean up home directory
rm ~/protonvpn-stable-release-*

# generate new ssh keys for github
ssh-keygen -t ed25519 -C markgallant01@gmail.com
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

