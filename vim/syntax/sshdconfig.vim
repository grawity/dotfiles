" Vim syntax file
" Language:	OpenSSH server configuration file (sshd_config)
" Maintainer:	David Necas (Yeti)
" Maintainer:   Leonard Ehrenfried <leonard.ehrenfried@web.de>	
" Modified By:	Thilo Six
" Originally:	2009-07-09
" Last Change:	2011 Oct 31 
" SSH Version:	5.9p1
"

" Setup
if version >= 600
  if exists("b:current_syntax")
    finish
  endif
else
  syntax clear
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
if version >= 508 || !exists("did_sshdconfig_syntax_inits")
  if version < 508
    let did_sshdconfig_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink sshdError	    Error
  HiLink sshdComment        Comment
  HiLink sshdKeyword        Keyword
  HiLink sshdMatch          Type
  HiLink sshdValue	    Normal
  HiLink sshdString	    String
  delcommand HiLink
endif

let b:current_syntax = "sshdconfig"

" vim:set ts=8 sw=2 sts=2:
