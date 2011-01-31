#!/bin/bash
have() { command -v "$@" >& /dev/null; }

export LOCAL="$HOME/usr"
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
/usr/lib/perl5/site_perl/bin:\
/usr/lib/perl5/vendor_perl/bin:\
/usr/lib/perl5/core_perl/bin:\
/usr/bin/perlbin/vendor:\
$HOME/.gem/ruby/1.9.1/bin"

if [ -d /opt/plan9 ]; then
	export PLAN9=/opt/plan9
	PATH="$PATH:$PLAN9/bin"
fi

export PYTHONPATH="$HOME/lib/python:$LOCAL/lib/python"
export PERL5LIB="$HOME/lib/perl5:$LOCAL/lib/perl5"
export PERL_MM_OPT="INSTALL_BASE='$LOCAL'"
export PERL_MB_OPT="--install_base '$LOCAL'"
export GEM_HOME="$LOCAL/ruby/gems"

case $TERM in
vt*|ansi)
	LANG="en_US";;
*)
	LANG="en_US.utf-8";;
esac
export LANG
unset LC_ALL

umask 022

if [ -z "$GPG_AGENT_INFO" ] && have gpg-agent; then
	# mutt requires GPG_AGENT_INFO despite presence of S.gpg-agent
	env=~/.gnupg/agent.env
	if [ -f "$env" ]; then
		. "$env"
		if gpg-agent 2>/dev/null; then
			export GPG_AGENT_INFO
		else
			unset GPG_AGENT_INFO
		fi
	fi
fi

if [ -t 0 ]; then
	[ -f ~/.hushlogin ] && [ -x ~/code/motd ] && ~/code/motd -q
	echo $(uptime)
fi

if [ "$BASH_VERSION" ]; then
	[ -f ~/.bashrc ] && . ~/.bashrc
fi

rc=~/.profile-$(hostname)
[ -f "$rc" ] && . "$rc"

true
