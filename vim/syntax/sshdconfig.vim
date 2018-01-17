" Vim syntax file
" Language:	OpenSSH server configuration file (sshd_config)
" Author:	David Necas (Yeti)
" Maintainer:	Dominik Fischer <d dot f dot fischer at web dot de>
" Contributor:	Thilo Six
" Contributor:  Leonard Ehrenfried <leonard.ehrenfried@web.de>	
" Contributor:  Karsten Hopp <karsten@redhat.com>
" Originally:	2009-07-09
" Last Change:	2017 Oct 25
" SSH Version:	7.6p1
"

" Setup
" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case ignore

syn keyword sshdMatch	Host User Group Address nextgroup=sshdValue

syn match sshdValue	/\S\+/

syn match sshdString	/"[^"]\+"/

syn match sshdError	/^\s*\zs.\+$/

syn match sshdComment	/^#.*$/
syn match sshdComment	/\s#.*$/

syn match sshdKeyword	/^\s*\zs\w\+\ze\s\+/ nextgroup=sshdMatch,sshdString,sshdValue

" Define the default highlighting
hi def link sshdError		Error
hi def link sshdComment		Comment
hi def link sshdKeyword		Keyword
hi def link sshdMatch		Type
hi def link sshdValue		Normal
hi def link sshdString		String

let b:current_syntax = "sshdconfig"

" vim:set ts=8 sw=2 sts=2:
