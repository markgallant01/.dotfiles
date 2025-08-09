#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
urxvtresources=$HOME/.dotfiles/urxvt.xresources

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

# merge urxvt settings
if [ -f "$urxvtresources" ]; then
    xrdb -merge "$urxvtresources"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# launch programs and window manager
~/.config/setup_screens.sh &
nm-applet &
blueman-applet &
picom &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
thunar --daemon &

# set keyboard repetition rate and delay
xet r rate 250 30

# set initial brightness to half
# think of a better way to do this that doesnt depend on the hostname
hostname=$(cat /etc/hostname)
if [[ "$hostname" == "archThinkpad" ]]; then
    echo 426 > /sys/class/backlight/intel_backlight/brightness
fi

exec ~/.dotfiles/scripts/start_dwm.sh

