#!/bin/bash

if [[ -f ~/.config/msmtp/config || -f ~/.msmtprc ]]; then
	echo 'set sendmail="msmtp"'
fi

if [[ -d ~/.cache/mutt ]]; then
	echo 'set header_cache="~/.cache/mutt"'
	echo 'set message_cachedir="~/.cache/mutt"'
fi

if [[ -f ~/.mailcap ]]; then
	printf 'auto_view %s\n' \
		application/{zip,x-zip-compressed} \
		application/tlsrpt+gzip \
		text/{html,x-vcard} ;
fi

if [[ -f ~/.config/mutt/muttrc-"$HOSTNAME" ]]; then
	echo "source \"~/.config/mutt/muttrc-$HOSTNAME\""
elif [[ -f ~/.muttrc-"$HOSTNAME" ]]; then
	echo "source \"~/.muttrc-$HOSTNAME\""
fi

exit 0
