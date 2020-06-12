# bashrc -- prompt appearance (color variables)

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

parts[left]=":name:pfx (root)(:user.root):user (!root)(:user.self):user :host :name:sfx"
parts[mid]=":pwd:head :pwd:tail"
parts[right]=":vcs"

items[host]="${HOSTNAME%%.*}"
items[name:pfx]=''
items[name:sfx]=''
items[user:sfx]='@'

items[user.root]=y
items[user.self]=

fmts[host:pfx]=@name:pfx
fmts[host]=@name
fmts[name.root]='1;37;41'
fmts[name.self]='1;32'
fmts[user]=@name

if [[ $LOGNAME != grawity ]]; then
	items[user.self]=y
	fullpwd=y
fi

if (( UID == 0 )); then
	fmts[name]=@name.root
	items[prompt]='#'
else
	fmts[name]=@name.self
	items[prompt]='$'
fi

# Some domain-based themes

: ${FQDN:=$(fqdn)}
: ${FQDN:=$HOSTNAME}

case $FQDN in
    !(vm-*).nullroute.eu.org)
	if [[ -e ~/lib/dotfiles/bash/theme-$HOSTNAME.sh ]]; then
		. ~/lib/dotfiles/bash/theme-$HOSTNAME.sh
	else
		. ~/lib/dotfiles/bash/theme-nullroute.sh
	fi
	;;

    *.utenos-kolegija.lt)
	items[name:pfx]="["
	items[name:sfx]="]"
	fmts[name]=
	if (( UID )); then
		items[prompt]='$'
		fmts[name:pfx]='1;32'
	else
		items[prompt]='#'
		fmts[name:pfx]='1;31'
		fmts[name]='1'
	fi
	fullpwd=y
	;;

    *)
	items[name:pfx]="["
	items[name:sfx]="]"
	fmts[name:pfx]='38;5;242'
	fmts[name.self]='38;5;71'
	fmts[name.root]='38;5;231|41'
	fmts[pwd]='38;5;144'
	fmts[vcs]='38;5;167'
	fullpwd=y
	if [[ $OSTYPE != linux-gnu ]]; then
		parts[left]+=" (:ostype)<:ostype"
		items[ostype]=$OSTYPE
		fmts[ostype]=@name:sfx
	fi
	;;
esac

# Host themes overridden in bashrc-$HOSTNAME
