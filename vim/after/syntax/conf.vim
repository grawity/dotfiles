syn region	confCComment	start=+^\s*/\*+ end=+\*/+
hi def link	confCComment	Comment
syn sync	ccomment	confCComment
