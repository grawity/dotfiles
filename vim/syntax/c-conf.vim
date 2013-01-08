runtime! syntax/conf.vim

setl commentstring=#\ %s

syn region	confCComment	start=+^\s*/\*+ end=+\*/+
syn region	confCComment	start=+\s/\*+ end=+\*/+
syn region	confCComment	start=+^\s*//+ end=+$+
syn region	confCComment	start=+\s//+ end=+$+
hi def link	confCComment	Comment
syn sync	ccomment	confCComment
syn sync	minlines=100
