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
/usr/local/sbin:\
/usr/local/bin:\
/usr/sbin:\
/usr/bin:\
/usr/pkg/sbin:\
/usr/pkg/bin:\
/sbin:\
/bin:\
/usr/X11R7/bin:\
/usr/X11R6/bin:\
/usr/games:\
/usr/bin/core_perl:\
/usr/lib/perl5/site_perl/bin:\
/usr/lib/perl5/vendor_perl/bin:\
/usr/lib/perl5/core_perl/bin:\
/usr/bin/perlbin/vendor:\
$GEM_HOME/bin:\
$HOME/.gem/ruby/1.9.1/bin"

if [ -d /opt/plan9 ]; then
	export PLAN9=/opt/plan9
	PATH="$PATH:$PLAN9/bin"
fi

case $TERM in
vt*|ansi)
	LANG="en_US";;
*)
	LANG="en_US.utf-8";;
esac
export LANG
unset LC_ALL

export PAGER=less
export EDITOR=vim
unset VISUAL
export BROWSER=open-browser

export TZ=Europe/Vilnius
export NAME='Mantas Mikulėnas'
export EMAIL="grawity@nullroute.eu.org"
unset DEBFULLNAME DEBEMAIL

umask 022

if [ -z "$GPG_AGENT_INFO" ] && have gpg-agent; then
	# mutt requires GPG_AGENT_INFO despite presence of S.gpg-agent
	env=/tmp/env.$LOGNAME@$HOSTNAME.gpg-agent
	if [ -f "$env" ]; then
		. "$env"
		export GPG_AGENT_INFO
		if ! gpg-agent 2>/dev/null; then
			unset GPG_AGENT_INFO
		fi
	fi
fi

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
