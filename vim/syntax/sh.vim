" Vim syntax file
" Language:		shell (sh) Korn shell (ksh) bash (sh)
" Maintainer:		Charles E. Campbell  <NdrOchipS@PcampbellAfamily.Mbiz>
" Previous Maintainer:	Lennart Schultz <Lennart.Schultz@ecmwf.int>
" Last Change:		Nov 14, 2012
" Version:		128
" URL:		http://mysite.verizon.net/astronaut/vim/index.html#vimlinks_syntax
" For options and settings, please use:      :help ft-sh-syntax
" This file includes many ideas from ?ric Brunet (eric.brunet@ens.fr)

" For version 6.x: Quit when a syntax file was already loaded {{{1
if exists("b:current_syntax")
  finish
endif

" If the shell script itself specifies which shell to use, use it
if getline(1) =~ '\<ksh\>'
 let b:is_kornshell = 1
elseif getline(1) =~ '\<bash\>'
 let b:is_bash      = 1
elseif getline(1) =~ '\<dash\>'
 let b:is_dash      = 1
elseif !exists("g:is_kornshell") && !exists("g:is_bash") && !exists("g:is_posix") && !exists("g:is_sh") && !exists("g:is_dash")
 " user did not specify which shell to use, and 
 " the script itself does not specify which shell to use. FYI: /bin/sh is ambiguous.
 " Assuming /bin/sh is executable, and if its a link, find out what it links to.
 let s:shell = ""
 if executable("/bin/sh")
  let s:shell = resolve("/bin/sh")
 elseif executable("/usr/bin/sh")
  let s:shell = resolve("/usr/bin/sh")
 endif
 if     s:shell =~ '\<ksh\>'
  let b:is_kornshell= 1
 elseif s:shell =~ '\<bash\>'
  let b:is_bash = 1
 elseif s:shell =~ '\<dash\>'
  let b:is_dash = 1
 endif
 unlet s:shell
endif

" handling /bin/sh with is_kornshell/is_sh {{{1
" b:is_sh will be set when "#! /bin/sh" is found;
" However, it often is just a masquerade by bash (typically Linux)
" or kornshell (typically workstations with Posix "sh").
" So, when the user sets "g:is_bash", "g:is_kornshell",
" or "g:is_posix", a b:is_sh is converted into b:is_bash/b:is_kornshell,
" respectively.
if !exists("b:is_kornshell") && !exists("b:is_bash") && !exists("b:is_dash")
  if exists("g:is_posix") && !exists("g:is_kornshell")
   let g:is_kornshell= g:is_posix
  endif
  if exists("g:is_kornshell")
    let b:is_kornshell= 1
    if exists("b:is_sh")
      unlet b:is_sh
    endif
  elseif exists("g:is_bash")
    let b:is_bash= 1
    if exists("b:is_sh")
      unlet b:is_sh
    endif
  elseif exists("g:is_dash")
    let b:is_dash= 1
    if exists("b:is_sh")
      unlet b:is_sh
    endif
  else
    let b:is_sh= 1
  endif
endif

" if b:is_dash, set b:is_posix too
if exists("b:is_dash")
 let b:is_posix= 1
endif

" set up default g:sh_fold_enabled {{{1
if !has("folding")
 let g:sh_fold_functions=0
 let g:sh_fold_heredoc=0
else
 if !exists("g:sh_fold_functions")
  let g:sh_fold_functions=0
 endif
 if !exists("g_sh_fold_heredoc")
  let g:sh_fold_heredoc=0
 endif
endif
if g:sh_fold_functions || g:sh_fold_heredoc
 if &fdm == "manual"
  " Given that	the	user provided g:sh_fold_enabled
  " 	AND	g:sh_fold_enabled is manual (usual default)
  " 	implies	a desire for syntax-based folding
  setl fdm=syntax
 endif
endif

" set up the syntax-highlighting for iskeyword
if (v:version == 704 && has("patch-7.4.1142")) || v:version > 704
 if !exists("g:sh_syntax_isk") || (exists("g:sh_syntax_isk") && g:sh_syntax_isk)
  if exists("b:is_bash")
   exe "syn iskeyword ".&iskeyword.",-,:"
  else
   exe "syn iskeyword ".&iskeyword.",-"
  endif
 endif
endif

" sh syntax is case sensitive {{{1
syn case match

" Clusters: contains=@... clusters {{{1
"==================================
syn cluster shArithList	contains=shArithmetic,shDeref,shDerefSimple,shEscape,shOperator,shPosnParm,shExSingleQuote,shExDoubleQuote,shRedir,shSingleQuote,shDoubleQuote,shStatement,shCtrlSeq,shSpecial,shParen,shParenError
syn cluster shCommandSubList	contains=shArithmetic,shDeref,shDerefSimple,shEscape,@shIfList,shOperator,shPosnParm,shExSingleQuote,shSingleQuote,shExDoubleQuote,shDoubleQuote,shStatement,shSubSh,shCtrlSeq,shSpecial,shCmdParenRegion
syn cluster shDblQuoteList	contains=shCommandSub,shDeref,shDerefSimple,shEscape,shPosnParm,shCtrlSeq,shSpecial
syn cluster shDerefList	contains=shDeref,shDerefSimple,shDerefVar,shDerefSpecial,shDerefWordError,shDerefPPS
syn cluster shDerefVarList	contains=shDerefOp,shDerefVarArray,shDerefOpError
syn cluster shExprList	contains=@shCommandSubList,@shIfList,shCharClass,shCommandSub,shComment,shCtrlSeq,shDeref,shDerefSimple,shDoubleQuote,shExDoubleQuote,shExSingleQuote,shExpr,shExpr,shHereDoc,shOperator,shRedir,shSingleQuote,shStatement
syn cluster shFunctionList	contains=@shCommandSubList,shCommandSub,shComment,shExpr,shHereDoc,shRedir,shStatement,shOperator,shCtrlSeq
syn cluster shIfList	contains=shConditional,shExpr,shFunctionKey,shFunctionOne,shFunctionTwo

" File Redirection Highlighted As Operators: {{{1
"===========================================
syn match      shRedir	"\d\=>\(&[-0-9]\)\="
syn match      shRedir	"\d\=>>-\="
syn match      shRedir	"\d\=<\(&[-0-9]\)\="
syn match      shRedir	"\d<<-\="

" Operators: {{{1
" ==========
syn match   shOperator	"[!&;|]"
syn match   shOperator	"\[[[^]\|\]]"
syn match   shOperator	"[+!]\=="
syn match   shPattern	"\<\S\+\())\)\@="	contained contains=shExSingleQuote,shSingleQuote,shExDoubleQuote,shDoubleQuote,shDeref

" Subshells: {{{1
" ==========
syn region shExpr  transparent matchgroup=shExprRegion  start="{" end="}"		contains=@shExprList nextgroup=shMoreSpecial
syn region shSubSh transparent matchgroup=shExprRegion  start="\(^\|[^(]\)\zs(" end=")"	contains=@shExprList nextgroup=shMoreSpecial

" Character Class In Range: {{{1
" =========================
syn match   shCharClass	contained	"\[:\(backspace\|escape\|return\|xdigit\|alnum\|alpha\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|tab\):\]"

" Case: case...esac {{{1
" ====
if exists("b:is_bash")
 syn region  shCaseRange	matchgroup=Delimiter start=+\[+ skip=+\\\\+ end=+\]+	contained	contains=shCharClass
 syn match   shCharClass	'\[:\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|word\|or\|xdigit\):\]'			contained
else
 syn region  shCaseRange	matchgroup=Delimiter start=+\[+ skip=+\\\\+ end=+\]+	contained
endif
" Misc: {{{1
"======
syn match   shWrapLineOperator "\\$"
syn region  shCommandSub   start="`" skip="\\\\\|\\." end="`"	contains=@shCommandSubList
syn match   shEscape	contained	'\%(\\\\\)*\\.'

" $() and $(()): {{{1
syn region shCommandSub matchgroup=shCmdSubRegion start="\$("  skip='\\\\\|\\.' end=")"  contains=@shFunctionList
if exists("b:is_kornshell") || exists("b:is_bash")
 syn region shArithmetic matchgroup=shArithRegion  start="\$((" skip='\\\\\|\\.' end="))" contains=@shArithList
 syn region shArithmetic matchgroup=shArithRegion  start="(("   skip='\\\\\|\\.' end="))" contains=@shArithList
 syn region shArithmetic matchgroup=shArithRegion  start="\$\[" skip='\\\\\|\\.' end="\]" contains=@shArithList
 syn match  shSkipInitWS contained	"^\s\+"
endif

" String And Character Constants: {{{1
"================================
syn match   shCtrlSeq	"\\\d\d\d\|\\[abcfnrtv0]"		contained
if exists("b:is_bash")
 syn match   shSpecial	"\\\o\o\o\|\\x\x\x\|\\c[^"]\|\\[abefnrtv]"	contained
endif
if exists("b:is_bash")
 syn region  shExSingleQuote	matchgroup=shQuote start=+\$'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial,shSpecial
 syn region  shExDoubleQuote	matchgroup=shQuote start=+\$"+ skip=+\\\\\|\\.\|\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial,shSpecial
elseif !exists("g:sh_no_error")
 syn region  shExSingleQuote	matchgroup=Error start=+\$'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial
 syn region  shExDoubleQuote	matchgroup=Error start=+\$"+ skip=+\\\\\|\\.+ end=+"+	contains=shStringSpecial
endif
syn region  shSingleQuote	matchgroup=shQuote start=+'+ end=+'+		contains=@Spell
syn region  shDoubleQuote	matchgroup=shQuote start=+\%(\%(\\\\\)*\\\)\@<!"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial,@Spell
"syn region  shDoubleQuote	matchgroup=shQuote start=+"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial,@Spell
syn match   shStringSpecial	"[^[:print:] \t]"	contained
syn match   shStringSpecial	"\%(\\\\\)*\\[\\"'`$()#]"
syn match   shSpecial	"[^\\]\zs\%(\\\\\)*\\[\\"'`$()#]" nextgroup=shMoreSpecial,shComment
syn match   shSpecial	"^\%(\\\\\)*\\[\\"'`$()#]"	nextgroup=shComment
syn match   shMoreSpecial	"\%(\\\\\)*\\[\\"'`$()#]" nextgroup=shMoreSpecial contained

" Comments: {{{1
"==========
syn cluster	shCommentGroup	contains=shTodo,@Spell
syn keyword	shTodo	contained		FIXME TODO XXX
syn match	shComment		"^\s*\zs#.*$"	contains=@shCommentGroup
syn match	shComment		"\s\zs#.*$"	contains=@shCommentGroup
syn match	shComment		"[();&|]\zs#.*$"
			\	contains=@shCommentGroup
syn match	shComment	contained	"#.*$"	contains=@shCommentGroup
syn match	shQuickComment	contained	"#.*$"

" Here Documents: {{{1
" =========================================
if g:sh_fold_heredoc
 syn region shHereDoc matchgroup=shRedir fold start="<<\s*\z([^ \t|]*\)"		matchgroup=shRedir end="^\z1\s*$"	contains=@shDblQuoteList
 syn region shHereDoc matchgroup=shRedir fold start="<<\s*\"\z([^ \t|]*\)\""		matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<\s*'\z([^ \t|]*\)'"		matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<-\s*\z([^ \t|]*\)"		matchgroup=shRedir end="^\s*\z1\s*$"	contains=@shDblQuoteList
 syn region shHereDoc matchgroup=shRedir fold start="<<-\s*\"\z([^ \t|]*\)\""		matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<-\s*'\z([^ \t|]*\)'"		matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<\s*\\\_$\_s*\z([^ \t|]*\)"	matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<\s*\\\_$\_s*\"\z([^ \t|]*\)\""	matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<-\s*\\\_$\_s*'\z([^ \t|]*\)'"	matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<-\s*\\\_$\_s*\z([^ \t|]*\)"	matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<-\s*\\\_$\_s*\"\z([^ \t|]*\)\""	matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<\s*\\\_$\_s*'\z([^ \t|]*\)'"	matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir fold start="<<\\\z([^ \t|]*\)"		matchgroup=shRedir end="^\z1\s*$"

else
 syn region shHereDoc matchgroup=shRedir start="<<\s*\\\=\z([^ \t|]*\)"		matchgroup=shRedir end="^\z1\s*$"    contains=@shDblQuoteList
 syn region shHereDoc matchgroup=shRedir start="<<\s*\"\z([^ \t|]*\)\""		matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\z([^ \t|]*\)"		matchgroup=shRedir end="^\s*\z1\s*$" contains=@shDblQuoteList
 syn region shHereDoc matchgroup=shRedir start="<<-\s*'\z([^ \t|]*\)'"		matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<\s*'\z([^ \t|]*\)'"		matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\"\z([^ \t|]*\)\""		matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<\s*\\\_$\_s*\z([^ \t|]*\)"		matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\\\_$\_s*\z([^ \t|]*\)"		matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\\\_$\_s*'\z([^ \t|]*\)'"		matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<\s*\\\_$\_s*'\z([^ \t|]*\)'"		matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<\s*\\\_$\_s*\"\z([^ \t|]*\)\""	matchgroup=shRedir end="^\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\\\_$\_s*\"\z([^ \t|]*\)\""	matchgroup=shRedir end="^\s*\z1\s*$"
 syn region shHereDoc matchgroup=shRedir start="<<\\\z([^ \t|]*\)"		matchgroup=shRedir end="^\z1\s*$"
endif

" Here Strings: {{{1
" =============
" available for: bash; ksh (really should be ksh93 only) but not if its a posix
if exists("b:is_bash") || (exists("b:is_kornshell") && !exists("b:is_posix"))
 syn match shRedir "<<<"	skipwhite
endif

" Functions: {{{1
if g:sh_fold_functions
 syn region shFunctionOne fold	matchgroup=shFunction start="^\s*\h[^[:space:];]+*\s*()\_s*{"	end="}"	contains=@shFunctionList			skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
 syn region shFunctionTwo fold	matchgroup=shFunction start="\h[^[:space:];]*\s*\%(()\)\_s*{"	end="}"	contains=shFunctionKey,@shFunctionList contained	skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
else
 syn region shFunctionOne	matchgroup=shFunction start="^\s*\h[^[:space:];]*\s*()\_s*{"	end="}"	contains=@shFunctionList
 syn region shFunctionTwo	matchgroup=shFunction start="\h*[^[:space:];]\s*\%(()\)\_s*{"	end="}"	contains=shFunctionKey,@shFunctionList contained
endif

" Parameter Dereferencing: {{{1
" ========================
syn match  shDerefSimple	"\$\%(\w\+\|\d\)"
syn region shDeref	matchgroup=PreProc start="\${" end="}"	contains=@shDerefList,shDerefVarArray
if !exists("g:sh_no_error")
 syn match  shDerefWordError	"[^}$[]"	contained
endif
syn match  shDerefSimple	"\$[-#*@!?]"
syn match  shDerefSimple	"\$\$"
if exists("b:is_bash") || exists("b:is_kornshell")
 syn region shDeref	matchgroup=PreProc start="\${##\=" end="}"	contains=@shDerefList
 syn region shDeref	matchgroup=PreProc start="\${\$\$" end="}"	contains=@shDerefList
endif

" bash: ${!prefix*} and ${#parameter}: {{{1
" ====================================
if exists("b:is_bash")
 syn region shDeref	matchgroup=PreProc start="\${!" end="\*\=}"	contains=@shDerefList,shDerefOp
 syn match  shDerefVar	contained	"{\@<=!\k\+"		nextgroup=@shDerefVarList
endif

syn match  shDerefSpecial	contained	"{\@<=[-*@?0]"		nextgroup=shDerefOp,shDerefOpError
syn match  shDerefSpecial	contained	"\({[#!]\)\@<=[[:alnum:]*@_]\+"	nextgroup=@shDerefVarList,shDerefOp
syn match  shDerefVar	contained	"{\@<=\k\+"		nextgroup=@shDerefVarList

" sh ksh bash : ${var[... ]...}  array reference: {{{1
syn region  shDerefVarArray   contained	matchgroup=shDeref start="\[" end="]"	contains=@shCommandSubList nextgroup=shDerefOp,shDerefOpError

" Special ${parameter OPERATOR word} handling: {{{1
" sh ksh bash : ${parameter:-word}    word is default value
" sh ksh bash : ${parameter:=word}    assign word as default value
" sh ksh bash : ${parameter:?word}    display word if parameter is null
" sh ksh bash : ${parameter:+word}    use word if parameter is not null, otherwise nothing
"    ksh bash : ${parameter#pattern}  remove small left  pattern
"    ksh bash : ${parameter##pattern} remove large left  pattern
"    ksh bash : ${parameter%pattern}  remove small right pattern
"    ksh bash : ${parameter%%pattern} remove large right pattern
"        bash : ${parameter^pattern}  Case modification
"        bash : ${parameter^^pattern} Case modification
"        bash : ${parameter,pattern}  Case modification
"        bash : ${parameter,,pattern} Case modification
syn cluster shDerefPatternList	contains=shDerefPattern,shDerefString
if !exists("g:sh_no_error")
 syn match shDerefOpError	contained	":[[:punct:]]"
endif
syn match  shDerefOp	contained	":\=[-=?]"	nextgroup=@shDerefPatternList
syn match  shDerefOp	contained	":\=+"	nextgroup=@shDerefPatternList
if exists("b:is_bash") || exists("b:is_kornshell")
 syn match  shDerefOp	contained	"#\{1,2}"	nextgroup=@shDerefPatternList
 syn match  shDerefOp	contained	"%\{1,2}"	nextgroup=@shDerefPatternList
 syn match  shDerefPattern	contained	"[^{}]\+"	contains=shDeref,shDerefSimple,shDerefPattern,shDerefString,shCommandSub,shDerefEscape nextgroup=shDerefPattern
 syn region shDerefPattern	contained	start="{" end="}"	contains=shDeref,shDerefSimple,shDerefString,shCommandSub nextgroup=shDerefPattern
 syn match  shDerefEscape	contained	'\%(\\\\\)*\\.'
endif
if exists("b:is_bash")
 syn match  shDerefOp	contained	"[,^]\{1,2}"	nextgroup=@shDerefPatternList
endif
syn region shDerefString	contained	matchgroup=shDerefDelim start=+\%(\\\)\@<!'+ end=+'+		contains=shStringSpecial
syn region shDerefString	contained	matchgroup=shDerefDelim start=+\%(\\\)\@<!"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial
syn match  shDerefString	contained	"\\["']"	nextgroup=shDerefPattern

if exists("b:is_bash")
 " bash : ${parameter:offset}
 " bash : ${parameter:offset:length}
 syn region shDerefOp	contained	start=":[$[:alnum:]_]"me=e-1 end=":"me=e-1 end="}"me=e-1 contains=@shCommandSubList nextgroup=shDerefPOL
 syn match  shDerefPOL	contained	":[^}]\+"	contains=@shCommandSubList

 " bash : ${parameter//pattern/string}
 " bash : ${parameter//pattern}
 syn match  shDerefPPS	contained	'/\{1,2}'	nextgroup=shDerefPPSleft
 syn region shDerefPPSleft	contained	start='.'	skip=@\%(\\\\\)*\\/@ matchgroup=shDerefOp	end='/' end='\ze}' nextgroup=shDerefPPSright contains=@shCommandSubList
 syn region shDerefPPSright	contained	start='.'	skip=@\%(\\\\\)\+@		end='\ze}'	contains=@shCommandSubList
endif

" Synchronization: {{{1
" ================
if !exists("g:sh_minlines")
 let s:sh_minlines = 200
else
 let s:sh_minlines= g:sh_minlines
endif
if !exists("g:sh_maxlines")
 let s:sh_maxlines = 2*s:sh_minlines
 if s:sh_maxlines < 25
  let s:sh_maxlines= 25
 endif
else
 let s:sh_maxlines= g:sh_maxlines
endif
exec "syn sync minlines=" . s:sh_minlines . " maxlines=" . s:sh_maxlines

" Default Highlighting: {{{1
" =====================
hi def link shArithRegion	shShellVariables
hi def link shBeginHere	shRedir
hi def link shQuote	shOperator
hi def link shCmdSubRegion	shShellVariables
hi def link shDerefOp	shOperator
hi def link shDerefPOL	shDerefOp
hi def link shDerefPPS	shDerefOp
hi def link shDeref	shShellVariables
hi def link shDerefDelim	shOperator
hi def link shDerefSimple	shDeref
hi def link shDerefSpecial	shDeref
hi def link shDerefString	shDoubleQuote
hi def link shDerefVar	shDeref
hi def link shDoubleQuote	shString
hi def link shEscape	shCommandSub
hi def link shExDoubleQuote	shDoubleQuote
hi def link shExSingleQuote	shSingleQuote
hi def link shFunction	Function
hi def link shHereDoc	shString
hi def link shMoreSpecial	shSpecial
hi def link shPattern	shString
hi def link shParen	shArithmetic
hi def link shPosnParm	shShellVariables
hi def link shQuickComment	shComment
hi def link shRange	shOperator
hi def link shRedir	shOperator
hi def link shSingleQuote	shString
hi def link shStringSpecial	shSpecial
hi def link shWrapLineOperator	shOperator

if exists("b:is_bash")
  hi def link shFunctionParen		Delimiter
  hi def link shFunctionDelim		Delimiter
  hi def link shCharClass		shSpecial
endif
if exists("b:is_kornshell")
  hi def link shFunctionParen		Delimiter
endif

if !exists("g:sh_no_error")
 hi def link shDerefError		Error
 hi def link shDerefOpError		Error
 hi def link shDerefWordError		Error
endif

hi def link shArithmetic		Special
hi def link shCharClass		Identifier
hi def link shSnglCase		Statement
hi def link shCommandSub		Special
hi def link shComment		Comment
hi def link shConditional		Conditional
hi def link shCtrlSeq		Special
hi def link shExprRegion		Delimiter
hi def link shFunctionKey		Function
hi def link shFunctionName		Function
hi def link shOperator		Operator
hi def link shShellVariables		PreProc
hi def link shSpecial		Special
hi def link shStatement		Statement
hi def link shString		String
hi def link shTodo		Todo

" Set Current Syntax: {{{1
" ===================
if exists("b:is_bash")
 let b:current_syntax = "bash"
elseif exists("b:is_kornshell")
 let b:current_syntax = "ksh"
elseif exists("b:is_posix")
 let b:current_syntax = "posix"
else
 let b:current_syntax = "sh"
endif

" vim: ts=16 fdm=marker
