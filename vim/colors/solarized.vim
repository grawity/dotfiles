" Originally based on:
" Name:     Solarized vim colorscheme
" Author:   Ethan Schoonover <es@ethanschoonover.com>
" URL:      http://ethanschoonover.com/solarized
"           (see this url for latest release & screenshots)
" License:  OSI approved MIT license (see end of this file)
" Created:  In the middle of the night
" Modified: 2011 May 05

" Default option values
if !exists("g:solarized_bold")
	let g:solarized_bold = 1
endif
if !exists("g:solarized_underline")
	let g:solarized_underline = 1
endif
if !exists("g:solarized_italic")
	let g:solarized_italic = 1
endif
if !exists("g:solarized_contrast")
	let g:solarized_contrast = "normal"
endif
if !exists("g:solarized_visibility")
	let g:solarized_visibility = "normal"
endif
if !exists("g:solarized_diffmode")
	let g:solarized_diffmode = "normal"
endif

" Colorscheme initialization
hi clear
if exists("syntax_on")
	syntax reset
endif
let colors_name = "solarized"

" Direct truecolor mode (for GUI and 'tgc')
let s:gui_base03	= "#002b36"
let s:gui_base02	= "#073642"
let s:gui_base01	= "#586e75"
let s:gui_base00	= "#657b83"
let s:gui_base0		= "#839496"
let s:gui_base1		= "#93a1a1"
let s:gui_base2		= "#eee8d5"
let s:gui_base3		= "#fdf6e3"
let s:gui_yellow	= "#b58900"
let s:gui_orange	= "#cb4b16"
let s:gui_red		= "#dc322f"
let s:gui_magenta	= "#d33682"
let s:gui_violet	= "#6c71c4"
let s:gui_blue		= "#268bd2"
let s:gui_cyan		= "#2aa198"
"let s:gui_green	= "#859900" "original
let s:gui_green		= "#719e07" "experimental

" Indirect 16-color palette (configured at terminal level)
let s:c16_base03	= "8"
let s:c16_base02	= "0"
let s:c16_base01	= "10"
let s:c16_base00	= "11"
let s:c16_base0		= "12"
let s:c16_base1		= "14"
let s:c16_base2		= "7"
let s:c16_base3		= "15"
let s:c16_yellow	= "3"
let s:c16_orange	= "9"
let s:c16_red		= "1"
let s:c16_magenta	= "5"
let s:c16_violet	= "13"
let s:c16_blue		= "4"
let s:c16_cyan		= "6"
let s:c16_green		= "2"

" Indirect, for terminals limited to 8+bold only
if &t_Co < 16
	echo "Ugh"
	let s:c16_base03	= "DarkGray"		" 0*
	let s:c16_base02	= "Black"		" 0
	let s:c16_base01	= "LightGreen"		" 2*
	let s:c16_base00	= "LightYellow"		" 3*
	let s:c16_base0		= "LightBlue"		" 4*
	let s:c16_base1		= "LightCyan"		" 6*
	let s:c16_base2		= "LightGray"		" 7
	let s:c16_base3		= "White"		" 7*
	let s:c16_yellow	= "DarkYellow"		" 3
	let s:c16_orange	= "LightRed"		" 1*
	let s:c16_red		= "DarkRed"		" 1
	let s:c16_magenta	= "DarkMagenta"		" 5
	let s:c16_violet	= "LightMagenta"	" 5*
	let s:c16_blue		= "DarkBlue"		" 4
	let s:c16_cyan		= "DarkCyan"		" 6
	let s:c16_green		= "DarkGreen"		" 2
endif

if &background == "light"
	let s:gui_temp03	= s:gui_base03
	let s:gui_temp02	= s:gui_base02
	let s:gui_temp01	= s:gui_base01
	let s:gui_temp00	= s:gui_base00
	let s:gui_base03	= s:gui_base3
	let s:gui_base02	= s:gui_base2
	let s:gui_base01	= s:gui_base1
	let s:gui_base00	= s:gui_base0
	let s:gui_base0		= s:gui_temp00
	let s:gui_base1		= s:gui_temp01
	let s:gui_base2		= s:gui_temp02
	let s:gui_base3		= s:gui_temp03

	let s:c16_temp03	= s:c16_base03
	let s:c16_temp02	= s:c16_base02
	let s:c16_temp01	= s:c16_base01
	let s:c16_temp00	= s:c16_base00
	let s:c16_base03	= s:c16_base3
	let s:c16_base02	= s:c16_base2
	let s:c16_base01	= s:c16_base1
	let s:c16_base00	= s:c16_base0
	let s:c16_base0		= s:c16_temp00
	let s:c16_base1		= s:c16_temp01
	let s:c16_base2		= s:c16_temp02
	let s:c16_base3		= s:c16_temp03
endif

if g:solarized_contrast == "high"
	let s:gui_base01	= s:gui_base00
	let s:gui_base00	= s:gui_base0
	let s:gui_base0		= s:gui_base1
	let s:gui_base1		= s:gui_base2
	let s:gui_base2		= s:gui_base3

	let s:c16_base01	= s:c16_base00
	let s:c16_base00	= s:c16_base0
	let s:c16_base0		= s:c16_base1
	let s:c16_base1		= s:c16_base2
	let s:c16_base2		= s:c16_base3
endif

let s:gui_none		= "NONE"
let s:c16_none		= "NONE"
let s:gui_back		= s:gui_base03
let s:c16_back		= s:c16_base03

" Highlighting primitives
let s:bg_none		= " guibg=".s:gui_none   ." ctermbg=".s:c16_none
let s:bg_back		= " guibg=".s:gui_back   ." ctermbg=".s:c16_back
let s:bg_base03		= " guibg=".s:gui_base03 ." ctermbg=".s:c16_base03
let s:bg_base02		= " guibg=".s:gui_base02 ." ctermbg=".s:c16_base02
let s:bg_base01		= " guibg=".s:gui_base01 ." ctermbg=".s:c16_base01
let s:bg_base00		= " guibg=".s:gui_base00 ." ctermbg=".s:c16_base00
let s:bg_base0		= " guibg=".s:gui_base0  ." ctermbg=".s:c16_base0
let s:bg_base1		= " guibg=".s:gui_base1  ." ctermbg=".s:c16_base1
let s:bg_base2		= " guibg=".s:gui_base2  ." ctermbg=".s:c16_base2
let s:bg_base3		= " guibg=".s:gui_base3  ." ctermbg=".s:c16_base3
let s:bg_green		= " guibg=".s:gui_green  ." ctermbg=".s:c16_green
let s:bg_yellow		= " guibg=".s:gui_yellow ." ctermbg=".s:c16_yellow
let s:bg_orange		= " guibg=".s:gui_orange ." ctermbg=".s:c16_orange
let s:bg_red		= " guibg=".s:gui_red    ." ctermbg=".s:c16_red
let s:bg_magenta	= " guibg=".s:gui_magenta." ctermbg=".s:c16_magenta
let s:bg_violet		= " guibg=".s:gui_violet ." ctermbg=".s:c16_violet
let s:bg_blue		= " guibg=".s:gui_blue   ." ctermbg=".s:c16_blue
let s:bg_cyan		= " guibg=".s:gui_cyan   ." ctermbg=".s:c16_cyan

let s:fg_none		= " guifg=".s:gui_none   ." ctermfg=".s:c16_none
let s:fg_back		= " guifg=".s:gui_back   ." ctermfg=".s:c16_back
let s:fg_base03		= " guifg=".s:gui_base03 ." ctermfg=".s:c16_base03
let s:fg_base02		= " guifg=".s:gui_base02 ." ctermfg=".s:c16_base02
let s:fg_base01		= " guifg=".s:gui_base01 ." ctermfg=".s:c16_base01
let s:fg_base00		= " guifg=".s:gui_base00 ." ctermfg=".s:c16_base00
let s:fg_base0		= " guifg=".s:gui_base0  ." ctermfg=".s:c16_base0
let s:fg_base1		= " guifg=".s:gui_base1  ." ctermfg=".s:c16_base1
let s:fg_base2		= " guifg=".s:gui_base2  ." ctermfg=".s:c16_base2
let s:fg_base3		= " guifg=".s:gui_base3  ." ctermfg=".s:c16_base3
let s:fg_green		= " guifg=".s:gui_green  ." ctermfg=".s:c16_green
let s:fg_yellow		= " guifg=".s:gui_yellow ." ctermfg=".s:c16_yellow
let s:fg_orange		= " guifg=".s:gui_orange ." ctermfg=".s:c16_orange
let s:fg_red		= " guifg=".s:gui_red    ." ctermfg=".s:c16_red
let s:fg_magenta	= " guifg=".s:gui_magenta." ctermfg=".s:c16_magenta
let s:fg_violet		= " guifg=".s:gui_violet ." ctermfg=".s:c16_violet
let s:fg_blue		= " guifg=".s:gui_blue   ." ctermfg=".s:c16_blue
let s:fg_cyan		= " guifg=".s:gui_cyan   ." ctermfg=".s:c16_cyan

" Formatting options
let s:b			= ",bold"
let s:bb		= ""
let s:i			= ",italic"
let s:u			= ",underline"
let s:c			= ",undercurl"
let s:r			= ",reverse"
let s:s			= ",standout"

if g:solarized_bold == 0 || &t_Co == 8
	let s:b		= ""
	let s:bb	= ",bold"
endif
if g:solarized_underline == 0
	let s:u		= ""
endif
if g:solarized_italic == 0
	let s:i		= ""
endif

let s:fmt_none		= " gui=NONE".        " cterm=NONE".        " term=NONE"
let s:fmt_bold		= " gui=NONE".s:b.    " cterm=NONE".s:b.    " term=NONE".s:b
let s:fmt_bldi		= " gui=NONE".s:b.    " cterm=NONE".s:b.    " term=NONE".s:b
let s:fmt_undr		= " gui=NONE".s:u.    " cterm=NONE".s:u.    " term=NONE".s:u
let s:fmt_undb		= " gui=NONE".s:u.s:b." cterm=NONE".s:u.s:b." term=NONE".s:u.s:b
let s:fmt_undi		= " gui=NONE".s:u.    " cterm=NONE".s:u.    " term=NONE".s:u
let s:fmt_curl		= " gui=NONE".s:c.    " cterm=NONE".s:c.    " term=NONE".s:c
let s:fmt_ital		= " gui=NONE".s:i.    " cterm=NONE".s:i.    " term=NONE".s:i
let s:fmt_stnd		= " gui=NONE".s:s.    " cterm=NONE".s:s.    " term=NONE".s:s
let s:fmt_revr		= " gui=NONE".s:r.    " cterm=NONE".s:r.    " term=NONE".s:r
let s:fmt_revb		= " gui=NONE".s:r.s:b." cterm=NONE".s:r.s:b." term=NONE".s:r.s:b
" revbb (reverse bold for bright colors) is only set to actual bold in low
" color terminals (t_co=8, such as OS X Terminal.app) and should only be used
" with colors 8-15.
let s:fmt_revbb		= " gui=NONE".s:r.s:bb.    " cterm=NONE".s:r.s:bb.    " term=NONE".s:r.s:bb
let s:fmt_revbbu	= " gui=NONE".s:r.s:bb.s:u." cterm=NONE".s:r.s:bb.s:u." term=NONE".s:r.s:bb.s:u

let s:sp_none		= " guisp=".s:gui_none
let s:sp_back		= " guisp=".s:gui_back
let s:sp_base03		= " guisp=".s:gui_base03
let s:sp_base02		= " guisp=".s:gui_base02
let s:sp_base01		= " guisp=".s:gui_base01
let s:sp_base00		= " guisp=".s:gui_base00
let s:sp_base0		= " guisp=".s:gui_base0
let s:sp_base1		= " guisp=".s:gui_base1
let s:sp_base2		= " guisp=".s:gui_base2
let s:sp_base3		= " guisp=".s:gui_base3
let s:sp_green		= " guisp=".s:gui_green
let s:sp_yellow		= " guisp=".s:gui_yellow
let s:sp_orange		= " guisp=".s:gui_orange
let s:sp_red		= " guisp=".s:gui_red
let s:sp_magenta	= " guisp=".s:gui_magenta
let s:sp_violet		= " guisp=".s:gui_violet
let s:sp_blue		= " guisp=".s:gui_blue
let s:sp_cyan		= " guisp=".s:gui_cyan

" Basic highlighting"{{{
" ---------------------------------------------------------------------
" note that link syntax to avoid duplicate configuration doesn't work with the
" exe compiled formats

exe "hi! Normal"	.s:fmt_none	.s:fg_base0	.s:bg_back

exe "hi! Comment"	.s:fmt_ital	.s:fg_base01	.s:bg_none
"	*Comment	any comment

exe "hi! Constant"	.s:fmt_none	.s:fg_cyan	.s:bg_none
"	*Constant	any constant
"	String		a string constant: "this is a string"
"	Character	a character constant: 'c', '\n'
"	Number		a number constant: 234, 0xff
"	Boolean		a boolean constant: TRUE, false
"	Float		a floating point constant: 2.3e10

exe "hi! Identifier"	.s:fmt_none	.s:fg_blue	.s:bg_none
"	*Identifier	any variable name
"	Function	function name (also: methods for classes)
"
exe "hi! Statement"	.s:fmt_none	.s:fg_green	.s:bg_none
"	*Statement	any statement
"	Conditional	if, then, else, endif, switch, etc.
"	Repeat		for, do, while, etc.
"	Label		case, default, etc.
"	Operator	"sizeof", "+", "*", etc.
"	Keyword		any other keyword
"	Exception	try, catch, throw

exe "hi! PreProc"	.s:fmt_none	.s:fg_orange	.s:bg_none
"	*PreProc	generic Preprocessor
"	Include		preprocessor #include
"	Define		preprocessor #define
"	Macro		same as Define
"	PreCondit	preprocessor #if, #else, #endif, etc.

exe "hi! Type"		.s:fmt_none	.s:fg_yellow	.s:bg_none
"	*Type		int, long, char, etc.
"	StorageClass	static, register, volatile, etc.
"	Structure	struct, union, enum, etc.
"	Typedef		A typedef

exe "hi! Special"	.s:fmt_none	.s:fg_red	.s:bg_none
"	*Special	any special symbol
"	SpecialChar	special character in a constant
"	Tag		you can use CTRL-] on this
"	Delimiter	character that needs attention
"	SpecialComment  special things inside a comment
"	Debug		debugging statements

exe "hi! Underlined"	.s:fmt_none	.s:fg_violet	.s:bg_none
"	*Underlined	text that stands out, HTML links

exe "hi! Ignore"	.s:fmt_none	.s:fg_none	.s:bg_none
"	*Ignore		left blank, hidden  |hl-Ignore|

exe "hi! Error"		.s:fmt_bold	.s:fg_red	.s:bg_none
"	*Error		any erroneous construct

exe "hi! Todo"		.s:fmt_bold	.s:fg_magenta	.s:bg_none
"	*Todo		anything that needs extra attention; mostly the
"			keywords TODO FIXME and XXX
"
"}}}
" Extended highlighting "{{{
" ---------------------------------------------------------------------
if g:solarized_visibility == "high"
	exe "hi! SpecialKey"	.s:fmt_revr	.s:fg_red	.s:bg_none
	exe "hi! NonText"	.s:fmt_bold	.s:fg_red	.s:bg_none
elseif g:solarized_visibility == "low"
	exe "hi! SpecialKey"	.s:fmt_bold	.s:fg_base02	.s:bg_none
	exe "hi! NonText"	.s:fmt_bold	.s:fg_base02	.s:bg_none
else
	exe "hi! SpecialKey"	.s:fmt_bold	.s:fg_base00	.s:bg_base02
	exe "hi! NonText"	.s:fmt_bold	.s:fg_base01	.s:bg_none
endif
exe "hi! StatusLine"	.s:fmt_none	.s:fg_base1	.s:bg_base02	.s:fmt_revbb
exe "hi! StatusLineNC"	.s:fmt_none	.s:fg_base00	.s:bg_base02	.s:fmt_revbb
exe "hi! Visual"	.s:fmt_none	.s:fg_base01	.s:bg_base03	.s:fmt_revbb
exe "hi! Directory"	.s:fmt_none	.s:fg_blue	.s:bg_none
exe "hi! ErrorMsg"	.s:fmt_revr	.s:fg_red	.s:bg_none
exe "hi! IncSearch"	.s:fmt_stnd	.s:fg_orange	.s:bg_none
exe "hi! Search"	.s:fmt_revr	.s:fg_yellow	.s:bg_none
exe "hi! MoreMsg"	.s:fmt_none	.s:fg_blue	.s:bg_none
exe "hi! ModeMsg"	.s:fmt_none	.s:fg_blue	.s:bg_none
exe "hi! LineNr"	.s:fmt_none	.s:fg_base01	.s:bg_base02
exe "hi! Question"	.s:fmt_bold	.s:fg_cyan	.s:bg_none
exe "hi! VertSplit"	.s:fmt_none	.s:fg_base00	.s:bg_base00
exe "hi! Title"		.s:fmt_bold	.s:fg_orange	.s:bg_none
exe "hi! VisualNOS"	.s:fmt_stnd	.s:fg_none	.s:bg_base02	.s:fmt_revbb
exe "hi! WarningMsg"	.s:fmt_bold	.s:fg_red	.s:bg_none
exe "hi! WildMenu"	.s:fmt_none	.s:fg_base2	.s:bg_base02	.s:fmt_revbb
exe "hi! Folded"	.s:fmt_undb	.s:fg_base0	.s:bg_base02	.s:sp_base03
exe "hi! FoldColumn"	.s:fmt_none	.s:fg_base0	.s:bg_base02
if g:solarized_diffmode == "high"
	exe "hi! DiffAdd"	.s:fmt_revr	.s:fg_green	.s:bg_none
	exe "hi! DiffChange"	.s:fmt_revr	.s:fg_yellow	.s:bg_none
	exe "hi! DiffDelete"	.s:fmt_revr	.s:fg_red	.s:bg_none
	exe "hi! DiffText"	.s:fmt_revr	.s:fg_blue	.s:bg_none
elseif	g:solarized_diffmode == "low"
	exe "hi! DiffAdd"	.s:fmt_undr	.s:fg_green	.s:bg_none	.s:sp_green
	exe "hi! DiffChange"	.s:fmt_undr	.s:fg_yellow	.s:bg_none	.s:sp_yellow
	exe "hi! DiffDelete"	.s:fmt_bold	.s:fg_red	.s:bg_none
	exe "hi! DiffText"	.s:fmt_undr	.s:fg_blue	.s:bg_none	.s:sp_blue
elseif has("gui_running")
	exe "hi! DiffAdd"	.s:fmt_bold	.s:fg_green	.s:bg_base02	.s:sp_green
	exe "hi! DiffChange"	.s:fmt_bold	.s:fg_yellow	.s:bg_base02	.s:sp_yellow
	exe "hi! DiffDelete"	.s:fmt_bold	.s:fg_red	.s:bg_base02
	exe "hi! DiffText"	.s:fmt_bold	.s:fg_blue	.s:bg_base02	.s:sp_blue
else
	exe "hi! DiffAdd"	.s:fmt_none	.s:fg_green	.s:bg_base02	.s:sp_green
	exe "hi! DiffChange"	.s:fmt_none	.s:fg_yellow	.s:bg_base02	.s:sp_yellow
	exe "hi! DiffDelete"	.s:fmt_none	.s:fg_red	.s:bg_base02
	exe "hi! DiffText"	.s:fmt_none	.s:fg_blue	.s:bg_base02	.s:sp_blue
endif
exe "hi! SignColumn"	.s:fmt_none	.s:fg_base0
exe "hi! Conceal"	.s:fmt_none	.s:fg_blue	.s:bg_none
exe "hi! SpellBad"	.s:fmt_curl	.s:fg_none	.s:bg_none	.s:sp_red
exe "hi! SpellCap"	.s:fmt_curl	.s:fg_none	.s:bg_none	.s:sp_violet
exe "hi! SpellRare"	.s:fmt_curl	.s:fg_none	.s:bg_none	.s:sp_cyan
exe "hi! SpellLocal"	.s:fmt_curl	.s:fg_none	.s:bg_none	.s:sp_yellow
exe "hi! Pmenu"		.s:fmt_none	.s:fg_base0	.s:bg_base02	.s:fmt_revbb
exe "hi! PmenuSel"	.s:fmt_none	.s:fg_base01	.s:bg_base2	.s:fmt_revbb
exe "hi! PmenuSbar"	.s:fmt_none	.s:fg_base2	.s:bg_base0	.s:fmt_revbb
exe "hi! PmenuThumb"	.s:fmt_none	.s:fg_base0	.s:bg_base03	.s:fmt_revbb
exe "hi! TabLine"	.s:fmt_none	.s:fg_base0	.s:bg_base02	.s:sp_base0
exe "hi! TabLineFill"	.s:fmt_none	.s:fg_base0	.s:bg_base02	.s:sp_base0
exe "hi! TabLineSel"	.s:fmt_none	.s:fg_base01	.s:bg_base2	.s:sp_base0	.s:fmt_revbbu
exe "hi! CursorColumn"	.s:fmt_none	.s:fg_none	.s:bg_base02
exe "hi! CursorLine"	.s:fmt_none	.s:fg_none	.s:bg_base02	.s:sp_base1
exe "hi! CursorLineNr"	.s:fmt_none	.s:fg_yellow
exe "hi! ColorColumn"	.s:fmt_none	.s:fg_none	.s:bg_base02
exe "hi! Cursor"	.s:fmt_none	.s:fg_base03	.s:bg_base0
hi! link lCursor Cursor
exe "hi! MatchParen"	.s:fmt_bold	.s:fg_red	.s:bg_base01

"}}}
" vim syntax highlighting "{{{
" ---------------------------------------------------------------------
"exe "hi! vimLineComment"	.s:fg_base01	.s:bg_none	.s:fmt_ital
"hi! link vimComment		Comment
"hi! link vimLineComment	Comment
hi! link vimVar			Identifier
hi! link vimFunc		Function
hi! link vimUserFunc		Function
hi! link helpSpecial		Special
hi! link vimSet			Normal
hi! link vimSetEqual		Normal
exe "hi! vimCommentString"	.s:fmt_none	.s:fg_violet	.s:bg_none
exe "hi! vimCommand"		.s:fmt_none	.s:fg_yellow	.s:bg_none
exe "hi! vimCmdSep"		.s:fmt_bold	.s:fg_blue	.s:bg_none
exe "hi! helpExample"		.s:fmt_none	.s:fg_base1	.s:bg_none
exe "hi! helpOption"		.s:fmt_none	.s:fg_cyan	.s:bg_none
exe "hi! helpNote"		.s:fmt_none	.s:fg_magenta	.s:bg_none
exe "hi! helpVim"		.s:fmt_none	.s:fg_magenta	.s:bg_none
exe "hi! helpHyperTextJump"	.s:fmt_undr	.s:fg_blue	.s:bg_none
exe "hi! helpHyperTextEntry"	.s:fmt_none	.s:fg_green	.s:bg_none
exe "hi! vimIsCommand"		.s:fmt_none	.s:fg_base00	.s:bg_none
exe "hi! vimSynMtchOpt"		.s:fmt_none	.s:fg_yellow	.s:bg_none
exe "hi! vimSynType"		.s:fmt_none	.s:fg_cyan	.s:bg_none
exe "hi! vimHiLink"		.s:fmt_none	.s:fg_blue	.s:bg_none
exe "hi! vimHiGroup"		.s:fmt_none	.s:fg_blue	.s:bg_none
exe "hi! vimGroup"		.s:fmt_undb	.s:fg_blue	.s:bg_none
"}}}
" diff highlighting "{{{
" ---------------------------------------------------------------------
hi! link diffAdded		Statement
hi! link diffLine		Identifier
"}}}
" git & gitcommit highlighting "{{{
"git
"exe "hi! gitDateHeader"
"exe "hi! gitIdentityHeader"
"exe "hi! gitIdentityKeyword"
"exe "hi! gitNotesHeader"
"exe "hi! gitReflogHeader"
"exe "hi! gitKeyword"
"exe "hi! gitIdentity"
"exe "hi! gitEmailDelimiter"
"exe "hi! gitEmail"
"exe "hi! gitDate"
"exe "hi! gitMode"
"exe "hi! gitHashAbbrev"
"exe "hi! gitHash"
"exe "hi! gitReflogMiddle"
"exe "hi! gitReference"
"exe "hi! gitStage"
"exe "hi! gitType"
"exe "hi! gitDiffAdded"
"exe "hi! gitDiffRemoved"
"gitcommit
"exe "hi! gitcommitSummary"
exe "hi! gitcommitComment"	.s:fmt_ital	.s:fg_base01	.s:bg_none
hi! link gitcommitUntracked	gitcommitComment
hi! link gitcommitDiscarded	gitcommitComment
hi! link gitcommitSelected	gitcommitComment
exe "hi! gitcommitUnmerged"	.s:fmt_bold	.s:fg_green	.s:bg_none
exe "hi! gitcommitOnBranch"	.s:fmt_bold	.s:fg_base01	.s:bg_none
exe "hi! gitcommitBranch"	.s:fmt_bold	.s:fg_magenta	.s:bg_none
hi! link gitcommitNoBranch	gitcommitBranch
exe "hi! gitcommitDiscardedType".s:fmt_none	.s:fg_red	.s:bg_none
exe "hi! gitcommitSelectedType"	.s:fmt_none	.s:fg_green	.s:bg_none
"exe "hi! gitcommitUnmergedType"
"exe "hi! gitcommitType"
"exe "hi! gitcommitNoChanges"
"exe "hi! gitcommitHeader"
exe "hi! gitcommitHeader"	.s:fmt_none	.s:fg_base01	.s:bg_none
exe "hi! gitcommitUntrackedFile".s:fmt_bold	.s:fg_cyan	.s:bg_none
exe "hi! gitcommitDiscardedFile".s:fmt_bold	.s:fg_red	.s:bg_none
exe "hi! gitcommitSelectedFile"	.s:fmt_bold	.s:fg_green	.s:bg_none
exe "hi! gitcommitUnmergedFile"	.s:fmt_bold	.s:fg_yellow	.s:bg_none
exe "hi! gitcommitFile"		.s:fmt_bold	.s:fg_base0	.s:bg_none
hi! link gitcommitDiscardedArrow	gitcommitDiscardedFile
hi! link gitcommitSelectedArrow		gitcommitSelectedFile
hi! link gitcommitUnmergedArrow		gitcommitUnmergedFile
"exe "hi! gitcommitArrow"
"exe "hi! gitcommitOverflow"
"exe "hi! gitcommitBlank"
" }}}
" html highlighting "{{{
" ---------------------------------------------------------------------
exe "hi! htmlTag"		.s:fmt_none	.s:fg_base01	.s:bg_none
exe "hi! htmlEndTag"		.s:fmt_none	.s:fg_base01	.s:bg_none
exe "hi! htmlTagN"		.s:fmt_bold	.s:fg_base1	.s:bg_none
exe "hi! htmlTagName"		.s:fmt_bold	.s:fg_blue	.s:bg_none
exe "hi! htmlSpecialTagName"	.s:fmt_ital	.s:fg_blue	.s:bg_none
exe "hi! htmlArg"		.s:fmt_none	.s:fg_base00	.s:bg_none
exe "hi! javaScript"		.s:fmt_none	.s:fg_yellow	.s:bg_none
"}}}
" perl highlighting "{{{
" ---------------------------------------------------------------------
exe "hi! perlHereDoc"		.s:fg_base1	.s:bg_back	.s:fmt_none
exe "hi! perlVarPlain"		.s:fg_yellow	.s:bg_back	.s:fmt_none
exe "hi! perlStatementFileDesc"	.s:fg_cyan	.s:bg_back	.s:fmt_none

"}}}
" tex highlighting "{{{
" ---------------------------------------------------------------------
exe "hi! texStatement"		.s:fg_cyan	.s:bg_back	.s:fmt_none
exe "hi! texMathZoneX"		.s:fg_yellow	.s:bg_back	.s:fmt_none
exe "hi! texMathMatcher"	.s:fg_yellow	.s:bg_back	.s:fmt_none
exe "hi! texMathMatcher"	.s:fg_yellow	.s:bg_back	.s:fmt_none
exe "hi! texRefLabel"		.s:fg_yellow	.s:bg_back	.s:fmt_none
"}}}
" ruby highlighting "{{{
" ---------------------------------------------------------------------
exe "hi! rubyDefine"		.s:fg_base1	.s:bg_back	.s:fmt_bold
"rubyInclude
"rubySharpBang
"rubyAccess
"rubyPredefinedVariable
"rubyBoolean
"rubyClassVariable
"rubyBeginEnd
"rubyRepeatModifier
"hi! link rubyArrayDelimiter	Special  " [ , , ]
"rubyCurlyBlock  { , , }

"hi! link rubyClass		Keyword
"hi! link rubyModule		Keyword
"hi! link rubyKeyword		Keyword
"hi! link rubyOperator		Operator
"hi! link rubyIdentifier	Identifier
"hi! link rubyInstanceVariable	Identifier
"hi! link rubyGlobalVariable	Identifier
"hi! link rubyClassVariable	Identifier
"hi! link rubyConstant		Type
"}}}
" haskell syntax highlighting"{{{
" ---------------------------------------------------------------------
" For use with syntax/haskell.vim : Haskell Syntax File
" http://www.vim.org/scripts/script.php?script_id=3034
" See also Steffen Siering's github repository:
" http://github.com/urso/dotrc/blob/master/vim/syntax/haskell.vim
" ---------------------------------------------------------------------
"
" Treat True and False specially, see the plugin referenced above
let hs_highlight_boolean=1
" highlight delims, see the plugin referenced above
let hs_highlight_delimiters=1

exe "hi! cPreCondit"		.s:fg_orange	.s:bg_none	.s:fmt_none

exe "hi! VarId"			.s:fg_blue	.s:bg_none	.s:fmt_none
exe "hi! ConId"			.s:fg_yellow	.s:bg_none	.s:fmt_none
exe "hi! hsImport"		.s:fg_magenta	.s:bg_none	.s:fmt_none
exe "hi! hsString"		.s:fg_base00	.s:bg_none	.s:fmt_none

exe "hi! hsStructure"		.s:fg_cyan	.s:bg_none	.s:fmt_none
exe "hi! hs_hlFunctionName"	.s:fg_blue	.s:bg_none
exe "hi! hsStatement"		.s:fg_cyan	.s:bg_none	.s:fmt_none
exe "hi! hsImportLabel"		.s:fg_cyan	.s:bg_none	.s:fmt_none
exe "hi! hs_OpFunctionName"	.s:fg_yellow	.s:bg_none	.s:fmt_none
exe "hi! hs_DeclareFunction"	.s:fg_orange	.s:bg_none	.s:fmt_none
exe "hi! hsVarSym"		.s:fg_cyan	.s:bg_none	.s:fmt_none
exe "hi! hsType"		.s:fg_yellow	.s:bg_none	.s:fmt_none
exe "hi! hsTypedef"		.s:fg_cyan	.s:bg_none	.s:fmt_none
exe "hi! hsModuleName"		.s:fg_green	.s:bg_none	.s:fmt_undr
exe "hi! hsModuleStartLabel"	.s:fg_magenta	.s:bg_none	.s:fmt_none
hi! link hsImportParams		Delimiter
hi! link hsDelimTypeExport	Delimiter
hi! link hsModuleStartLabel	hsStructure
hi! link hsModuleWhereLabel	hsModuleStartLabel

" following is for the haskell-conceal plugin
" the first two items don't have an impact, but better safe
exe "hi! hsNiceOperator"	.s:fg_cyan	.s:bg_none	.s:fmt_none
exe "hi! hsniceoperator"	.s:fg_cyan	.s:bg_none	.s:fmt_none

"}}}
" pandoc markdown syntax highlighting "{{{
" ---------------------------------------------------------------------

"PandocHiLink pandocNormalBlock
exe "hi! pandocTitleBlock"			.s:fg_blue	.s:bg_none	.s:fmt_none
exe "hi! pandocTitleBlockTitle"			.s:fg_blue	.s:bg_none	.s:fmt_bold
exe "hi! pandocTitleComment"			.s:fg_blue	.s:bg_none	.s:fmt_bold
exe "hi! pandocComment"				.s:fg_base01	.s:bg_none	.s:fmt_ital
exe "hi! pandocVerbatimBlock"			.s:fg_yellow	.s:bg_none	.s:fmt_none
hi! link pandocVerbatimBlockDeep		pandocVerbatimBlock
hi! link pandocCodeBlock			pandocVerbatimBlock
hi! link pandocCodeBlockDelim			pandocVerbatimBlock
exe "hi! pandocBlockQuote"			.s:fg_blue	.s:bg_none	.s:fmt_none
exe "hi! pandocBlockQuoteLeader1"		.s:fg_blue	.s:bg_none	.s:fmt_none
exe "hi! pandocBlockQuoteLeader2"		.s:fg_cyan	.s:bg_none	.s:fmt_none
exe "hi! pandocBlockQuoteLeader3"		.s:fg_yellow	.s:bg_none	.s:fmt_none
exe "hi! pandocBlockQuoteLeader4"		.s:fg_red	.s:bg_none	.s:fmt_none
exe "hi! pandocBlockQuoteLeader5"		.s:fg_base0	.s:bg_none	.s:fmt_none
exe "hi! pandocBlockQuoteLeader6"		.s:fg_base01	.s:bg_none	.s:fmt_none
exe "hi! pandocListMarker"			.s:fg_magenta	.s:bg_none	.s:fmt_none
exe "hi! pandocListReference"			.s:fg_magenta	.s:bg_none	.s:fmt_undr

" Definitions
" ---------------------------------------------------------------------
let s:fg_pdef = s:fg_violet
exe "hi! pandocDefinitionBlock"			.s:fg_pdef	.s:bg_none	.s:fmt_none
exe "hi! pandocDefinitionTerm"			.s:fg_pdef	.s:bg_none	.s:fmt_stnd
exe "hi! pandocDefinitionIndctr"		.s:fg_pdef	.s:bg_none	.s:fmt_bold
exe "hi! pandocEmphasisDefinition"		.s:fg_pdef	.s:bg_none	.s:fmt_ital
exe "hi! pandocEmphasisNestedDefinition"	.s:fg_pdef	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrongEmphasisDefinition"	.s:fg_pdef	.s:bg_none	.s:fmt_bold
exe "hi! pandocStrongEmphasisNestedDefinition"	.s:fg_pdef	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrongEmphasisEmphasisDefinition".s:fg_pdef	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrikeoutDefinition"		.s:fg_pdef	.s:bg_none	.s:fmt_revr
exe "hi! pandocVerbatimInlineDefinition"	.s:fg_pdef	.s:bg_none	.s:fmt_none
exe "hi! pandocSuperscriptDefinition"		.s:fg_pdef	.s:bg_none	.s:fmt_none
exe "hi! pandocSubscriptDefinition"		.s:fg_pdef	.s:bg_none	.s:fmt_none

" Tables
" ---------------------------------------------------------------------
let s:fg_ptable = s:fg_blue
exe "hi! pandocTable"				.s:fg_ptable	.s:bg_none	.s:fmt_none
exe "hi! pandocTableStructure"			.s:fg_ptable	.s:bg_none	.s:fmt_none
hi! link pandocTableStructureTop		pandocTableStructre
hi! link pandocTableStructureEnd		pandocTableStructre
exe "hi! pandocTableZebraLight"			.s:fg_ptable	.s:bg_base03	.s:fmt_none
exe "hi! pandocTableZebraDark"			.s:fg_ptable	.s:bg_base02	.s:fmt_none
exe "hi! pandocEmphasisTable"			.s:fg_ptable	.s:bg_none	.s:fmt_ital
exe "hi! pandocEmphasisNestedTable"		.s:fg_ptable	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrongEmphasisTable"		.s:fg_ptable	.s:bg_none	.s:fmt_bold
exe "hi! pandocStrongEmphasisNestedTable"	.s:fg_ptable	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrongEmphasisEmphasisTable"	.s:fg_ptable	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrikeoutTable"			.s:fg_ptable	.s:bg_none	.s:fmt_revr
exe "hi! pandocVerbatimInlineTable"		.s:fg_ptable	.s:bg_none	.s:fmt_none
exe "hi! pandocSuperscriptTable"		.s:fg_ptable	.s:bg_none	.s:fmt_none
exe "hi! pandocSubscriptTable"			.s:fg_ptable	.s:bg_none	.s:fmt_none

" Headings
" ---------------------------------------------------------------------
let s:fg_phead = s:fg_orange
exe "hi! pandocHeading"				.s:fg_phead	.s:bg_none	.s:fmt_bold
exe "hi! pandocHeadingMarker"			.s:fg_yellow	.s:bg_none	.s:fmt_bold
exe "hi! pandocEmphasisHeading"			.s:fg_phead	.s:bg_none	.s:fmt_bldi
exe "hi! pandocEmphasisNestedHeading"		.s:fg_phead	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrongEmphasisHeading"		.s:fg_phead	.s:bg_none	.s:fmt_bold
exe "hi! pandocStrongEmphasisNestedHeading"	.s:fg_phead	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrongEmphasisEmphasisHeading"	.s:fg_phead	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrikeoutHeading"		.s:fg_phead	.s:bg_none	.s:fmt_revr
exe "hi! pandocVerbatimInlineHeading"		.s:fg_phead	.s:bg_none	.s:fmt_bold
exe "hi! pandocSuperscriptHeading"		.s:fg_phead	.s:bg_none	.s:fmt_bold
exe "hi! pandocSubscriptHeading"		.s:fg_phead	.s:bg_none	.s:fmt_bold

" Links
" ---------------------------------------------------------------------
exe "hi! pandocLinkDelim"			.s:fg_base01	.s:bg_none	.s:fmt_none
exe "hi! pandocLinkLabel"			.s:fg_blue	.s:bg_none	.s:fmt_undr
exe "hi! pandocLinkText"			.s:fg_blue	.s:bg_none	.s:fmt_undb
exe "hi! pandocLinkURL"				.s:fg_base00	.s:bg_none	.s:fmt_undr
exe "hi! pandocLinkTitle"			.s:fg_base00	.s:bg_none	.s:fmt_undi
exe "hi! pandocLinkTitleDelim"			.s:fg_base01	.s:bg_none	.s:fmt_undi	.s:sp_base00
exe "hi! pandocLinkDefinition"			.s:fg_cyan	.s:bg_none	.s:fmt_undr	.s:sp_base00
exe "hi! pandocLinkDefinitionID"		.s:fg_blue	.s:bg_none	.s:fmt_bold
exe "hi! pandocImageCaption"			.s:fg_violet	.s:bg_none	.s:fmt_undb
exe "hi! pandocFootnoteLink"			.s:fg_green	.s:bg_none	.s:fmt_undr
exe "hi! pandocFootnoteDefLink"			.s:fg_green	.s:bg_none	.s:fmt_bold
exe "hi! pandocFootnoteInline"			.s:fg_green	.s:bg_none	.s:fmt_undb
exe "hi! pandocFootnote"			.s:fg_green	.s:bg_none	.s:fmt_none
exe "hi! pandocCitationDelim"			.s:fg_magenta	.s:bg_none	.s:fmt_none
exe "hi! pandocCitation"			.s:fg_magenta	.s:bg_none	.s:fmt_none
exe "hi! pandocCitationID"			.s:fg_magenta	.s:bg_none	.s:fmt_undr
exe "hi! pandocCitationRef"			.s:fg_magenta	.s:bg_none	.s:fmt_none

" Main Styles
" ---------------------------------------------------------------------
exe "hi! pandocStyleDelim"			.s:fg_base01	.s:bg_none	.s:fmt_none
exe "hi! pandocEmphasis"			.s:fg_base0	.s:bg_none	.s:fmt_ital
exe "hi! pandocEmphasisNested"			.s:fg_base0	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrongEmphasis"			.s:fg_base0	.s:bg_none	.s:fmt_bold
exe "hi! pandocStrongEmphasisNested"		.s:fg_base0	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrongEmphasisEmphasis"		.s:fg_base0	.s:bg_none	.s:fmt_bldi
exe "hi! pandocStrikeout"			.s:fg_base01	.s:bg_none	.s:fmt_revr
exe "hi! pandocVerbatimInline"			.s:fg_yellow	.s:bg_none	.s:fmt_none
exe "hi! pandocSuperscript"			.s:fg_violet	.s:bg_none	.s:fmt_none
exe "hi! pandocSubscript"			.s:fg_violet	.s:bg_none	.s:fmt_none

exe "hi! pandocRule"				.s:fg_blue	.s:bg_none	.s:fmt_bold
exe "hi! pandocRuleLine"			.s:fg_blue	.s:bg_none	.s:fmt_bold
exe "hi! pandocEscapePair"			.s:fg_red	.s:bg_none	.s:fmt_bold
exe "hi! pandocCitationRef"			.s:fg_magenta	.s:bg_none	.s:fmt_none
exe "hi! pandocNonBreakingSpace"		.s:fg_red	.s:bg_none	.s:fmt_revr
hi! link pandocEscapedCharacter			pandocEscapePair
hi! link pandocLineBreak			pandocEscapePair

" Embedded Code
" ---------------------------------------------------------------------
exe "hi! pandocMetadataDelim"			.s:fg_base01	.s:bg_none	.s:fmt_none
exe "hi! pandocMetadata"			.s:fg_blue	.s:bg_none	.s:fmt_none
exe "hi! pandocMetadataKey"			.s:fg_blue	.s:bg_none	.s:fmt_none
exe "hi! pandocMetadata"			.s:fg_blue	.s:bg_none	.s:fmt_bold
hi! link pandocMetadataTitle			pandocMetadata

"}}}
" License "{{{
" ---------------------------------------------------------------------
"
" Copyright (c) 2011 Ethan Schoonover
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
"
" vim:foldmethod=marker:foldlevel=0
"}}}
