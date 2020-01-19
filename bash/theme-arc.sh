# vim: ft=sh
# some random theme inspired by /arc
parts[left]=
parts[mid]=
parts[right]=
parts[prompt]=':host :prompt _'
items[prompt]=' sys'
if (( UID )); then
	items[prompt]+='>'
else
	items[prompt]+='#'
fi
fmts[name.self]='48:2:44:44:44;1'
fmts[name.root]='48:2:99:44:44;1'
fmts[prompt]='@name'
fmts[pspace]='@prompt'
fmts[pwd]='@prompt'
