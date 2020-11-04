# bashrc -- prompt appearance (color variables)

# Theme ideas:
#
#  * item_name_pfx="{" item_name_sfx="}" fmt_name_pfx="38;5;42"
#    item_prompt="›" fmt_prompt="1|38;5;42"
#    (with current rain prompt (fmt_name="38;5;82") as base)
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

dir=${BASH_SOURCE[0]%/*}
case $FQDN in
    !(vm-*).nullroute.eu.org)
	if [[ -e $dir/theme-$HOSTNAME.sh ]]; then
		. $dir/theme-$HOSTNAME.sh
	else
		. $dir/theme-nullroute.sh
	fi
	;;

    *.utenos-kolegija.lt)
	. $dir/theme-work.sh
	;;

    *)
	#. $dir/theme-old.sh
	. $dir/theme-default.sh
	;;
esac
unset dir

# Host themes overridden in bashrc-$HOSTNAME
