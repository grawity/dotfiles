#!bash

[ "$DEBUG" ] && echo "++ profile [self=$0]"

# environ

. ~/lib/dotfiles/environ

# login

case $0:$TMUX in -*:)
	test -d ~/.cache || mkdir -p -m 0700 ~/.cache
	
	test -f ~/.hushlogin && motd -q

	echo `uptime`
esac

# local

if [ -f ~/lib/dotfiles/profile-$HOSTNAME ]; then
	. ~/lib/dotfiles/profile-$HOSTNAME
elif [ -f ~/.profile-$HOSTNAME ]; then
	. ~/.profile-$HOSTNAME
fi

# misc

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

true
