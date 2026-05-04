# .dotfiles

## About

This repo serves as a central directory for all the files I use to bootstrap
and configure my system. It's a collection of written notes, scripts, and
configuration files that come together to support a mostly-automated install
of my OS with my personal configurations.

## Features

The directory is split into three main pieces: config, notes, and scripts.
Each occupies its own sub-directory.

The `config/` directory contains all the configuration files for my current
suite of programs. These are config files that would typically be found
in the .config directory in the user's home directory, but that's not true
for all of them.

The currently supported programs are:

* Niri window manager
* Foot terminal
* Neovim text editor

There are also files for custom firefox settings, gtk themes, and a .bashrc
profile, among others.

The `scripts/` directory tries to automate the installation and setup of various
linux distributions and incorporates the above config files to set them up.
Those scripts will symlink the appropriate .config folders to these
configuration files.

The currently included distros are:

* Fedora
* Arch
* Gentoo

The level of support varies depending on which distro I'm currently using.
As I swap around, the current distro will get out of sync with the ones I'm
not using. The Gentoo one is also a (perpetual) work in progress.

The `notes/` directory contains the installation instructions for each
distribution. They serve as walkthroughs / supplemental material to go along
with official installation instructions. There's a markdown version for each
and an html version generated with `pandoc` that can be viewed nicely in a
browser.

## Usage

To get started with an installation, open one of the installation guides in
the `notes/` directory. That will walk you through an initial minimal install
of one of the distributions. After that, there are instructions for running
the appropriate scripts to install and configure the system.

The instructions are specific to me, sometimes very much so. If you're not
me and you're trying to use these scripts you will need to modify them first.

## Status

The current most up-to-date guide is the Fedora one. This is the distro I'm
currently using, so this will remain true for the forseeable future.

