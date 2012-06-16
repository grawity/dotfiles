setl noai nosi cms= fo-=c fo-=r

syn region	qdbHeader	start=+\%^+ end=+^%$+ transparent
syn region	qdbComment	display oneline start=+^#+ end=+$+ containedin=qdbHeader
syn region	qdbSeparator	display oneline start=+^%+ end=+$+

syn match	qdbNick		/^<[ +%&@!~]\?[^ ]\+>/
syn match	qdbNick		/^([ +%&@!~]\?[^ ]\+)/
syn match	qdbNick		/^\[[ +%&@!~]\?[^ ]\+\]/
syn match	qdbAction	/^\s*\*.*/

hi def link qdbComment		Comment
hi def link qdbSeparator	Label
hi def link qdbNick		Statement
hi def link qdbAction		Function
