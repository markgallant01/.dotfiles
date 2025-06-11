#!/bin/sh

# lua ~/.dotfiles/awesome/seasonal.lua

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
~/.fehbg &
picom &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
thunar --daemon &
#urxvtd -q -f -o &

# statusbar loop
while true; do
    ~/.dotfiles/scripts/update_statusbar.sh
    sleep 5s   # update every 5 seconds
done &

exec ~/.dotfiles/scripts/start_dwm.sh
#exec awesome
#exec qtile start

