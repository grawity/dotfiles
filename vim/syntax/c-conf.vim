runtime! syntax/conf.vim

setl commentstring=#\ %s
setl foldmethod=expr
setl foldexpr=getline(v:lnum)=~'^.*{$'?'a1':(getline(v:lnum)=~'^\\s*}\\?$'?'s1':-1)
setl foldlevel=999

syn region	confCComment	start=+^\s*/\*+ end=+\*/+
syn region	confCComment	start=+\s/\*+ end=+\*/+
syn region	confCComment	start=+^\s*//+ end=+$+
syn region	confCComment	start=+\s//+ end=+$+
hi def link	confCComment	Comment
syn sync	ccomment	confCComment
syn sync	minlines=100

syn match	confSection	/[{}(),;]/
hi def link	confSection	Delimiter

syn match	confOperator	/=/
hi def link	confOperator	Operator
