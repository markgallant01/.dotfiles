#!/usr/bin/bash

# This script will attempt to setup and configure
# the system by pulling dotfiles from github, setting
# appropriate symlinks, and running preliminary software.
#
# This script should be run after successfully running
# install_script.sh

# Before running, navigate to github in a web browser
# and log in. Prepare to add a new ssh key.

# copy ssh key to clipboard
xclip -selection clipboard < ~/.ssh/id_ed25519.pub

# wait until ssh key has been added to github
echo "SSH key copied to clipboard. Add to github and press enter when
finished..."
read

# pull dotfile directory from github
git clone git@github.com:markgallant01/.dotfiles

# create symlinks for dotfiles

# add xconf.d stuff for mouse accel and touchpad and stuff

# run initial stuff like wal or feh

