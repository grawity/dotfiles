#!/bin/sh
# ~/.xinitrc - `xinit`/`startx` startup script

have() { type "$1" > /dev/null 2>&1; }

cd ~

# Load basic profile

[ -f /etc/profile ]	&& . /etc/profile
[ -f ~/.profile ]	&& . ~/.profile

# Ensure a ssh-agent

if [ ! "$SSH_AUTH_SOCK" ] && have ssh-agent; then
	exec ssh-agent ~/.xinitrc "$@" || exit
fi

if [ ! "$DBUS_SESSION_BUS_ADDRESS" ] && have dbus-launch; then
	exec dbus-launch --exit-with-session ~/.xinitrc "$@" || exit
fi

# Set up some basic things

bgcolor='#222222'
bgimage=~/lib/dotfiles/gui/noise.png

xsetroot -solid "$bgcolor" -cursor_name 'left_ptr'

if have hsetroot; then
	hsetroot -solid "$bgcolor" -tile "$bgimage"
fi

# Set up D-Bus

dbus-update-activation-environment --systemd DISPLAY XAUTHORITY

# Normalize command line (expand aliases)

case $1 in
	cinnamon)	set -- cinnamon-session;;
	e|e17)		set -- enlightenment_start -i-really-know-what-i-am-doing-and-accept-full-responsibility-for-it;;
	gnome)		set -- gnome-session;;
	kde)		set -- startkde;;
	mate)		set -- mate-session;;
	xfce)		set -- startxfce4;;
esac

# Set $DESKTOP_SESSION for xprofile and others

case $1 in
	cinnamon-session)	DESKTOP_SESSION=cinnamon;;
	gnome-session)		DESKTOP_SESSION=gnome;;
	enlightenment_start)	DESKTOP_SESSION=enlightenment;;
	mate-session)		DESKTOP_SESSION=mate;;
	startkde)		DESKTOP_SESSION=kde-plasma;;
	startxfce4)		DESKTOP_SESSION=xfce;;
	xterm)			DESKTOP_SESSION=xterm;;
esac

export DESKTOP_SESSION

# Load X11-specific profile

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
