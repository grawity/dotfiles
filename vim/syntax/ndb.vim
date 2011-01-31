" http://man.cat-v.org/plan_9/6/ndb

syn match	ndbKey		'[^=[:space:]]\+'
				\ nextgroup=ndbEquals

syn match	ndbFirstKey	'^[^=[:space:]]\+'
				\ nextgroup=ndbEquals

syn match	ndbEquals	contained '='
				\ nextgroup=ndbValue,ndbQuotedValue

syn match	ndbValue	contained '[^[:space:]]\+'
				\ nextgroup=ndbKey

syn region	ndbQuotedValue	contained start=/'/ skip=/''/ end=/'/

syn region	ndbComment	display oneline start=+^#+ end=+$+


hi def link ndbFirstKey		Underlined
hi def link ndbComment		Comment
hi def link ndbKey		Identifier
hi def link ndbEquals		Operator
hi def link ndbValue		String
hi def link ndbQuotedValue	String
