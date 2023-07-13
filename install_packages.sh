#!/bin/bash

# this script builds an array of packages section-by-section
# and then calls pacman to install them all together at the end

declare -a packages=()

pacman -S "${packages[@]}"

