#!/bin/sh

have() { type "$1" > /dev/null 2>&1; }

cd ~

# Ensure a ssh-agent

if [ ! "$SSH_AUTH_SOCK" ]; then
	exec ssh-agent ~/.xinitrc "$@" || exit
fi

# Set up some basic things

bgcolor='#333333'
bgimage=~/'lib/dotfiles/gui/noise.png'

xsetroot -solid "$bgcolor" -cursor_name 'left_ptr'

if have hsetroot; then
	hsetroot -solid "$bgcolor" -tile "$bgimage"
fi

# Set command-line, DESKTOP_SESSION for xprofile

case $1 in
	gnome)	set -- gnome-session;;
	e)	set -- enlightenment_start;;
	kde)	set -- startkde;;
	xfce)	set -- startxfce4;;
esac

case $1 in
	gnome-session)		DESKTOP_SESSION=gnome;;
	enlightenment_start)	DESKTOP_SESSION=enlightenment17;;
	startkde)		DESKTOP_SESSION=kde-plasma;;
	systemd)		DESKTOP_SESSION=systemd;;
	xfce)			DESKTOP_SESSION=xfce;;
	*)			unset DESKTOP_SESSION;;
esac

# Load profiles and resources

[ -f /etc/profile ]	&& . /etc/profile
[ -f ~/.profile ]	&& . ~/.profile
[ -f /etc/xprofile ]	&& . /etc/xprofile
[ -f ~/.xprofile ]	&& . ~/.xprofile

[ -f ~/.Xresources ]	&& xrdb -merge ~/.Xresources
[ -f ~/.Xkbmap ]	&& setxkbmap `cat ~/.Xkbmap`
[ -f ~/.Xmodmap ]	&& xmodmap ~/.Xmodmap

# Set up a session

set -a

if [ "$1" = "systemd" ]; then
	exec /usr/lib/systemd/systemd --user --unit=x11.target
elif [ "$1" ]; then
	exec "$@"
else
	exec openbox --startup ~/.config/openbox/autostart
	#exec openbox-session
fi
