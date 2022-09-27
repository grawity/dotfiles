# vim: ft=sh

# Brick red
#fmts[a]="38;5;203"
#fmts[b]="38;5;167"
#fmts[c]="38;5;131"
#fmts[d]="38;5;95"
#fmts[e]="38;5;59"
#fmts[f]="38;5;23"

# Purple
fmts[a]="38;5;171"
fmts[b]="38;5;177|1"
fmts[c]="38;5;176"
fmts[d]="38;5;133|2"

fmts[name.self]=@b
fmts[name:pfx]=@d
fmts[prompt]=@d
items[name:pfx]='</'
items[name:sfx]='/>'

fmts[pwd]=@c
fmts[pwd:pfx]=@d
# Orange-ish
#fmts[pwd]='38;5;180'
#fmts[pwd:pfx]='38;5;137|2'
items[pwd:pfx]='['
items[pwd:sfx]=']'

# Neutral gray
fmts[vcs]='38;5;59'
