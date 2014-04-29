#!/bin/sh
# ~/.xinitrc - `xinit`/`startx` startup script

have() { type "$1" > /dev/null 2>&1; }

cd ~

# Ensure a ssh-agent

if [ ! "$SSH_AUTH_SOCK" ]; then
	exec ssh-agent ~/.xinitrc "$@" || exit
fi

if [ ! "$DBUS_SESSION_BUS_ADDRESS" ]; then
	exec dbus-launch --exit-with-session ~/.xinitrc "$@" || exit
fi

# Set up some basic things

bgcolor='#333333'
bgimage=~/lib/dotfiles/gui/noise.png

xsetroot -solid "$bgcolor" -cursor_name 'left_ptr'

if have hsetroot; then
	hsetroot -solid "$bgcolor" -tile "$bgimage"
fi

# Set command-line, DESKTOP_SESSION for xprofile

case $1 in
	cinnamon)	set -- cinnamon-session;;
	gnome)		set -- gnome-session;;
	e|e17)		set -- enlightenment_start \
		-i-really-know-what-i-am-doing-and-accept-full-responsibility-for-it;;
	e16)		set -- starte16;;
	mate)		set -- mate-session;;
	kde)		set -- startkde;;
	xfce)		set -- startxfce4;;
esac

case $1 in
	cinnamon-session)	DESKTOP_SESSION=cinnamon;;
	enlightenment_start)	DESKTOP_SESSION=enlightenment;;
	gnome-session)		DESKTOP_SESSION=gnome;;
	mate-session)		DESKTOP_SESSION=mate;;
	starte16)		DESKTOP_SESSION=enlightenment16;;
	startkde)		DESKTOP_SESSION=kde-plasma;;
	startxfce4)		DESKTOP_SESSION=xfce;;
esac

export DESKTOP_SESSION

# Load profiles and resources

[ -f /etc/profile ]	&& . /etc/profile
[ -f ~/.profile ]	&& . ~/.profile
[ -f /etc/xprofile ]	&& . /etc/xprofile
[ -f ~/.xprofile ]	&& . ~/.xprofile
[ -f ~/.Xresources ]	&& xrdb -merge ~/.Xresources
[ -f ~/.Xkbmap ]	&& setxkbmap $(cat ~/.Xkbmap)

# Set up a session

if [ "$1" ]; then
	exec "$@"
else
	exec openbox --startup ~/.config/openbox/autostart
	#exec openbox-session
fi
