# vim: ft=sh

fmts[.orange0]='38;5;166'
fmts[.orange1]='38;5;202'
fmts[.orange2]='38;5;208'
fmts[.orange3]='38;5;214'
fmts[.gray1]='38;5;109'

fmts[name:pfx]='@.gray1'
fmts[name.self]='@.orange3'

items[name:pfx]='*'
items[name:pfx]='(✨'
#items[name:pfx]+=$'\uFE0E'
items[name:sfx]=')'

fmts[pwd]='@.gray1'
fmts[pwd:tail]='@pwd'

fmts[vcs]='@.orange0'

if (( UID == 0 )); then
	fmts[name:pfx]='38;5;9'
	fmts[name.root]='48;5;1'
	fmts[pwd]='@.orange2'
fi
