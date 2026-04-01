# Arch Linux Installation

*html file created with this command:*

`pandoc -s input_file.md -o output_file.html`

*This is a compilation of notes to be used as supplementary material for
an Arch linux install. Use alongside the installation guide found
[here](wiki.archlinux.org).*

*Steps are numbered according to their corresponding Arch Wiki section. Any
skipped steps require no action from the user, but should be double checked.*

*[Comfy installation theme](https://www.youtube.com/watch?v=Z6hRV-Nq1Q0)*

## 1. Pre-installation

### 1.3 Prepare an installation medium

A fresh up-to-date Arch linux ISO should be used. Download one and make a
bootable usb with the dd command:


`$ dd bs=4M if=path/to/archlinux.iso of=/dev/flashDrive conv=fsync
oflag=direct status=progress`

Boot into the live environment and continue.

### 1.7 Connect to the internet

If you're wired then just plug in the ethernet and it should work. If using
wifi, connect to the network with iwctl.

```
# iwctl                 // this will give you an interactive prompt
[iwd]# device list               // get the name of wireless device
[iwd]# station *device* scan          // scan for wireless networks
[iwd]# station *device* get-networks               // list networks
[iwd]# station *device* connect *SSID*        // connect to network
```

Enter the password when prompted and then exit with Ctrl+d. Verify the
connection:

`# ping archlinux.org`

### 1.9 Partition the disks

On a standard setup you'll want 3 partitions. One EFI boot partition, one
SWAP partition, and one root partition. The drives can be listed with
this command:

`# lsblk -l`

The cfdisk utility makes partitioning easy. You'll likely want to set up
partitions according to the following table:

| partition | filesystem | size      | description          |
| --------- | ---------- | --------- | -------------------- |
| /dev/sdx1 | fat32      | 1 GiB     | EFI (boot) partition |
| /dev/sdx2 | swap       | RAM * 1.5 | Swap partition       |
| /dev/sdx3 | ext4       | remainder | root partition       |

For the swap file, on desktop suspend is unnecessary so 16G is more than
enough. On a laptop use 1.5x RAM.

### 1.10 Format the partitions

After partitioning, you'll need to format each partition and create the
filesystems. The following commands will create the setup outlined in the
table above:

```
# mkfs.fat -F 32 /dev/efi_system_partition
# mkswap /dev/swap_partition
# mkfs.ext4 /dev/root_partition
```

*Note: Take care to use the correct /dev/sdx labels for your particular disk.
If you desire a more unique setup that differs from the table above, consult
the wiki.*

### 1.11 Mount the file system

Each created partition will need to be mounted before it can be accessed.
Create any mount points that don't exist. The last command activates the
swap partition.

```
# mount /dev/root_partition /mnt
# mount --mkdir /dev/efi_system /mnt/boot
# swapon /dev/swap_partition
```


## 2. Installation

### 2.1 Select the mirrors

Use vim to open the mirrorlist at /etc/pacman.d/mirrorlist and ensure that the
US mirror is uncommented and the first in the list.

### 2.2 Install essential packages

You'll want to install some additional tools that will come in handy later,
in addition to the necessary base system packages:

```
# pacstrap -K /mnt base linux linux-firmware
                   man-db man-pages texinfo
                   vim networkmanager sudo
                   reflector git
                   intel-ucode OR amd-ucode <- choose correct for CPU
```


## 3. Configure the system

### 3.1 Fstab

You'll need an fstab file to get your disks mounted on boot. The genfstab
tool makes this simple:

`# genfstab -U /mnt >> /mnt/etc/fstab`

### 3.2 Chroot

You can now change root into the new system to begin configuring it directly:

`# arch-chroot /mnt`

### 3.3 Time

Set the appropriate time zone:

`# ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime`

*Note: Modify the above file path in accordance with your location*

Run hwclock to generate /etc/adjtime:

`# hwclock --systohc`

You'll also want to enable time synchronization via an NTP client to ensure
accurate time. This can be done simply with a systemd service:

`# systemctl enable systemd-timesyncd.service`

### 3.4 Localization

Enable your chosen locales by editing the /etc/locale.gen file and
uncommenting whichever you want (likely just `en_US.UTF-8`)

` # vim /etc/locale.gen`

Then generate the locales:

`# locale-gen`

Finally, create a `locale.conf` file and set the `LANG` variable:

```
"/etc/locale.conf"
-----------------
LANG=en_US.UTF-8
```

### 3.5 Network configuration

Assign a consistent identifiable name for your system on the network by
creating a hostname file:

```
"/etc/hostname"
---------------
<CHOSEN_HOSTNAME>
```

After setting up the hostname, the network must be configured. With
NetworkManager, all you have to do is start the service so that it starts
on boot.

`# systemctl enable NetworkManager.service`

### 3.7 Root password

Set a secure password for the root user:

`# passwd`

### 3.8 Boot loader

Systemd-boot comes with systemd and is easy to use. It's already installed
on the system. Initialize it:

`# bootctl install`

Next, a loader configuration file must be created and set:

*Note: These fields are separated by a space, not a tab. SystemD won't
read tabs.*

```
"/boot/loader/loader.conf"
--------------------------
default arch.conf
timeout 0
console-mode keep
```

You'll need a corresponding arch.conf file in /boot/loader/entries.
The UUID must be replaced with the UUID of the root partition.
Copy it from the /etc/fstab file.
These can be tab-separated:

```
"efi/loader/entries/arch.conf"
------------------------------
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=xxxx-xxxxx-xxxx-xxxx-xxxx-xxxx  rw
```

Use this command to make sure there's a new Arch Linux boot entry:

`# bootctl list`

You are now finished with the basic installation. Exit the chroot, unmount
the drives, and shut down.

```
# exit
# umount -R /mnt
# shutdown +0
```

Remove the installation USB and boot into the new system.

## Post-install Configuration

This section sets configures the newly installed system. Login to the
new system as root.

Setup a non-root user and set the password:

*Note: Make sure the user is in the "wheel" group if you want them to be
able to use sudo*

```
# useradd -m -G wheel <username>
# passwd *user*
```

Add the new user to the sudoers file with **visudo**

```
# EDITOR=vim visudo

%wheel ALL=(ALL:ALL) ALL    // uncomment this line
```

Then logout of root and login as the new user.

Once logged in, verify the internet:

`$ ping archlinux.org`

If you're on wifi, you may need to connect manually:

```
$ nmcli device wifi list
$ nmcli device wifi connect "SSID" password "password"
```

Setup pacman by editing `pacman.conf` to enable the multilib repo and color
support:

*Note: just uncomment these lines.*

```
"/etc/pacman.conf"
------------------
[options]
...
Color
...
VerbosePkgLists
...
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Download the setup and config files:

`$ git clone https://github.com/markgallant01/.dotfiles.git`

Make the setup scripts executable:

```
$ chmod +x ~/.dotfiles/scripts/setup.sh
$ chmod +x ~/.dotfiles/scripts/install_packages.sh
```

Run the setup script:

`$ ~/.dotfiles/scripts/setup.sh`

If nvidia drivers were installed, you must edit the file
/etc/mkinitcpio.conf to remove the 'kms' module from the HOOKS array.
This ensures the nouveau module will not be loaded during boot:

`$ sudo vim /etc/mkinitcpio.conf`

After that, re-run the command to regenerate the initramfs

`$ sudo mkinitcpio -P`

Reboot and then launch **Niri**

`$ niri-session`


/*********************/
/* POST-INSTALLATION */
/*********************/

-Some things cannot easily be automated and require manual setup here.
-Starting with Firefox and LastPass is easiest because you'll need to
 log into things

FIREFOX & LASTPASS:
    -Launch Firefox and sign in to start syncing everything
    -go down through the settings and verify everything
    -Extensions to install:
        -uBlock Origin
        -Reddit Enhancement Suite
        -LastPass
    -Install LastPass & Reddit Enhancement Suite extensions
        -Go into the LastPass extension settings and disable
         "Automatically fill login information"
        -make sure both extensions are pinned and active in private
         browser sessions
    -double check the browser font settings and set the history to
     wipe every time you close the browser. Disable any kind of
     autofill

DISCORD:
    -launch discord once to generate the config file.
    -add the shown line in this file so Discord doesn't refuse
     to launch if there's an update that's not in the repo yet:

        ~/.config/discord/settings.json
        "SKIP_HOST_UPDATE": true

    -go into the discord settings and set the font size to 20.
    -adjust the mic threshold if you have a microphone setup
    -Disable 'minimize to tray' and automatic startup under
     Linux settings

THUNAR:
    -edit /usr/share/gvfs/mounts/network.mount and change
     the last line to:

        /usr/share/gvfs/mounts/network.mount
        AutoMount=false

    -this helps with thunar taking a long time to startup the
     first time

WALLPAPERS:
    -Log into google drive and download the Wallpaper folder.
    -Unzip that folder into the ~/Pictures/ directory to make
     them useable by the system's wallpaper scripts

GITHUB:
    -authenticate with github:
    -launch web browser and login to github account.
    -the installer script generated new ssh keys.
    -print the public key:

        $ cat ~/.ssh/id_ed25519.pub

    -copy this output and add it to github ssh keys
    -verify the connection:

        $ ssh -T git@github.com

    -once authenticated, fix cloned repos

        $ rm -rf ~/.dotfiles

        $ git clone git@github.com:markgallant01/.dotfiles.git


/******************/
/* OPTIONAL STUFF */
/******************/

-This stuff depends on the PC setup and may or may not be done

VOLUME:
    -On desktop, you probably want to set the volume to 100%:

        $ pactl set-sink-volume @DEFAULT_SINK@ 100%

EXTERNAL DRIVES:
    -create additional directories in the home directory
     for any internal or external drives you want to mount:

        $ mkdir nvme_games ssd_storage

    -set up the fstab here so that drives auto mount. Consult
     https://wiki.archlinux.org/title/Fstab for reference.


/***********/
/* THE END */
/***********/

To-do:
    -write a bash script to check if the AC power is plugged in at startup
     and modify power-profiles-daemon appropriately with powerprofilesctl.
     Set this as a systemD service so it runs at boot.
    -add niri and dank material shell to installer. simplifies things
     a lot. reconfigure the installation to use DMS and do it all
     manually. make sure all the necessary stuff is included and
     connect all the config files.
    -install and setup tlp. consult the documentation, it seems mostly
     automatic. test battery life on both laptops before and after. if it
     works well, add it to this guide.
    -awesome doesn't respect the time of day when setting the wallpaper
     so figure that out or just use feh and don't have awesome set the
     wallpaper at all
    -awesome needs keybinds to swap between monitors and such
    -wallpapers are double setting now that we're on awesomewm again
    -change lua files to use 2 space indent
	-need colorbar to see when we're typing too far
	-maybe remove chaotic aur stuff because
	 it seems to cause lots of problems
	-add mount.exfat to the install list
	-no autopairs in nvim. try to get things configured.
	-figure out how to properly manage python packages and
	 versions and stuff with uv
	-add python-pip and / or uv to the installation list
	-get the color bar in nvim so it shows how far we
	 should be typing
	-awesomeWM is still getting updates so we should
	 start switching back to that and getting it
	 configured so we can get off suckless stuff.
	 also switch back to alacritty.
	-make nvim use relative line numbers
	-add a section to set up bnet with steam since
	 it's kinda unique
	-get duckstation and other emulators working out of
	 the box as far as mounting automatically and having
	 the emulator know where to find saves, box art, etc
	-check out mini.nvim and think about switching to a
	 mainly mini-based setup
	-dual_kawase blur doesn't work with the xrender backend
	 so figure that out. i kinda like it with no bur so
	 think about it
	-the performance issues from desktop were from picom
	 glx backend. switching to xrender backend seems to
	 fix it. investigate this.
	-fix formatting here
	-check out zathura document reader
    -discord isn't showing the notification icon for unread messages
     or making the ping sound so figure that out. there's stuff about
     it on the wiki.
    -figure out docker containers with bookmarks and figure out how to
     use neovim with our docker project for CS326
    -trim down neovim
    -find some good drawn fall wallpapers and think about qtile and
     alacritty vs dwm and st
    -polybar should match rofi. maybe make some themes that can be
     swapped between. maybe even match them to wallpapers.
    -make it so that empty workspaces are darker color so its obvious
    -id like a visual indicator for volume changes and brightness.
     can definitely do this with eww. think if theres another way
    -copy the qtile symbols for the workspaces into dwm
    -start configuring polybar
    -add keyboard modifications to xorg configuration. use bookmarks
     to the arch wiki keyboard page. make the keyboard repeat rate
     persistent and do the caps lock / control swap for laptops
    -add a firefox section to copy over the user.js and also make a
     backup of the old profile
    -try to make the install script copy its output to a log file so
     we can check for any issues afterward
    -keep learning about gentoo once we're at school. write up a guide
     for it based on this one. I really do like it
    -probably write our own widgets for volume, brightness, battery,
     etc. that way we dont need to install more dependencies and we
     know exactly what its doing.
    -supress the output from tty because its polluting the login screen
     (or use a login manager)
    -done with dmenu so start ricing rofi
    -get or make a good terminal theme probably copy solarized osaka
    -get minecraft and wow added to the installer thing
    -sort all bookmarks
    -go through the browser setup section and make sure it's good
     for firefox. basically just log in and set settings and everything
     should sync
    -consider a wallpaper switching keybind in dwm like before.
    -think about a screen locker and blocking tty and blocking killing
     the x server and whatever else. this is kinda complex and we might
     want a login manager to bypass it
    -consider adding a section for steam setup including log-in and
     settings. disable gpu acceleration because it sucks shit
    -find nice drawn wallpapers for fall / winter / spring just like
     we did for summer
    -nvim takes way too long to startup so troubleshoot that:
     :Lazy profile
    -reduce keyboard repeat delay even more if possible
    -rework nvim config because startup time is attrocious. trim down
     addons. consider trying native package manager
    -setup slock or another screen locker
    -set up 2 factor auth with the lastpass authenticator because
     google's authentication sucks
    -check out tlp for power management on laptops. helps with battery
     life potentially a lot
    -reconfigure the brave section to be about firefox. make homescreen
     using common websites. currently: DGG, Github, Reddit, Wikipedia,
     Arch Wiki, Arch Repository, Chaotic AUR, Raindrop(X), Drive,
     Gumaverse, /tv/, /g/
    -add a section for configuring thunar maybe. enabling auto mounting
     of usb drives and displaying hidden files, anything else.
    -use betterfox and update the part of the installer that deals
     with configuring Brave
    -figure out what we need to do to set fonts system-wide. Awesome,
     terminal (alacritty), neovim, firefox, etc all need to use the same
     font
    -set Rofi up
    -figure out how to make wallpaper set a default gentoo wallpaper
     when its run without the wallpaper folder existing yet
    -run through the general recommendations found here:
     https://wiki.archlinux.org/title/General_recommendations
    -I love this console rain:
        https://github.com/saitamasahil/matrix
     so figure out how to incorporate this into our setup
    -take another look at awesomeWM and try to figure out the bar /
     widget system. it would be cleaner to use widgets for the top bar
     and for system info so we dont require polybar and conky. polybar
     is having some weird issues with how it interacts with the WM so
     it would just be cleaner.
    -get subtitle puller addon thing for jellyfin. check
     bookmarks
    -maybe get nicer icons for qBittorrent and protonVPN but probably
     not
    -make awesomeWM open all new windows in the center
    -find a better disk utility than the baobab one. it
     doesn't seem to show much info
    -problem with fullscreen since we added the floating rule so figure
     that out
    -get jellyfin up and running for media consumption
    -make a nice landing page on web browser with common sites like
     arch wiki, reddit, youtube, etc. don't show bookmark bar by default
     because i rarely ever click it directly
    -keep configuring topbar. make the tags group look good and
     function. get rid of the clock on the right side and replace it
     with a nice systray with good looking icons for volume, network,
     brightness, maybe buttons to restart and such
    -fix nvim bufferline's background color to match lualine
    -sort out alacritty's font (nerdfont)
    -https://wiki.archlinux.org/title/GNOME/Keyring#PAM_step
     see if this fixes gnome-keyring asking for password sometimes,
     like when brave browser is launched. try to remember what else
     would cause the keyring to launch. if it's fixed, add a section
     to the installation guide.
    -looks like thunar is handling auto-mounting so look into that
    -continue to configure alacritty. font size?
    -configure alacritty and clean up stuff
    -get a good nerd font patched with icons
    -stuff I want:
        -wallpaper spans entire screen including top bar. top bar should
         be transparent between the widgets because it looks cool
        -make menu stuff transparent like rofi and terminal with blur
         for a nice modern glass effect
        -neovim should not be transparent
        -if something isn't transparent it should have the same back
         ground as the desktop (like rofi)
        -window border should be thicker and color should match color
         scheme too
    -reduce keyboard repetition rate so that we can fly around nvim
     faster
    -NVM is slowing down the terminal startup due to the initialization
     stuff it adds to the bachrc file. this is a pain in the ass
    -maybe add curl nvm installation idk yet
     Stuff we want for awesomeWM:
        -nice program launcher that lets me search for programs
         I've forgotten. Maybe Rofi?
        -login manager that looks nice. LightDM?
        -lock screen finally so we can walk away from PC without
         killing the x-server
    -figure out why USB stuff seems to automount on laptop but not
     desktop
    -maybe get suspend / hibernate to work
    -also laptop is starting on incorrect brightness but idk why
    -modify brightness step because we should be able to go darker than
     we currently can
    -get brighntess control working for desktop monitors
    -add tlp and the systemctl stuff to make it work. default settings.
    -add minecraft audio fix maybe
    -something weird going on with mounting the other drives on
     desktop. Maybe switch to UUIDs in case the labels are switching
    -get a cool nvim startup screen
    -change the wallpaper script to not switch to daytime wallpaper
     until 5am. 4 is too early.
    -modify the setup script to copy the screen setup script to the
     .config folder and add a step to set that up properly
    -might want to add a note about the intel i915 psr kernel parameter
     for that weird screen bug:
     https://wiki.archlinux.org/title/intel_graphics#Screen_flickering
    -consider adding a section about configuring Xorg. Consult
        https://wiki.archlinux.org/title/NVIDIA#Xorg_configuration
    -setup a pacman hook to clean up the paccache after each install
    -use musicBrainz picard to tag all our music and sort it. then add
     picard to the install list
    -customize brave new tab page with custom css
    -add something about the symlink fix for fmod pipewire bug:
     https://wiki.archlinux.org/title/PipeWire#\
     FMOD_games_crashing_under_PipeWire
    -maybe add SDL stuff to installer
    -setup a good screen locker that blocks tty access maybe
    -add overthewire programs like telnet and nmap as we go through it
    -look into this:
        https://wiki.archlinux.org/title/Gamemode#top-page
    -power management? (acpi?)

