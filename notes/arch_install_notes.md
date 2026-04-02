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

A fresh up-to-date Arch linux ISO should be used. Download one 
[here](https://archlinux.org/download/) and make a bootable usb with the **dd**
command:

`$ dd bs=4M if=path/to/archlinux.iso of=/dev/flashDrive conv=fsync
oflag=direct status=progress`

*Note: use the* **`lsblk`** *command to identify the USB drive before running
the above command*

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

Enter the password when prompted and then exit with `Ctrl+d`. Verify the
connection:

`# ping archlinux.org`

### 1.9 Partition the disks

On a standard setup you'll want 3 partitions. One EFI boot partition, one
SWAP partition, and one root partition. The drives can be listed with
this command:

`# lsblk -l`

The **cfdisk** utility makes partitioning easy. You'll likely want to set up
partitions according to the following table:

| partition | filesystem | size      | description          |
| --------- | ---------- | --------- | -------------------- |
| /dev/sdx1 | fat32      | 1 GiB     | EFI (boot) partition |
| /dev/sdx2 | swap       | RAM * 1.5 | Swap partition       |
| /dev/sdx3 | ext4       | remainder | root partition       |

For the swap file, on desktop suspend is unnecessary so 16G is more than
enough. On a laptop use 1.5x RAM.

Run **cfdisk** and partition things how you want.

`# cfdisk /dev/sdX`

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

Use vim to open the mirrorlist at /etc/pacman.d/mirrorlist and move the US
mirrors up to the top of the list.

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

You'll need an fstab file to get your disks mounted on boot. The **genfstab**
tool makes this simple:

`# genfstab -U /mnt >> /mnt/etc/fstab`

### 3.2 Chroot

You can now change root into the new system to begin configuring it directly:

`# arch-chroot /mnt`

### 3.3 Time

Set the appropriate time zone:

`# ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime`

*Note: Modify the above file path in accordance with your location*

Run **hwclock** to generate /etc/adjtime:

`# hwclock --systohc`

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
**NetworkManager**, all you have to do is start the service so that it starts
on boot.

`# systemctl enable NetworkManager.service`

### 3.7 Root password

Set a secure password for the root user:

`# passwd`

### 3.8 Boot loader

**Systemd-boot** comes with systemd and is easy to use. It's already installed
on the system. Initialize it:

`# bootctl install`

Next, a loader configuration file must be created and set:

*Note: These fields are separated by a space, not a tab. Systemd won't
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
Copy it from the /etc/fstab file:

`# cat /etc/fstab >> /boot/loader/entries/arch.conf`

Then format the file like this:

```
"/boot/loader/entries/arch.conf"
------------------------------
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=xxxx-xxxxx-xxxx-xxxx-xxxx-xxxx  rw
```

*Note: These fields can be separated by tabs*

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

This section configures the newly installed system. Login to the
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
`/etc/mkinitcpio.conf` to remove the 'kms' module from the HOOKS array.
This ensures the nouveau module will not be loaded during boot:

`$ sudo vim /etc/mkinitcpio.conf`

After that, re-run the command to regenerate the initramfs

`$ sudo mkinitcpio -P`

Reboot and then launch **Niri**

`$ niri-session`

## More Configuration

Some applications require manual configuration. Starting with Firefox and
LastPass makes the most sense because it will be easier to log into things
once those are set up.

### Firefox & LastPass:

Launch Firefox and sign in to start syncing everything. Go down through the
settings and verify everything is set up how you want it. Some things to
check:

* Browser fonts
* History
* Autofill
* Search engine
* Start screen

The extensions should sync and install themselves. Once LastPass shows up,
change somesettings:

* Disable "Automatically fill login information" in the extension settings
* Make sure all extensions are active in private browsing sessions
* Pin whatever extensions you want to the browser bar

### Discord:

Launch discord once to generate the config file. Add the line below to the
config file so Discord doesn't refuse to launch if there's an update that's
not in the repos yet:

```
~/.config/discord/settings.json
-------------------------------
"SKIP_HOST_UPDATE": true
```

Some settings to configure within the Discord app:

* Font size 20
* Adjust mic threshold if necessary
* Disable 'minimize to tray' and automatic startup under Linux settings

### Thunar:

Edit `/usr/share/gvfs/mounts/network.mount` and change the last line to:

```
/usr/share/gvfs/mounts/network.mount
------------------------------------
AutoMount=false
```

This helps with Thunar's slow initial startup time.

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

### New Guide to-do:

* DMS needs numbered workstations so they exist even without windows on them
* Think about Nautilus vs Thunar. Nautilus comes with the gnome desktop
portal so it's gonna be there already. If we don't like it then add the
Niri setup step to have the browser use the Gtk file picker instead.
* Look at the installer script and see if it can be better organized or
cleaned up. You should be able to run everything with one `yay` call at
the very end, since it can do the normal repos and the AUR.
* Rip whatever config stuff we want from the Dell laptop and then get the
dotfiles folder sorted out. Link up the DMS settings and niri-settings
and everything we need. Consult the Niri docs and DMS docs.
* Take a look at the reflector timer and see if we like the settings
* Figure out how to start polkit-kde-agent with Niri
* Look over the Arch
[fonts pages](https://wiki.archlinux.org/title/Fonts) and see if we have
[everything](https://wiki.archlinux.org/title/Font_configuration) covered

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
* Trim down neovim
* Add a firefox section to copy over the user.js and also make a
backup of the old profile
* Try to make the install script copy its output to a log file so we can
check for any issues afterward
* Get minecraft and wow added to the installer thing
* Consider adding a section for steam setup including log-in and settings.
Disable gpu acceleration because it sucks shit.
* Find nice drawn wallpapers for fall / winter / spring just like we did for
summer
* Configure Firefox homescreen using common websites. currently: DGG, Github,
Reddit, Wikipedia, Arch Wiki, Arch Repository, Drive, Gumaverse, /tv/, /g/
* Add a section for configuring thunar maybe. enabling auto mounting of usb
drives and displaying hidden files, anything else.
* Use betterfox and add it to the Firefox section
* I love this [console rain](https://github.com/saitamasahil/matrix) so
figure out how to incorporate this into our setup.
* Get subtitle puller addon thing for jellyfin. check bookmarks
* Get jellyfin up and running for media consumption
* NVM is slowing down the terminal startup due to the initialization stuff
it adds to the bachrc file. this is a pain in the ass.
* Maybe add curl nvm installation idk yet
* Check out musicBrainz picard for music library
* Add something about the symlink fix for
[fmod pipewire bug](https://wiki.archlinux.org/title/PipeWire#FMOD_games_crashing_under_PipeWire).

