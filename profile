#!/bin/sh

setpath() { local IFS=":" var="$1"; shift; export "$var=$*"; }

[ "$UID" ]	|| export UID=$(id -u)
[ "$HOSTNAME" ]	|| export HOSTNAME=$(hostname)

umask 022

# Locations

export PREFIX="$HOME/.local"

setpath PATH \
	"$HOME/bin"		\
	"$HOME/code/bin"	\
	"$PREFIX/bin"		\
	"$PATH"			\
	"/usr/local/sbin" 	\
	"/usr/sbin"		\
	"/sbin"			;

setpath PYTHONPATH \
	"$PREFIX/lib/python"	\
	"$HOME/code/lib/python"	;

setpath PERL5LIB \
	"$PREFIX/lib/perl5"	\
	"$HOME/code/lib/perl5"	;

if [ ! -d ~/.cache ]; then
	mkdir -p -m 0700 ~/.cache
fi

# Preferred programs

export PAGER='less'
export EDITOR='vim'
unset VISUAL
export BROWSER='web-browser'

# Program defaults

export TZ='Europe/Vilnius'
export NAME='Mantas Mikulėnas'
export EMAIL='grawity@nullroute.eu.org'

case $TERM in
	vt*|ansi)
		export LANG='en_US';;
	*)
		export LANG='en_US.UTF-8';;
esac

unset LC_ALL

# System information

if [ -t 0 ]; then
	[ -f ~/.hushlogin ] && motd -q
	echo `uptime`
fi

# bashrc

if [ "$BASH_VERSION" ]; then
	[ -f ~/.bashrc ] && . ~/.bashrc
fi

# Local settings

if [ -f ~/lib/dotfiles/profile-$HOSTNAME ]; then
	. ~/lib/dotfiles/profile-$HOSTNAME
elif [ -f ~/.profile-$HOSTNAME ]; then
	. ~/.profile-$HOSTNAME
fi

if [ "$LOCAL_PERL" = "n" ]; then
	export PERL_CPANM_OPT='--sudo'
else
	export PERL_MM_OPT="INSTALL_BASE='$PREFIX'"
	export PERL_MB_OPT="--install_base '$PREFIX'"
fi

: # return a true value
