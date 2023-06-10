# Default theme for unknown hosts in unknown domains
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
