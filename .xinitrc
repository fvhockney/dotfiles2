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

if [ $(command -v dunst) ]; then
    dunst &
fi

if [ $(command -v udiskie) ]; then
    udiskie &
fi

if [ $(command -v pasystray) ]; then
    pasystray &
fi

xbindkeys
if [ $(hostname) = 'bigkitty' ]; then
  nvidia-settings --load-config-only
fi
#$HOME/.config/screenlayouts/two-large-home.sh
#i3-config-builder
#exec i3
xmonad
