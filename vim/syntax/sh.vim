" Vim syntax file
" Language:		shell (sh) Korn shell (ksh) bash (sh)
" Maintainer:		Charles E. Campbell  <NdrOchipS@PcampbellAfamily.Mbiz>
" Previous Maintainer:	Lennart Schultz <Lennart.Schultz@ecmwf.int>
" Last Change:		Nov 14, 2012
" Version:		128
" URL:		http://mysite.verizon.net/astronaut/vim/index.html#vimlinks_syntax
" For options and settings, please use:      :help ft-sh-syntax
" This file includes many ideas from ?ric Brunet (eric.brunet@ens.fr)

" For version 5.x: Clear all syntax items {{{1
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" AFAICT "." should be considered part of the iskeyword.  Using iskeywords in
" syntax is dicey, so the following code permits the user to
"  g:sh_isk set to a string	: specify iskeyword.
"  g:sh_noisk exists	: don't change iskeyword
"  g:sh_noisk does not exist	: (default) append "." to iskeyword
if exists("g:sh_isk") && type(g:sh_isk) == 1	" user specifying iskeyword
 exe "setl isk=".g:sh_isk
elseif !exists("g:sh_noisk")		" optionally prevent appending '.' to iskeyword
 setl isk+=.
endif

" trying to answer the question: which shell is /bin/sh, really?
" If the user has not specified any of g:is_kornshell, g:is_bash, g:is_posix, g:is_sh, then guess.
if !exists("g:is_kornshell") && !exists("g:is_bash") && !exists("g:is_posix") && !exists("g:is_sh")
 if executable("/bin/sh")
  if     resolve("/bin/sh") =~ 'bash$'
   let g:is_bash= 1
  elseif resolve("/bin/sh") =~ 'ksh$'
   let g:is_ksh = 1
  endif
 elseif executable("/usr/bin/sh")
  if     resolve("/usr/bin//sh") =~ 'bash$'
   let g:is_bash= 1
  elseif resolve("/usr/bin//sh") =~ 'ksh$'
   let g:is_ksh = 1
  endif
 endif
endif

" handling /bin/sh with is_kornshell/is_sh {{{1
" b:is_sh is set when "#! /bin/sh" is found;
" However, it often is just a masquerade by bash (typically Linux)
" or kornshell (typically workstations with Posix "sh").
" So, when the user sets "g:is_bash", "g:is_kornshell",
" or "g:is_posix", a b:is_sh is converted into b:is_bash/b:is_kornshell,
" respectively.
if !exists("b:is_kornshell") && !exists("b:is_bash")
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
  else
    let b:is_sh= 1
  endif
endif

" set up default g:sh_fold_enabled {{{1
if !exists("g:sh_fold_enabled")
 let g:sh_fold_enabled= 0
elseif g:sh_fold_enabled != 0 && !has("folding")
 let g:sh_fold_enabled= 0
 echomsg "Ignoring g:sh_fold_enabled=".g:sh_fold_enabled."; need to re-compile vim for +fold support"
endif
if !exists("s:sh_fold_functions")
 let s:sh_fold_functions= and(g:sh_fold_enabled,1)
endif
if !exists("s:sh_fold_heredoc")
 let s:sh_fold_heredoc  = and(g:sh_fold_enabled,2)
endif
if !exists("s:sh_fold_ifdofor")
 let s:sh_fold_ifdofor  = and(g:sh_fold_enabled,4)
endif
if g:sh_fold_enabled && &fdm == "manual"
 " Given that	the	user provided g:sh_fold_enabled
 " 	AND	g:sh_fold_enabled is manual (usual default)
 " 	implies	a desire for syntax-based folding
 setl fdm=syntax
endif

" sh syntax is case sensitive {{{1
syn case match

" Clusters: contains=@... clusters {{{1
"==================================
syn cluster shArithParenList	contains=shArithmetic,shDeref,shDerefSimple,shEscape,shNumber,shOperator,shPosnParm,shExSingleQuote,shExDoubleQuote,shRedir,shSingleQuote,shDoubleQuote,shStatement,shVariable,shAlias,shTest,shCtrlSeq,shSpecial,shParen
syn cluster shArithList	contains=@shArithParenList,shParenError
syn cluster shCaseList	contains=@shCommandSubList,shCommandSub,shComment,shExpr,shHereDoc,shRedir,shSetList,shStatement,shVariable,shCtrlSeq
syn cluster shCommandSubList	contains=shArithmetic,shDeref,shDerefSimple,shEscape,shNumber,shOperator,shPosnParm,shExSingleQuote,shSingleQuote,shExDoubleQuote,shDoubleQuote,shStatement,shVariable,shSubSh,shAlias,shTest,shCtrlSeq,shSpecial,shCmdParenRegion
syn cluster shCurlyList	contains=shNumber,shComma,shDeref,shDerefSimple,shDerefSpecial
syn cluster shDblQuoteList	contains=shCommandSub,shDeref,shDerefSimple,shEscape,shPosnParm,shCtrlSeq,shSpecial
syn cluster shDerefList	contains=shDeref,shDerefSimple,shDerefVar,shDerefSpecial,shDerefWordError,shDerefPPS
syn cluster shDerefVarList	contains=shDerefOp,shDerefVarArray,shDerefOpError
syn cluster shExprList1	contains=shCharClass,shNumber,shOperator,shExSingleQuote,shExDoubleQuote,shSingleQuote,shDoubleQuote,shExpr,shDblBrace,shDeref,shDerefSimple,shCtrlSeq
syn cluster shExprList2	contains=@shExprList1,@shCaseList,shTest
syn cluster shFunctionList	contains=@shCommandSubList,shCommandSub,shComment,shExpr,shHereDoc,shRedir,shSetList,shStatement,shVariable,shOperator,shCtrlSeq
if exists("b:is_kornshell") || exists("b:is_bash")
 syn cluster shFunctionList	add=shDblBrace,shDblParen
endif
syn cluster shHereBeginList	contains=@shCommandSubList
syn cluster shHereList	contains=shBeginHere,shHerePayload
syn cluster shHereListDQ	contains=shBeginHere,@shDblQuoteList,shHerePayload
syn cluster shIdList	contains=shCommandSub,shWrapLineOperator,shDeref,shDerefSimple,shRedir,shExSingleQuote,shExDoubleQuote,shSingleQuote,shDoubleQuote,shExpr,shCtrlSeq,shStringSpecial
syn cluster shIfList	contains=@shLoopList,shDblBrace,shDblParen,shFunctionKey,shFunctionOne,shFunctionTwo
syn cluster shLoopList	contains=@shCaseList,shExpr,shDblBrace,shConditional,shTest,shSet
syn cluster shSubShList	contains=@shCommandSubList,shCommandSub,shComment,shExpr,shRedir,shSetList,shStatement,shVariable,shCtrlSeq,shOperator
syn cluster shTestList	contains=shCharClass,shComment,shCommandSub,shDeref,shDerefSimple,shExDoubleQuote,shDoubleQuote,shExpr,shNumber,shOperator,shExSingleQuote,shSingleQuote,shTest,shCtrlSeq
" Alias: {{{1
" =====
if exists("b:is_kornshell") || exists("b:is_bash")
 syn match shStatement "\<alias\>"
 syn region shAlias matchgroup=shStatement start="\<alias\>\s\+\(\h[-._[:alnum:]]\+\)\@="  skip="\\$" end="\>\|`"
 syn region shAlias matchgroup=shStatement start="\<alias\>\s\+\(\h[-._[:alnum:]]\+=\)\@=" skip="\\$" end="="
endif

" File Redirection Highlighted As Operators: {{{1
"===========================================
syn match      shRedir	"\d\=>\(&[-0-9]\)\="
syn match      shRedir	"\d\=>>-\="
syn match      shRedir	"\d\=<\(&[-0-9]\)\="
syn match      shRedir	"\d<<-\="

" Operators: {{{1
" ==========
syn match   shOperator	"<<\|>>"		contained
syn match   shOperator	"[!&;|]"		contained
syn match   shOperator	"\[[[^:]\|\]]"		contained
syn match   shOperator	"!\=="		skipwhite nextgroup=shPattern
syn match   shPattern	"\<\S\+\())\)\@="	contained contains=shExSingleQuote,shSingleQuote,shExDoubleQuote,shDoubleQuote,shDeref

" Subshells: {{{1
" ==========
syn region shExpr  transparent matchgroup=shExprRegion  start="{" end="}"		contains=@shExprList2 nextgroup=shMoreSpecial
syn region shSubSh transparent matchgroup=shSubShRegion start="[^(]\zs(" end=")"	contains=@shSubShList nextgroup=shMoreSpecial

" Tests: {{{1
"=======
syn region shExpr	matchgroup=shRange start="\[" skip=+\\\\\|\\$\|\[+ end="\]" contains=@shTestList,shSpecial
syn region shTest	transparent matchgroup=shStatement start="\<test\s" skip=+\\\\\|\\$+ matchgroup=NONE end="[;&|]"me=e-1 end="$" contains=@shExprList1
if exists("b:is_kornshell") || exists("b:is_bash")
 syn region  shDblBrace matchgroup=Delimiter start="\[\[" skip=+\\\\\|\\$+ end="\]\]"	contains=@shTestList
 syn region  shDblParen matchgroup=Delimiter start="((" skip=+\\\\\|\\$+ end="))"	contains=@shTestList
endif

" Character Class In Range: {{{1
" =========================
syn match   shCharClass	contained	"\[:\(backspace\|escape\|return\|xdigit\|alnum\|alpha\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|tab\):\]"

" Loops: do, if, while, until {{{1
" ======
syn region shCurlyIn   contained	matchgroup=Delimiter start="{" end="}" contains=@shCurlyList
syn match  shComma     contained	","

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
syn region shCommandSub matchgroup=shCmdSubRegion start="\$("  skip='\\\\\|\\.' end=")"  contains=@shCommandSubList
if exists("b:is_kornshell") || exists("b:is_bash")
 syn region shArithmetic matchgroup=shArithRegion  start="\$((" skip='\\\\\|\\.' end="))" contains=@shArithList
 syn region shArithmetic matchgroup=shArithRegion  start="\$\[" skip='\\\\\|\\.' end="\]" contains=@shArithList
 syn match  shSkipInitWS contained	"^\s\+"
endif
syn region shCmdParenRegion matchgroup=shCmdSubRegion start="(" skip='\\\\\|\\.' end=")"	contains=@shCommandSubList

" String And Character Constants: {{{1
"================================
syn match   shNumber	"-\=\<\d\+\>#\="
syn match   shCtrlSeq	"\\\d\d\d\|\\[abcfnrtv0]"		contained
if exists("b:is_bash")
 syn match   shSpecial	"\\\o\o\o\|\\x\x\x\|\\c[^"]\|\\[abefnrtv]"	contained
endif
if exists("b:is_bash")
 syn region  shExSingleQuote	matchgroup=shQuote start=+\$'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial,shSpecial
 syn region  shExDoubleQuote	matchgroup=shQuote start=+\$"+ skip=+\\\\\|\\.\|\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial,shSpecial
elseif !exists("g:sh_no_error")
 syn region  shExSingleQuote	matchGroup=Error start=+\$'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial
 syn region  shExDoubleQuote	matchGroup=Error start=+\$"+ skip=+\\\\\|\\.+ end=+"+	contains=shStringSpecial
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
syn keyword	shTodo	contained		COMBAK FIXME TODO XXX
syn match	shComment		"^\s*\zs#.*$"	contains=@shCommentGroup
syn match	shComment		"\s\zs#.*$"	contains=@shCommentGroup
syn match	shComment	contained	"#.*$"	contains=@shCommentGroup
syn match	shQuickComment	contained	"#.*$"

" Here Documents: {{{1
" =========================================
if version < 600
 syn region shHereDoc matchgroup=shRedir start="<<\s*\**END[a-zA-Z_0-9]*\**"  matchgroup=shRedir end="^END[a-zA-Z_0-9]*$" contains=@shDblQuoteList
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\**END[a-zA-Z_0-9]*\**" matchgroup=shRedir end="^\s*END[a-zA-Z_0-9]*$" contains=@shDblQuoteList
 syn region shHereDoc matchgroup=shRedir start="<<\s*\**EOF\**"	matchgroup=shRedir	end="^EOF$"	contains=@shDblQuoteList
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\**EOF\**" matchgroup=shRedir	end="^\s*EOF$"	contains=@shDblQuoteList
 syn region shHereDoc matchgroup=shRedir start="<<\s*\**\.\**"	matchgroup=shRedir	end="^\.$"	contains=@shDblQuoteList
 syn region shHereDoc matchgroup=shRedir start="<<-\s*\**\.\**"	matchgroup=shRedir	end="^\s*\.$"	contains=@shDblQuoteList

elseif s:sh_fold_heredoc
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
if exists("b:is_bash") || (exists("b:is_kornshell") && !exists("g:is_posix"))
 syn match shRedir "<<<"	skipwhite	nextgroup=shCmdParenRegion
endif

" Identifiers: {{{1
"=============
syn match  shVariable	"\<\([bwglsav]:\)\=[a-zA-Z0-9.!@_%+,]*\ze="	nextgroup=shSetIdentifier
syn match  shSetIdentifier	"="		contained	nextgroup=shCmdParenRegion,shPattern,shDeref,shDerefSimple,shDoubleQuote,shExDoubleQuote,shSingleQuote,shExSingleQuote
if exists("b:is_bash")
 syn region shSetList oneline matchgroup=shSet start="\<\(declare\|typeset\|local\|export\|unset\)\>\ze[^/]" end="$"	matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+#\|=" contains=@shIdList
 syn region shSetList oneline matchgroup=shSet start="\<set\>\ze[^/]" end="\ze[;|)]\|$"			matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+=" contains=@shIdList
elseif exists("b:is_kornshell")
 syn region shSetList oneline matchgroup=shSet start="\<\(typeset\|export\|unset\)\>\ze[^/]" end="$"		matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]" contains=@shIdList
 syn region shSetList oneline matchgroup=shSet start="\<set\>\ze[^/]" end="$"				matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]" contains=@shIdList
else
 syn region shSetList oneline matchgroup=shSet start="\<\(set\|export\|unset\)\>\ze[^/]" end="$"		matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]" contains=@shIdList
endif

" Functions: {{{1
if !exists("g:is_posix")
 syn keyword shFunctionKey function	skipwhite skipnl nextgroup=shFunctionTwo
endif

if exists("b:is_bash")
 if s:sh_fold_functions
  syn region shFunctionOne fold	matchgroup=shFunction start="^\s*\h[-a-zA-Z_0-9]*\s*()\_s*{"	end="}"	contains=@shFunctionList			skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
  syn region shFunctionTwo fold	matchgroup=shFunction start="\h[-a-zA-Z_0-9]*\s*\%(()\)\=\_s*{"	end="}"	contains=shFunctionKey,@shFunctionList contained	skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
 else
  syn region shFunctionOne	matchgroup=shFunction start="^\s*\h[-a-zA-Z_0-9]*\s*()\_s*{"	end="}"	contains=@shFunctionList
  syn region shFunctionTwo	matchgroup=shFunction start="\h[-a-zA-Z_0-9]*\s*\%(()\)\=\_s*{"	end="}"	contains=shFunctionKey,@shFunctionList contained
 endif
else
 if s:sh_fold_functions
  syn region shFunctionOne fold	matchgroup=shFunction start="^\s*\h\w*\s*()\_s*{" end="}"	contains=@shFunctionList			skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
  syn region shFunctionTwo fold	matchgroup=shFunction start="\h\w*\s*\%(()\)\=\_s*{"	end="}"	contains=shFunctionKey,@shFunctionList contained	skipwhite skipnl nextgroup=shFunctionStart,shQuickComment
 else
  syn region shFunctionOne	matchgroup=shFunction start="^\s*\h\w*\s*()\_s*{"	end="}"	contains=@shFunctionList
  syn region shFunctionTwo	matchgroup=shFunction start="\h\w*\s*\%(()\)\=\_s*{"	end="}"	contains=shFunctionKey,@shFunctionList contained
 endif
endif

" Parameter Dereferencing: {{{1
" ========================
syn match  shDerefSimple	"\$\%(\k\+\|\d\)"
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

" Arithmetic Parenthesized Expressions: {{{1
syn region shParen matchgroup=shArithRegion start='[^$]\zs(\%(\ze[^(]\|$\)' end=')' contains=@shArithParenList

" Synchronization: {{{1
" ================
if !exists("sh_minlines")
  let sh_minlines = 200
endif
if !exists("sh_maxlines")
  let sh_maxlines = 2 * sh_minlines
endif
exec "syn sync minlines=" . sh_minlines . " maxlines=" . sh_maxlines

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
hi def link shEmbeddedEcho	shString
hi def link shEscape	shCommandSub
hi def link shExDoubleQuote	shDoubleQuote
hi def link shExSingleQuote	shSingleQuote
hi def link shFunction	Function
hi def link shHereDoc	shString
hi def link shHerePayload	shHereDoc
hi def link shLoop	shStatement
hi def link shMoreSpecial	shSpecial
hi def link shPattern	shString
hi def link shParen	shArithmetic
hi def link shPosnParm	shShellVariables
hi def link shQuickComment	shComment
hi def link shRange	shOperator
hi def link shRedir	shOperator
hi def link shSetListDelim	shOperator
hi def link shSingleQuote	shString
hi def link shStringSpecial	shSpecial
hi def link shSubShRegion	shOperator
hi def link shVariable	shSetList
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
 hi def link shCondError		Error
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
hi def link shNumber		Number
hi def link shOperator		Operator
hi def link shSet		Statement
hi def link shSetList		Identifier
hi def link shShellVariables		PreProc
hi def link shSpecial		Special
hi def link shStatement		Statement
hi def link shString		String
hi def link shTodo		Todo
hi def link shAlias		Identifier

" Set Current Syntax: {{{1
" ===================
if exists("b:is_bash")
 let b:current_syntax = "bash"
elseif exists("b:is_kornshell")
 let b:current_syntax = "ksh"
else
 let b:current_syntax = "sh"
endif

" vim: ts=16 fdm=marker
