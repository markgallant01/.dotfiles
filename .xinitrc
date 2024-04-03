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
  xrandr_call="--output DP-0 --mode 2560x1440 --rate 120.00 --output DP-2 --mode 2560x1440 --rate 120.00 --right-of DP-0"
fi

if [ "$hostname" == "archt450s" ]
then
  xrandr_call="--output eDP1 --mode 1920x1080 --rate 60.05"
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

