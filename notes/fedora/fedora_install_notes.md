# Fedora Linux Installation

*html file created with this command:*

`pandoc -s input_file.md -o output_file.html`

*This is a compilation of notes for setting up a Fedora install*

## 1. Net Everything Installer

### 1.1 Prepare an installation medium

A minimal Fedora installation requires using the net Everyting Installer.
Download it [here](https://fedoraproject.org/misc/#everything) and make a
bootable usb with the **dd** command:

`$ dd bs=4M if=path/to/fedora_linux.iso of=/dev/flashDrive conv=fsync
oflag=direct status=progress`

*Note: use the* **`lsblk`** *command to identify the USB drive before running
the above command*

Boot into the live environment and continue.

### 1.2 Using the graphical installer

The graphical installer makes installation relatively simple. Make sure
you're connected to the internet so you can download the packages. Choose
how you want the disks set up (probably defaults, wiping existing paritions).
Set up a user and enable root permissions for it. You don't need an actual
root user.

Enable the closest mirror for the repositories and determine which packages
you want. Currently these are the options we choose:

    Base Environment: Fedora Custom Operating System

    Additional software for Selected Environment:

        Common NetworkManager Submodules
        Standard
        C Development Tools and Libraries
        Development Tools

    Note: The Development Tools option might be a little heavy. The only
        thing we actually want might be git. We can take a closer look at
        these package groups once we have a functional system and see if
        any of these should be skipped. We may just want to install stuff
        like git, gcc, g++, etc on our own to avoid all the rest.

Once the installation completes, reboot the PC and remove the USB. Log in
with your created user.

On the initial login you likely won't have internet if you're on wifi. You
can plug into ethernet if possible, or USB tether to a phone. Whichever you
choose, you can install the firmware for your wifi card first:

`$ sudo dnf install iwlwifi-mvm-firmware`

That installs firmware for intel wifi cards. For different brands, you'll
have to look up the corresponding package. Once that's done you can either
reboot to use the wifi, or stay tethered for the rest of the installation.

In either case, set your hostname:

`$ sudo hostnamectl set-hostname <hostname>`

Git should already be installed. Use it to download the setup and config
files:

`$ git clone https://github.com/markgallant01/.dotfiles.git`

You might need to make the setup scripts executable:

```
$ chmod +x ~/.dotfiles/scripts/fedora/setup.sh
$ chmod +x ~/.dotfiles/scripts/fedora/install_packages.sh
```

Run the setup script:

`$ ~/.dotfiles/scripts/fedora/setup.sh`

Reboot one more time and everything should be all set.


## More Configuration

Some applications require manual configuration. Starting with Firefox and
LastPass makes the most sense because it will be easier to log into things
once those are set up.

### Firefox & LastPass:

Launch Firefox and sign in to start syncing everything. Go down through the
settings and verify everything is set up how you want it. Some things to
check:

* Default browser
* Show sidebar
* Fonts
* New windows and tabs
* Firefox Home Content
* Default search engine
* Firefox Suggest
* Passwords, Payment methods, Addressess...
* History
* AI Controls

The extensions should sync and install themselves. Once LastPass shows up,
change some settings:

* Disable "Automatically fill login information" in the extension settings
* Make sure all extensions are active in private browsing sessions
* Pin whatever extensions you want to the browser bar

### Discord:

Launch discord once to generate the config file. Add the line below to the
config file so Discord doesn't refuse to launch if there's an update that's
not in the repos yet:
(This may already be there depending on the distro)

```
~/.config/discord/settings.json
-------------------------------
"SKIP_HOST_UPDATE": true
```

Some settings to configure within the Discord app:

* Font size 20
* Adjust mic threshold if necessary
* Disable 'minimize to tray' and automatic startup under Linux settings

### Steam:

There's a bug in steam on Wayland where it will likely show a black window
when you first launch it. The interface is there and the buttons work, you
just can't see anything. The fix is to click the Steam menu option in the very
top left corner, which should bring up the menu, and then go into the settings
and disable GPU acceleration in the web view under the interface settings
section.


### Wallpapers:

Log into google drive and download the Wallpaper folder. Unzip that folder
into the `~/Pictures/` directory to make it useable by the system's wallpaper
system.

### Github:

Set up authentication with Github by first launching the web browser and
logging into your Github account. The installation script generated new ssh
keys. Print the public key:

`$ cat ~/.ssh/id_ed25519.pub`

Copy this output and add it to the Github ssh keys under your account
settings. After that, verify the connection works:

`$ ssh -T git@github.com`

Once authenticated, delete and re-clone the dotfiles folder so everything
is connected properly.

```
$ rm -rf ~/.dotfiles
$ git clone git@github.com:markgallant01/.dotfiles.git
```
## Optional Extras

This stuff depends on the PC setup and may or may not be done

### External drives:

If there are any additional storage drives in the PC, you should add them
to the fstab file so they auto mount at startup. Consult
[this link](https://wiki.archlinux.org/title/Fstab) for reference.

## The End

### Fedora to-do:

* look into trimming down the initial package base by reading what packages
are installed in the package groups we select from the everything installer.
we probably don't actually need all of those.
* try out the `fish` shell and if we like it add it to the list of package
installations and figure out how to make it the default shell
* Add some LSP keybinds at some point. Not sure which ones we'll want yet.
A good starting point would be to copy the ones from the Kickstart repo.
* Skipping treesitter plugin for now because it's complicated and i'm not
sure if it's worth it. Use vim for a bit and see if you care.
* Need to incorporate nerd font because terminal won't work without it.
Figure this out asap. Probably just back up the .zip for the font and
unzip it to .local/share/fonts as part of the install process.
* set better size rules for stuff because things are too small on
desktop. Stuff like Firefox should probably be either sized by
a percentage of the screen size or just take up all of the screen
on laptop. Discord too.
* consider adding a section for setting up DMS settings. Wallpaper, muting
Discord notifications, etc.
* dms is still missing kimageformats. figure that out.

### New Guide to-do:

* take a look at wl-mirror for screen mirroring on Niri

### Old to-do:

* Write a bash script to check if the AC power is plugged in at startup
and modify power-profiles-daemon appropriately with powerprofilesctl. Set
this as a systemD service so it runs at boot.
* Add python-pip and / or uv to the installation list
* Add a section to set up bnet with steam since it's kinda unique
* Get duckstation and other emulators working out of the box as far as
mounting automatically and having the emulator know where to find saves,
box art, etc
* Check out zathura document reader
* Add a firefox section to copy over the user.js and also make a
backup of the old profile
* Find nice drawn wallpapers for fall / winter / spring just like we did for
summer
* Configure Firefox homescreen using common websites. currently: DGG, Github,
Reddit, Wikipedia, Arch Wiki, Arch Repository, Drive, Gumaverse, /tv/, /g/
* Use betterfox and add it to the Firefox section
* I love this [console rain](https://github.com/saitamasahil/matrix) so
figure out how to incorporate this into our setup.
* Get subtitle puller addon thing for jellyfin. check bookmarks
* Get jellyfin up and running for media consumption
* NVM is slowing down the terminal startup due to the initialization stuff
it adds to the bashrc file. this is a pain in the ass.
* Maybe add curl nvm installation idk yet
* Check out musicBrainz picard for music library
* Add something about the symlink fix for
[fmod pipewire bug](https://wiki.archlinux.org/title/PipeWire#FMOD_games_crashing_under_PipeWire).

