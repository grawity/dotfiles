# Indicate whether I'm switched to the work Kerberos cache.

if [[ ${items@a} != *A* ]]; then
	return
fi

_uk_kerberos_prompt() {
	if [[ $KRB5CCNAME == *_uk ]]; then
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

PROMPT_COMMAND+="${PROMPT_COMMAND+; }_uk_kerberos_prompt"

items[uk]=' UK '
fmts[uk.good]='1|38;2;255;203;0|48;2;21;44;112'
#fmts[uk.bad]='9;91'
fmts[uk.bad]='1;9|38;2;255;203;0'
case $HOSTNAME in
	ember)
		# Insert after host, before path
		parts[left]+=' (:uk.show)<:uk';;
	frost)
		# Insert before user@host
		parts[left]=${parts[left]/ /' (:uk.show)>:uk '};;
	*)
		# Insert after host, before path
		parts[left]+=' (:uk.show)<:uk';;
esac
