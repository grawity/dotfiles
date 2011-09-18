#!/bin/bash

[[ "$GPG_AGENT_INFO" ]] &&
cat <<-'!'
	set crypt_use_gpgme
!

[[ -f "/usr/share/doc/mutt/README.Debian" ]] &&
cat <<-'!'
	set xterm_set_titles
!

exit 0
