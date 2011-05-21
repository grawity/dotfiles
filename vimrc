set nocompatible

"" Interface
set title
silent! let &titlestring="%t%( %m%) (".hostname()." ".expand("%:p:~:h").")"
set ruler
set showmode showcmd
silent! set mouse=a
set wildmenu
"set wildmode=list:longest

""" Appearance

set display+=lastline
set number
silent! set numberwidth=1
silent! color slate
if has("gui")
	if has("gui_gtk")
		let &guifont="Monospace 9"
	elseif has("gui_win32")
		let &guifont="Consolas:h9"
	endif
	set guioptions+=gm
	set guioptions-=tT
	let g:zenburn_high_Contrast=1
endif
if has("gui_running")
	silent! color desert
	silent! color zenburn
	map	<silent>	<C-Tab>		:tabnext<CR>
	imap	<silent>	<C-Tab>		<Esc>:tabnext<CR>
	map	<silent>	<C-S-Tab>	:tabprevious<CR>
	imap	<silent>	<C-S-Tab>	<Esc>:tabprevious<CR>
	map	<silent>	<C-S>		:w<CR>
	imap	<silent>	<C-S>		<Esc>:w<CR>
	map	<silent>	<C-Q>		:q<CR>
	imap	<silent>	<S-Insert>	<Esc>"*pa
	imap			<C-BS>		<C-W>
endif
if has("syntax")
	syntax on
endif

if &term == "screen" " set screen windowtitle instead of hardstatus
	set t_ts=k
	set t_fs=\
endif
if &term == "linux"
	set bg=dark
endif
if &t_Co == 256
	silent! color zenburn
endif

"" Loading files
set encoding=utf-8 fileencodings=ucs-bom,utf-8,cp1257,latin1
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set modeline

"" Editing
set tabstop=8 shiftwidth=8 smarttab
set noautoindent smartindent
set nocindent cinkeys=0{,0},0),:,!,o,O,e
set formatoptions=tcrqn

set noshowmatch
"silent! let loaded_matchparen=1

"set listchars=eol:¶,tab:›\ ,extends:»,precedes:«,trail:•
" └─
set listchars=eol:¶,tab:│┈,extends:»,precedes:«,trail:•

"" Macros
if &term != "builtin_gui"
	set iminsert=1
	silent! source $MYVIMRC.input
endif

" CUA select all
"nmap <C-a> ggVG
" CUA cut/copy, non-CUA paste
vmap <C-x> "pd
nmap <C-x> "pdiw
vmap <C-c> "py
nmap <C-c> "pyiw
vmap <C-p> "pP
nmap <C-p> "pp
imap <C-p> <Esc>"ppa
"
nmap ,s :source $MYVIMRC<CR>
nmap ,e :e $MYVIMRC<CR>

map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" Ctrl-(Left/Right)
if $TERM =~ "^rxvt"
	map <Esc>Oa <Esc>[1;2A
	map <Esc>Ob <Esc>[1;2B
	map <Esc>Oc <Esc>[1;2C
	map <Esc>Od <Esc>[1;2D
	map! <Esc>Oa <Esc>[1;2A
	map! <Esc>Ob <Esc>[1;2B
	map! <Esc>Oc <Esc>[1;2C
	map! <Esc>Od <Esc>[1;2D
elseif $TERM =~ "^xterm"
	map <Esc>OA <Esc>[1A
	map <Esc>OB <Esc>[1B
	map <Esc>OC <Esc>[1C
	map <Esc>OD <Esc>[1D
	map! <Esc>OA <Esc>[1A
	map! <Esc>OB <Esc>[1B
	map! <Esc>OC <Esc>[1C
	map! <Esc>OD <Esc>[1D

	" PuTTY madness
	map <Esc>[C <S-Right>
	map <Esc>[D <S-Left>
endif

" Application keypad
if $TERM =~ "^xterm"
	map <Esc>Ol +
	map <Esc>On .
	map <Esc>Op 0
	map <Esc>Oq 1
	map <Esc>Or 2
	map <Esc>Os 3
	map <Esc>Ot 4
	map <Esc>Ou 5
	map <Esc>Ov 6
	map <Esc>Ow 7
	map <Esc>Ox 8
	map <Esc>Oy 9
	map <Esc>OQ /
	map <Esc>OR *
	map <Esc>OS -
	lmap <Esc>Ol +
	lmap <Esc>On .
	lmap <Esc>Op 0
	lmap <Esc>Oq 1
	lmap <Esc>Or 2
	lmap <Esc>Os 3
	lmap <Esc>Ot 4
	lmap <Esc>Ou 5
	lmap <Esc>Ov 6
	lmap <Esc>Ow 7
	lmap <Esc>Ox 8
	lmap <Esc>Oy 9
	lmap <Esc>OQ /
	lmap <Esc>OR *
	lmap <Esc>OS -
endif

"if $TERM =~ "^gnome"
"	map <Esc>[1;5A <Esc>[1;2A
"	map <Esc>[1;5B <Esc>[1;2B
"	map <Esc>[1;5C <Esc>[1;2C
"	map <Esc>[1;5D <Esc>[1;2D
"	map! <Esc>[1;5A <Esc>[1;2A
"	map! <Esc>[1;5B <Esc>[1;2B
"	map! <Esc>[1;5C <Esc>[1;2C
"	map! <Esc>[1;5D <Esc>[1;2D
"endif

"" Searching
set incsearch nohlsearch
set ignorecase smartcase

"" Saving
set nobackup
set autowrite

set backspace=indent,eol,start
set hidden
set history=50
set linebreak
" prevent auto-unindenting on pressing # (by smartindent)
inoremap # X#

silent! autocmd BufNewFile,BufRead
\ authorized_keys,authorized_keys.*,known_hosts,id_*.pub
\ set nowrap
silent! autocmd BufNewFile,BufRead
\ authorized_keys.*
\ set ft=conf
silent! autocmd BufReadPost host-acls %!sexp-conv -w 0
silent! autocmd BufNewFile,BufRead lib/passwd set ft=passwd
silent! autocmd BufNewFile,BufRead lib/group set ft=group
silent! autocmd BufNewFile,BufRead */pam.d/* set ft=pamconf
silent! autocmd BufNewFile,BufRead .muttaliases set ft=muttrc
silent! autocmd BufNewFile,BufRead
\ /etc/systemd/*,/lib/systemd/*
\ set ft=dosini
silent! autocmd BufNewFile,BufRead /tmp/bash-fc-* set ft=sh
