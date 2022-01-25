# Indicate whether I'm switched to the work Kerberos cache.

_uk_kerberos_prompt() {
	if [[ $KRB5CCNAME == *_ukad ]]; then
		items[uk.show]=y
		if klist -s; then
			fmts[uk]=@uk.good
		else
			fmts[uk]=@uk.bad
		fi
	else
		items[uk.show]=
	fi
}

items[uk]=' UK '
items[uk:sfx]=' '

fmts[uk.good]='1|38;2;255;203;0|48;2;21;44;112'
#fmts[uk.bad]='9;91'
fmts[uk.bad]='1;9|38;2;255;203;0'
fmts[uk:sfx]='0'

parts[left]=${parts[left]/ /' (:uk.show):uk '}

PROMPT_COMMAND+=(_uk_kerberos_prompt)
