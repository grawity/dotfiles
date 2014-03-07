# ~/.profile - sh/bash login script
# vim: ft=sh

. ~/lib/dotfiles/environ

case $0:$TMUX:$SILENT in -*::)
	# only in login shells, not in tmux, and not if $SILENT

	# assume that XDG variables are set by ~/.environ
	test -d "$XDG_CACHE_HOME"  || mkdir -p -m 0700 "$XDG_CACHE_HOME"
	test -d "$XDG_CONFIG_HOME" || mkdir -p -m 0700 "$XDG_CONFIG_HOME"
	test -d "$XDG_DATA_HOME"   || mkdir -p -m 0700 "$XDG_DATA_HOME"

	test -f ~/.hushlogin && motd -q

	echo `uptime`
esac

if [ -f ~/lib/dotfiles/profile-$HOSTNAME ]; then
	. ~/lib/dotfiles/profile-$HOSTNAME
elif [ -f ~/.profile-$HOSTNAME ]; then
	. ~/.profile-$HOSTNAME
fi

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

true
