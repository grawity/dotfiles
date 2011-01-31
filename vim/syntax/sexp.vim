syn clear

syn match	sexpError		/\S/ contained

"yn region	sexpList		start=/(/ end=/)/ contains=TOP,sexpParens
"yn cluster	sexpString		contains=sexpQuoted,sexpBase64,sexpHex
syn region	sexpQuoted		start=/"/ skip=/\\\\\|\\"/ end=/"/  contains=sexpSpecial
syn match	sexpSpecial		/\\\([btvfrn'"]\|$\)/ contained
syn match	sexpSpecial		/\\\(x\x\{2}\|\o\{3\}\)/ contained
syn region	sexpTransport	start=/{/ end=/}/ contains=sexpDelim,sexpB64Char,sexpError keepend
syn region	sexpBase64		start=/|/ end=/|/ contains=sexpDelim,sexpB64Char,sexpError keepend
syn region	sexpHex			start=/#/ end=/#/ contains=sexpDelim,sexpHexChar,sexpError keepend
syn match	sexpB64Char		#[A-Za-z0-9+/=]# contained
syn match	sexpHexChar		/[0-9A-Fa-f]/ contained
syn match	Comment			/^;.*$/

syn match	sexpDelim		/[{}#|]/ contained
syn match	sexpParens		/[()]/

"syn match	sexpToken	/[[:alpha:].\/_:*+=-][[:alnum:].\/_:*+=-]*/


hi def link sexpError		Error
hi def link sexpTransport	String
"i def link sexpToken		Identifier
hi def link sexpQuoted		String
hi def link sexpBase64		String
hi def link sexpB64Char		String
hi def link sexpHex			String
hi def link sexpHexChar		String
hi def link sexpDelim		Delimiter
hi def link sexpParens		Delimiter
hi def link sexpSpecial		Special

syn sync fromstart
