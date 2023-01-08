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

while true
do
    VOL=$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')
    LOCALTIME=$(date "+%a %b %d %Y %H:%M")
    TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"

    if acpi -a | grep off-line > /dev/null
    then
        BAT="Bat. $(acpi -b | awk '{ print $4 " " $5 }' | tr -d ',')"
        xsetroot -name "$BAT $VOL $TEMP $LOCALTIME"
    else
        xsetroot -name "$VOL $TEMP $LOCALTIME"
    fi
    sleep 60s
done &

# launch programs and window manager
~/.fehbg &
exec dwm

