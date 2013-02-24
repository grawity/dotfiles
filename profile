#!sh

. ~/lib/dotfiles/environ

case $0:$TMUX:$SILENT in -*::)
	# only for -sh/-bash, not in tmux, and not if $SILENT

	test -d ~/.cache || mkdir -p -m 0700 ~/.cache
	
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
