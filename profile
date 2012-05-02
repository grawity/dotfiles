#!/bin/sh

setpath() { local IFS=":" var="$1"; shift; export "$var=$*"; }

[ "$UID" ]	|| export UID=$(id -u)
[ "$HOSTNAME" ]	|| export HOSTNAME=$(hostname)

umask 022

# Locations

LOCAL="$HOME/.local"

setpath PATH \
	"$HOME/bin"		\
	"$HOME/code/bin"	\
	"$LOCAL/bin"		\
	"$PATH"			\
	"/usr/local/sbin" 	\
	"/usr/sbin"		\
	"/sbin"			;

setpath PYTHONPATH \
	"$LOCAL/lib/python"	\
	"$HOME/code/lib/python"	;

setpath PERL5LIB \
	"$LOCAL/lib/perl5"	\
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

[ -f ~/.profile-$HOSTNAME ] && . ~/.profile-$HOSTNAME

if [ "$LOCAL_PERL" = "n" ]; then
	export PERL_CPANM_OPT='--sudo'
else
	export PERL_MM_OPT="INSTALL_BASE='$LOCAL'"
	export PERL_MB_OPT="--install_base '$LOCAL'"
fi

: # return a true value
