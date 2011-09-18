#!/bin/bash

#[[ -x /usr/sbin/sendmail || -x /usr/lib/sendmail ]] &&
#cat <<-'!'
#	set smtp_url="smtp://grawity@equal.cluenet.org"
#!

#[[ -f ~/.msmtprc ]] &&
#cat <<-'!'
#	set sendmail="msmtp"
#!

[[ "$GPG_AGENT_INFO" ]] &&
cat <<-'!'
	set crypt_use_gpgme
!

[[ -f "/usr/share/doc/mutt/README.Debian" ]] &&
cat <<-'!'
	set xterm_set_titles
!

[[ -f ~/.muttrc-"$HOSTNAME" ]] &&
cat ~/.muttrc-"$HOSTNAME"

exit 0
