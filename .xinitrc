#!/bin/sh

xrdb="xrdb"
userresources="$HOME/.Xresources"

# pull in user Xresources if available
if [ -f "$userresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        "$xrdb" -merge "$userresources"
    else
        "$xrdb" -nocpp -merge "$userresources"
    fi
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# launch programs and window manager
~/.dotfiles/scripts/setup_screens.sh &
nm-applet &
blueman-applet &
picom &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
thunar --daemon &
feh --no-fehbg --bg-fill $(~/.dotfiles/scripts/wallpaper/seasonal.sh) &

# set keyboard repetition rate and delay
xset r rate 250 30

# set initial brightness to half
# think of a better way to do this that doesnt depend on the hostname
hostname=$(cat /etc/hostname)
if [[ "$hostname" == "archThinkpad" ]]; then
    echo 426 > /sys/class/backlight/intel_backlight/brightness
fi

# dwm statusbar loop
while true; do
    ~/.dotfiles/scripts/update_statusbar.sh
    sleep 1s
done &

exec dwm

