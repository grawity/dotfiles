#!/bin/sh
# ~/.xinitrc - `xinit`/`startx` startup script

have() { type "$1" > /dev/null 2>&1; }

cd ~

# ensure ssh-agent, session bus

if [ ! "$SSH_AUTH_SOCK" ]; then
	if [ -S "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh" ]; then
		export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh"
	elif have ssh-agent; then
		exec ssh-agent ~/.xinitrc "$@" || exit
	fi
fi

if [ ! "$DBUS_SESSION_BUS_ADDRESS" ]; then
	if [ -S "$XDG_RUNTIME_DIR/bus" ]; then
		export DBUS_SESSION_BUS_ADDRESS="$XDG_RUNTIME_DIR/bus"
	elif have dbus-run-session; then
		exec dbus-run-session ~/.xinitrc "$@" || exit
	elif have dbus-launch; then
		exec dbus-launch --exit-with-session ~/.xinitrc "$@" || exit
	fi
fi

dbus-update-activation-environment --systemd DISPLAY XAUTHORITY

# load global profile

[ -f /etc/profile ]	&& . /etc/profile
[ -f ~/.profile ]	&& . ~/.profile

# initial appearance

bg_color='#222222'
bg_image=~/lib/dotfiles/gui/noise.png

xsetroot -solid "$bg_color" -cursor_name 'left_ptr'
have hsetroot && hsetroot -solid "$bg_color" -tile "$bg_image"

# normalize command line (expand aliases)

case $1 in
	cinnamon)	set -- cinnamon-session;;
	e|e17)		set -- enlightenment_start -i-really-know-what-i-am-doing-and-accept-full-responsibility-for-it;;
	gnome)		set -- gnome-session;;
	kde)		set -- startkde;;
	mate)		set -- mate-session;;
	xfce)		set -- startxfce4;;
esac

# set $DESKTOP_SESSION (for .xprofile and others)

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

# load X11-specific profile

[ -f /etc/xprofile ]	&& . /etc/xprofile
[ -f ~/.xprofile ]	&& . ~/.xprofile
[ -f ~/.Xresources ]	&& xrdb -merge ~/.Xresources
[ -f ~/.Xkbmap ]	&& setxkbmap $(cat ~/.Xkbmap)

# run the session

if [ "$*" ]; then
	exec "$@"
else
	exec openbox --startup ~/.config/openbox/autostart
	#exec openbox-session
fi
