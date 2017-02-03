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
parts[mid]=":pwd:head :pwd:body :pwd:tail"
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
    frost.nullroute.eu.org)
	items[name:pfx]='┌ '
	fmts[name:pfx]='38;5;236'
	fmts[name.root]='38;5;231|41'
	fmts[name.self]='38;5;109'
	fmts[pwd]='38;5;65'
	fmts[pwd:tail]='38;5;108'
	fmts[vcs]='38;5;131'
	items[prompt]='┘'
	fmts[prompt]=@name:pfx
	;;

    rain.nullroute.eu.org)
	items[name:pfx]='┌ '
	fmts[name:pfx]='38;5;236'
	fmts[name.root]='38;5;231|41'
	fmts[name.self]='38;5;82'
	fmts[pwd]='38;5;39'
	fmts[pwd:tail]='1|38;5;45'
	fmts[vcs]='38;5;198'
	items[prompt]='┘'
	fmts[prompt]=@name:pfx
	;;

    *.nullroute.eu.org)
	items[name:pfx]='['
	items[name:sfx]=']'
	fmts[name:pfx]='38;5;66'
	fmts[name.root]='38;5;220'
	case $HOSTNAME in
	    sky)	fmts[name.self]='38;5;43';;
	    river)	fmts[name.self]='38;5;33';;
	    wolke)	fmts[name.self]='38;5;204';;
	    *)		fmts[name.self]='38;5;109';;
	esac
	fmts[pwd]='38;5;82'
	fmts[pwd:tail]='1|38;5;82'
	fmts[vcs]='38;5;197'
	fullpwd=h
	;;

    *.cluenet.org|*.nathan7.eu)
	items[user:sfx]=' @ '
	if (( UID )); then
		fmts[user:sfx]='38;5;252'
	fi
	fmts[name.self]='1|38;5;71'
	fmts[pwd]='38;5;144'
	fmts[vcs]='38;5;167'
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
	if [[ $LOGNAME == mantas ]]; then
		unset items[user.self]
	fi
	fullpwd=y
	;;

    *)
	parts[left]+=" (:ostype)<:ostype"
	items[name:pfx]="["
	items[name:sfx]="]"
	items[ostype]=$OSTYPE
	fmts[name:pfx]='38;5;242'
	fmts[name.self]='38;5;71'
	fmts[name.root]='38;5;231|41'
	fmts[ostype]=@name:sfx
	fmts[pwd]='38;5;144'
	fmts[vcs]='38;5;167'
	fullpwd=y
	;;
esac

# Host themes overridden in bashrc-$HOSTNAME
