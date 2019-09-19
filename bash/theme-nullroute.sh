# fallback theme for those *.nullroute.eu.org hosts which DO NOT have their own theme
items[name:pfx]='['
items[name:sfx]=']'
fmts[name:pfx]='38;5;66'
fmts[name.root]='38;5;220'
case $HOSTNAME in
    sky)	fmts[name.self]='38;5;43';;
    star)	fmts[name.self]='38;5;208';;
    river)	fmts[name.self]='38;5;33';;
    wolke)	fmts[name.self]='38;5;204';;
    *)		fmts[name.self]='38;5;109';;
esac
fmts[pwd]='38;5;82'
fmts[pwd:tail]='1|38;5;82'
fmts[vcs]='38;5;197'
fullpwd=h
