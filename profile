#!bash
[ "$DEBUG" ] && echo "++ profile [arg0=$0]"

. ~/lib/dotfiles/environ

case $0 in -*)
	test -d ~/.cache || mkdir -p -m 0700 ~/.cache
	
	test -f ~/.hushlogin && motd -q

	echo `uptime`
	;;
esac

if [ "$BASH" ] && [ -r ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -f ~/.profile-$HOSTNAME ]; then
	. ~/.profile-$HOSTNAME
fi

true
