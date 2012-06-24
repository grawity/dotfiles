#!bash
[ "$DEBUG" ]	&& echo "++ profile [self=$0]"

[ "$USER" ]	|| export USER=$(id -un)
[ "$UID" ]	|| export UID=$(id -u)
[ "$HOSTNAME" ]	|| export HOSTNAME=$(hostname)

. ~/lib/dotfiles/environ

case $0 in -*)
	if [ ! -d ~/.cache ]; then
		mkdir -p -m 0700 ~/.cache
	fi
	
	[ -f ~/.hushlogin ] && motd -q
	echo `uptime`
	;;
esac

if [ "$BASH_VERSION" ]; then
	[ -f ~/.bashrc ] && . ~/.bashrc
fi

if [ -f ~/.profile-$HOSTNAME ]; then
	. ~/.profile-$HOSTNAME
fi

true
