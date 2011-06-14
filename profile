#!/bin/bash
have() { command -v "$@" >& /dev/null; }

localconfig=~/.config/profile-$HOSTNAME.conf
if [ -f "$localconfig" ]; then
	. "$localconfig"
fi

export LOCAL="$HOME/usr"

export PYTHONPATH="$HOME/lib/python:$LOCAL/lib/python"
export PERL5LIB="$HOME/lib/perl5:$LOCAL/lib/perl5"
if [ ! -e "$LOCAL/lib/perl5/prefer-systemwide" ]; then
	export PERL_MM_OPT="INSTALL_BASE='$LOCAL'"
	export PERL_MB_OPT="--install_base '$LOCAL'"
fi
export GEM_HOME="$LOCAL/ruby/gems"

#export PATH="\
#$HOME/bin:\
#$LOCAL/bin:\
#/usr/local/sbin:\
#/usr/local/bin:\
#/usr/sbin:\
#/usr/bin:\
#/usr/pkg/sbin:\
#/usr/pkg/bin:\
#/sbin:\
#/bin:\
#/usr/X11R7/bin:\
#/usr/X11R6/bin:\
#/usr/games:\
#/usr/bin/core_perl:\
#/usr/lib/perl5/site_perl/bin:\
#/usr/lib/perl5/vendor_perl/bin:\
#/usr/lib/perl5/core_perl/bin:\
#/usr/bin/perlbin/vendor:\
#$GEM_HOME/bin:\
#$HOME/.gem/ruby/1.9.1/bin"

PATH="$HOME/bin:$LOCAL/bin:${PATH}:/usr/local/sbin:/usr/sbin:/sbin"

unset LC_ALL

case $TERM in
	vt*|ansi)	export LANG="en_US";;
	*)		export LANG="en_US.utf-8";;
esac

export PAGER='less'
export EDITOR='vim'
unset VISUAL
export BROWSER='open-browser'

export TZ='Europe/Vilnius'
export NAME='Mantas Mikulėnas'
export EMAIL="grawity@nullroute.eu.org"
unset DEBFULLNAME
unset DEBEMAIL

umask 022

run-gpg-agent() {
	local active=false env="$HOME/.cache/gpg-agent.$HOSTNAME.env"

	if ! have gpg-agent; then
		return 1
	elif gpg-agent 2>/dev/null; then
		active=true
	else
		[ -f "$env" ] && . "$env"
	fi

	if $active || gpg-agent 2>/dev/null; then
		# mutt/gpgme requires the envvar
		if [ -z "$GPG_AGENT_INFO" ] && [ -S ~/.gnupg/S.gpg-agent ]; then
			export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent:0:1"
		fi
	else
		eval $(gpg-agent --daemon --use-standard-socket --write-env-file "$env")
	fi
}

run-gpg-agent

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
