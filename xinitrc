#!/bin/sh
# ~/.xinitrc - `xinit`/`startx` startup script

have() { type "$1" > /dev/null 2>&1; }

bg_color='#222222'
bg_image=~/.dotfiles/gui/noise.png
default_session='openbox'

cd ~

# Run ssh-agent
if [ ! "$SSH_AUTH_SOCK" ] && have ssh-agent; then
	exec ssh-agent ~/.xinitrc "$@" || exit
fi

# Prepare D-Bus
if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
	dbus-update-activation-environment --systemd DISPLAY XAUTHORITY
elif have dbus-run-session; then
	exec dbus-run-session ~/.xinitrc "$@" || exit
elif have dbus-launch; then
	exec dbus-launch --exit-with-session ~/.xinitrc "$@" || exit
fi

# Load common profile
[ -f /etc/profile ]	&& . /etc/profile
[ -f ~/.profile ]	&& . ~/.profile

# Set background color
if have xsetroot; then
	xsetroot -solid "$bg_color" -cursor_name 'left_ptr'
fi

# Set background image
if have hsetroot; then
	hsetroot -solid "$bg_color" -tile "$bg_image" &
fi

# Decide on the session command
[ "$1" ] || set -- $default_session
case $1 in
	e)		set -- enlightenment_start \
			-i-really-know-what-i-am-doing-and-accept-full-responsibility-for-it;;
	gnome)		set -- gnome-session;;
	kde)		set -- startkde;;
	mate)		set -- mate-session;;
	openbox)	set -- openbox --startup ~/.config/openbox/autostart;;
	xfce)		set -- xfce4-session;;
	custom)		set -- ~/.xsession;;
esac

# Tell ~/.xprofile about the session type
case $1 in
	gnome-session)		DESKTOP_SESSION=gnome;;
	enlightenment_start)	DESKTOP_SESSION=enlightenment;;
	mate-session)		DESKTOP_SESSION=mate;;
	startkde)		DESKTOP_SESSION=kde-plasma;;
	xfce4-session)		DESKTOP_SESSION=xfce;;
	xterm)			DESKTOP_SESSION=xterm;;
esac
export DESKTOP_SESSION

# Load X-specific profile
[ -f /etc/xprofile ]	&& . /etc/xprofile
[ -f ~/.xprofile ]	&& . ~/.xprofile
[ -f ~/.Xresources ]	&& xrdb -merge ~/.Xresources &
[ -f ~/.Xkbmap ]	&& setxkbmap $(cat ~/.Xkbmap) &

# Run the command
exec "$@"
