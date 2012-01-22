setl noai nosi cms= fo-=c fo-=r

syn region	qdbComment	display oneline start=+^#+ end=+$+
syn region	qdbSeparator	display oneline start=+^%+ end=+$+

"syn region	qdbNick		display oneline start=+^<+ end=+>+

hi def link qdbComment		Comment
hi def link qdbSeparator	Title
