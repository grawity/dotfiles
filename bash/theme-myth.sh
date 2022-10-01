# vim: ft=sh

# Brick red
#fmts[a]="38;5;203"
#fmts[b]="38;5;167"
#fmts[c]="38;5;131"
#fmts[d]="38;5;95"
#fmts[e]="38;5;59"
#fmts[f]="38;5;23"

# Purple
fmts[a]="38;5;225"
fmts[b]="38;5;182|1"
fmts[c]="38;5;139"
fmts[d]="38;5;96"

fmts[name.self]=@b
fmts[prompt]=@name
items[name:pfx]='</'
items[name:sfx]='/>'

fmts[pwd]=@c
# Orange-ish
#fmts[pwd]='38;5;180'
#fmts[pwd:pfx]='38;5;137|2'
items[pwd:pfx]='['
items[pwd:sfx]=']'

fmts[vcs]=@d

# Neutral gray
#fmts[vcs]='38;5;59'

# Rearrange things a bit
parts[left]=''
parts[prompt]=':host :prompt _'
items[prompt]='>'
if (( UID == 0 )); then fmts[prompt]=@host; fi
