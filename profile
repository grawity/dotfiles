#!/bin/bash
have() { command -v "$@" >& /dev/null; }


export LOCAL="$HOME/usr"

export PYTHONPATH="$HOME/lib/python:$LOCAL/lib/python"
export PERL5LIB="$HOME/lib/perl5:$LOCAL/lib/perl5"
if [ ! -e "$LOCAL/lib/perl5/prefer-systemwide" ]; then
	export PERL_MM_OPT="INSTALL_BASE='$LOCAL'"
	export PERL_MB_OPT="--install_base '$LOCAL'"
fi
export GEM_HOME="$LOCAL/ruby/gems"

export PATH="\
$HOME/bin:\
$LOCAL/bin:\
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

true
