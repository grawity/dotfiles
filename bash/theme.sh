# bashrc -- prompt appearance (color variables)

# Prompt layout:
#
#   {item_name}{reset_pwd}{item_pwd}{reset_vcs}{item_vcs}
#   {item_prompt}
#
#   item_name, item_pwd, and item_vcs are surrounded by *_pfx and *_sfx

# Theme ideas:
#
#  * item_name_pfx="{" item_name_sfx="}" fmt_name_pfx="38;5;42"
#    item_prompt="›" fmt_prompt="1|38;5;42"
#    (with current rain prompt (fmt_name="38;5;82") as base)
#    https://a.pomf.se/yhcplx.png
#
#  * name='1;32' pwd='36' vcs='1;30'
#    (vcs being a dark gray)

unset fullpwd

if (( havecolor )); then
	item_name="${HOSTNAME%%.*}"

	if (( UID == 0 )); then
		item_prompt='#'
	else
		item_prompt='$'
	fi

	if [[ $USER != grawity ]]; then
		item_name="$USER@$item_name"
	fi
fi

# Some domain-based themes

: ${FQDN:=$(fqdn)}
: ${FQDN:=$HOSTNAME}

parts[left]=":name.pfx (root):user (root)>@ :host :name.sfx"

items[:name.pfx]=''
items[:name.sfx]=''

fmts[:name.root]='1;37;41'
fmts[:name.self]='1;32'
fmts[:name.other]='1;33'

if (( UID )); then
	fmts[:name]=@:name.self
else
	fmts[:name]=@:name.root
fi

fmts[:host.pfx]=@:name.pfx
fmts[:host]=@:name

case $FQDN in
    rain.nullroute.eu.org)
	items[:name.pfx]='┌ '
	item_name_pfx='┌ '
	item_prompt='┘'
	fmt_name_pfx='|38;5;236'
	fmt_prompt=$fmt_name_pfx

	fmt_name_root='38;5;231|41'
	fmt_name_self='38;5;82'
	fmt_pwd='38;5;39'
	fmt_pwd_tail='1|38;5;45'
	fmt_vcs='38;5;198'
	;;

    *.nullroute.eu.org)
	items[:name.pfx]='{'
	items[:name.sfx]='}'
	fmts[:name.pfx]='|38;5;66'
	fmts[:name.root]='|38;5;220'
	case $HOSTNAME in
	    sky)	fmts[:name.self]='|38;5;43';;
	    river)	fmts[:name.self]='|38;5;33';;
	    wolke)	fmts[:name.self]='|38;5;204';;
	    *)		fmts[:name.self]='|38;5;109';;
	esac
	fmts[:pwd]='|2|38;5;82'
	fmts[:vcs]='38;5;197'
	fullpwd=h
	;;

    *.cluenet.org|*.nathan7.eu)
	fmt_name_self='1|38;5;71'
	fmt_pwd='38;5;144'
	fmt_vcs='38;5;167'
	;;

    *.utenos-kolegija.lt)
	item_name_pfx="["
	item_name=$HOSTNAME
	item_name_sfx="]"
	if (( UID )); then
		item_prompt='$'
		fmt_name_pfx='|1;32'
		fmt_name=''
	else
		item_prompt='#'
		fmt_name_pfx='|1;31'
		fmt_name='|1'
	fi
	fmt_prompt=$fmt_name_pfx
	fullpwd=y
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
	fmt_pwd='38;5;144'
	fmt_vcs='38;5;167'
	fullpwd=y
	;;

    *)
	item_name_pfx='┌ '
	item_name=$FQDN
	fullpwd=y
	item_prompt='└'
	if (( UID )); then
		fmt_name='38;5;31'
	else
		fmt_name_pfx='38;5;196'
		fmt_name='|48;5;196'
	fi
	fmt_pwd='38;5;76'
	fmt_vcs='38;5;198'
	: ${fmt_name_pfx:=$fmt_name}
	fmt_prompt=$fmt_name_pfx
esac

# Host themes overridden in bashrc-$HOSTNAME
