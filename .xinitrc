#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# grab PC's hostname
hostname=$( cat /etc/hostname )

if [ "$hostname" == "archDesk" ]
then
  xrandr_call="--output DP-4 --primary --mode 2560x1440 --rate 120.00 --output DP-0 --mode 2560x1440 --rate 120.00 --right-of DP-4"
fi

if [ "$hostname" == "archxps13" ]
then
  xrandr_call="--output eDP-1 --mode 1920x1200 --rate 59.95"
fi

# dwm statusbar loop
while true; do
  # call update script
  ~/.dotfiles/scripts/update_statusbar.sh
  sleep 5s   # update every 5 seconds
done &


# launch programs and window manager
nm-applet &
blueman-applet &
~/.fehbg &
xrandr $xrandr_call &
picom &
exec ~/.dotfiles/scripts/startdwm.sh
#exec dwm

