#!/bin/sh
# ~/.xinitrc -- startup script for xinit/startx/sx

have() { type "$1" > /dev/null 2>&1; }

bg_color='#222222'
bg_image=~/.dotfiles/gui/noise.png

cd ~

# Ensure ssh-agent is available (for D-Bus as well)
if [ ! "$SSH_AUTH_SOCK" ] && have ssh-agent; then
	exec ssh-agent "$0" "$@" || exit
fi

# Ensure D-Bus session bus is available
if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
	dbus-update-activation-environment --systemd DISPLAY XAUTHORITY
elif have dbus-run-session; then
	exec dbus-run-session "$0" "$@" || exit
elif have dbus-launch; then
	exec dbus-launch --exit-with-session "$0" "$@" || exit
fi

# Load common profile
# XXX: Is this needed? Consider that xinit is usually invoked from shells anyway
#[ -f /etc/profile ]	&& . /etc/profile
#[ -f ~/.profile ]	&& . ~/.profile

# Set background color
if have xsetroot; then
	xsetroot -solid "$bg_color" -cursor_name 'left_ptr'
fi
if have hsetroot; then
	hsetroot -solid "$bg_color" -tile "$bg_image" &
fi

# Aliases for common session commands
[ "$*" ] || set -- ${SX_DEFAULT_SESSION:-xterm}
case $* in
	e)		set -- enlightenment_start \
			-i-really-know-what-i-am-doing-and-accept-full-responsibility-for-it;;
	gnome)		set -- gnome-session;;
	kde)		set -- startkde;;
	mate)		set -- mate-session;;
	openbox)	set -- openbox --startup ~/.config/openbox/autostart;;
	xfce)		set -- xfce4-session;;
	custom)		set -- ~/.xsession;;
	*)		;;
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
[ "$HOSTNAME" ]		|| HOSTNAME=$(hostname)
[ -f /etc/xprofile ]	&& . /etc/xprofile
[ -f ~/.xprofile ]	&& . ~/.xprofile
[ -f ~/.Xresources ]	&& xrdb -merge ~/.Xresources
[ -f ~/.Xkbmap ]	&& setxkbmap $(cat ~/.Xkbmap)

# Start the WM
"$@"
