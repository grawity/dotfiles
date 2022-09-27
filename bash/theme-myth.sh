# vim: ft=sh
fullpwd=h

fmts[a]="38;5;203"
fmts[b]="38;5;167"
fmts[c]="38;5;131"
fmts[d]="38;5;95"
fmts[e]="38;5;59"
fmts[f]="38;5;23"

#fmts[a]="38;5;171"
#fmts[b]="38;5;177"
#fmts[c]="38;5;176"
#fmts[d]="38;5;181"
#fmts[e]="38;5;180"
#fmts[f]="38;5;179"

fmts[name.self]=@a
fmts[pwd]=@c
fmts[vcs]=@e

fmts[name:pfx]=@d
fmts[prompt]=@d

if (( UID )); then
	items[user:sfx]=' on '
	items[host:pfx]='</'
	items[host:sfx]='/>'
	#fmts[host:pfx]=@name
	#fmts[host:sfx]=@name
fi
