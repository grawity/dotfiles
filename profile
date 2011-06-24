#!/bin/bash
have() { command -v "$1" >/dev/null; }

: ${HOSTNAME:=`hostname`}
: ${UID:=`id -u`}

export LOCAL="$HOME/usr"

export PYTHONPATH="$HOME/lib/python:$LOCAL/lib/python"
export PERL5LIB="$HOME/lib/perl5:$LOCAL/lib/perl5"
if [ -e "$LOCAL/lib/perl5/prefer-systemwide" ]; then
	export PERL_CPANM_OPT='--sudo'
else
	export PERL_MM_OPT="INSTALL_BASE='$LOCAL'"
	export PERL_MB_OPT="--install_base '$LOCAL'"
fi
export GEM_HOME="$LOCAL/ruby/gems"

export PATH="\
$HOME/bin:\
$LOCAL/bin:\
$HOME/code/tools:\
$HOME/cluenet/bin:\
${PATH}:\
/usr/local/sbin:\
/usr/sbin:\
/sbin"

export PAGER='less'
export EDITOR='vim'
unset VISUAL
export BROWSER='open-browser'

unset LC_ALL
case $TERM in
	vt*|ansi)	export LANG='en_US';;
	*)		export LANG='en_US.utf-8';;
esac
export TZ='Europe/Vilnius'
export NAME='Mantas Mikulėnas'
export EMAIL='grawity@nullroute.eu.org'

if [ ! -f ~/.mailrc ]; then
	export NAILRC=~/lib/dotfiles/mailrc
fi

umask 022

if [ -t 0 ]; then
	[ -f ~/.hushlogin ] && [ -x ~/code/motd ] && ~/code/motd -q
	echo $(uptime)
fi

rc=~/.profile-$(hostname)
if [ -f "$rc" ]; then
	. "$rc"
fi

if [ "$BASH_VERSION" ] && [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if have klist && klist -5s && have pklist; then
	case `pklist -P` in
		*@CLUENET.ORG|*@NULLROUTE.EU.ORG)
			(k5sshinit -h equal.cluenet.org 2>/dev/null &)
			inc
			;;
	esac
fi

true
