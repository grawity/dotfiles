syn clear muttrcSpamPattern
syn region muttrcSpamPattern	contained skipwhite keepend start=+'+ skip=+\\'+ end=+'+ contains=muttrcRXString nextgroup=muttrcString,muttrcStringNL
syn region muttrcSpamPattern	contained skipwhite keepend start=+"+ skip=+\\"+ end=+"+ contains=muttrcRXString nextgroup=muttrcString,muttrcStringNL
syn keyword muttrcVarStr	contained skipwhite imap_oauth_refresh_command smtp_oauth_refresh_command
