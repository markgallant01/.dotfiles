#!/bin/sh

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
feh --no-fehbg --bg-fill $(~/.dotfiles/scripts/wallpaper/seasonal.sh) &

# set keyboard repetition rate and delay
xset r rate 250 30

# set initial brightness to half
# think of a better way to do this that doesnt depend on the hostname
hostname=$(cat /etc/hostname)
if [[ "$hostname" == "archThinkpad" ]]; then
    echo 426 > /sys/class/backlight/intel_backlight/brightness
fi

# statusbar loop
while true; do
    ~/.dotfiles/scripts/update_statusbar.sh
    sleep 5s
done &

exec ~/.dotfiles/scripts/start_dwm.sh

