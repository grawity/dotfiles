# bashrc -- prompt appearance (color variables)

# Prompt layout:
#
#   {item_name}{reset_pwd}{item_pwd}{reset_vcs}{item_vcs}
#   {item_prompt}
#
#   item_name, item_pwd, and item_vcs are surrounded by *_pfx and *_sfx

unset ${!fmt_*} ${!item_*} ${!reset_*} fullpwd

reset_pwd=' '
reset_vcs=' '

fmt_noop='28' # "Visible (not hidden)"

if (( havecolor )); then
	_hostname=${HOSTNAME%%.*}

	if (( UID == 0 )); then
		fmt_name='1;37;41'
		item_name="$_hostname"
		item_prompt='#'
	elif [[ $USER == "grawity" ]]; then
		if (( havecolor == 256 )); then
			fmt_name='1|38;5;71'
		else
			fmt_name='1;32'
		fi
		item_name="$_hostname"
		item_prompt='$'
	else
		fmt_name='1;33'
		item_name="$USER@$_hostname"
		item_prompt='$'
	fi

	unset _hostname

	if _is_remote; then
		item_prompt='^'
	fi

	if (( havecolor == 256 )); then
		fmt_pwd='38;5;144'
		fmt_pwd_tail='1;4'
		fmt_vcs='38;5;167'
	else
		fmt_pwd='33'
		fmt_pwd_tail='1'
		fmt_vcs='1;31'
	fi
fi

# Some domain-based themes

: ${FQDN:=$(fqdn)}
: ${FQDN:=$HOSTNAME}

case $FQDN in
    rain.nullroute.eu.org|*.cluenet.org|*.nathan7.eu)
	;;

    *.nullroute.eu.org)
	item_name_pfx='┌ '
	item_prompt='┘'
	fmt_name_pfx='|38;5;236'
	fmt_prompt=$fmt_name_pfx

	if (( UID )); then
		fmt_name='38;5;82'
	else
		fmt_name='38;5;231|41'
	fi
	fmt_pwd='38;5;39'
	fmt_pwd_tail='1|38;5;45'
	fmt_vcs='38;5;202'
	;;

    *.core|*.rune)
	item_name_pfx="["
	item_name=$FQDN
	item_name_sfx="] $OSTYPE"
	fmt_name_pfx='|38;5;242'
	if (( UID )); then
		fmt_name='38;5;71'
	else
		fmt_name='38;5;231|41'
	fi
	fullpwd=y
	;;

    *)
	item_name_pfx='┌ '
	item_name=$FQDN
	fullpwd=y
	item_prompt='└'

	if (( havecolor == 256 )); then
		if (( UID )); then
			fmt_name='38;5;31'
		else
			fmt_name_pfx='38;5;196'
			fmt_name='|48;5;196'
		fi
		fmt_pwd='38;5;76'
		fmt_vcs='38;5;198'
	else
		if (( UID )); then
			fmt_name='36'
		else
			fmt_name='1;31'
		fi
		fmt_pwd='32'
		fmt_vcs='1;35'
	fi

	: ${fmt_name_pfx:=$fmt_name}
	fmt_prompt=$fmt_name_pfx
esac

# Host themes overridden in bashrc-$HOSTNAME

# Theme ideas: name='1;32' pwd='36' vcs='1;30'
#              (vcs being a dark gray)
