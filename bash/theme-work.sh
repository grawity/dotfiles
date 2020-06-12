# Boring theme for work servers
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
