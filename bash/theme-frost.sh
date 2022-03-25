bright="38;5;153"
normal="38;5;110"

items[name:pfx]='┌ '
items[prompt]='└'
fmts[name:pfx]='38;5;240'
fmts[prompt]=@name:pfx

fmts[name.self]="$normal"
fmts[host]="$bright"
fmts[pwd]="$normal"
fmts[pwd:tail]="$bright"
fmts[vcs]="38;5;174"

items[pwd:head:pfx]='['
items[pwd:tail:sfx]=']'
fmts[pwd:head:pfx]=@name:pfx
fmts[pwd:tail:sfx]=@pwd:head:pfx
#fullpwd=y

# Show username even for non-root
items[user.self]=y
items[user:sfx]=' on '
fmts[user:sfx]=@prompt

unset bright
unset normal
