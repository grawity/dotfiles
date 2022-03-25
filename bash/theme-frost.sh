items[name:pfx]='┌ '
fmts[name:pfx]='38;5;240'
fmts[name.root]='38;5;231|41'
fmts[name.self]='38;5;109|1'
fmts[pwd]='38;5;109'
fmts[pwd:tail]='38;5;152'
fmts[vcs]='38;5;174'
items[prompt]='└'
fmts[prompt]=@name:pfx

# Show username even for non-root
items[user.self]=y
items[user:sfx]=' on '
fmts[user:sfx]=@prompt
fmts[host]=@name.self
