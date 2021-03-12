# ~/.profile - sh/bash login script
# vim: ft=sh

. ~/.dotfiles/environ

have() { type "$1" >/dev/null 2>&1; }

case $0:$TMUX:$SILENT in -*::)
	test -d "$XDG_CACHE_HOME"  || mkdir -p -m 0700 "$XDG_CACHE_HOME"
	test -d "$XDG_CONFIG_HOME" || mkdir -p -m 0700 "$XDG_CONFIG_HOME"
	test -d "$XDG_DATA_HOME"   || mkdir -p -m 0700 "$XDG_DATA_HOME"
	test -f ~/.hushlogin && motd -q
	echo `uptime`
esac

if [ -f ~/.dotfiles/profile-$HOSTNAME ]; then
	. ~/.dotfiles/profile-$HOSTNAME
elif [ -f ~/.profile-$HOSTNAME ]; then
	. ~/.profile-$HOSTNAME
fi

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

true
