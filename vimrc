" ~/.vimrc - |vimrc| - Vim configuration

set nocompatible

""" Appearance

set title titlestring=%t%(\ %m%)%(\ (%{hostname()}\ %{expand(\"%:p:~:h\")})%)%(\ %a%)

set display+=lastline
set ruler showmode showcmd
set number
silent! set numberwidth=1
silent! set mouse=a
set wildmenu
"set wildmode=list:longest

let g:zenburn_high_Contrast=1
let g:zenburn_old_Visual=1
silent! color slate

if has("syntax")
	syntax on
endif

if &term == "screen"
	" set screen windowtitle instead of hardstatus
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
set autoindent
set smartindent
set nocindent cinkeys=0{,0},0),:,!,o,O,e
set formatoptions=tcrqn

set noshowmatch
"silent! let loaded_matchparen=1

"set listchars=eol:¶,tab:›\ ,extends:»,precedes:«,trail:•
" └─
silent! set listchars=eol:¶,tab:│┈,extends:»,precedes:«,trail:•

"" Macros
if &term != "builtin_gui"
	set iminsert=1
	silent! source $MYVIMRC.input
endif

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

" disable application keypad mode
set t_ks= t_ke=

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

"" Autocommands
silent! autocmd BufNewFile,BufRead
\ authorized_keys,authorized_keys.*,known_hosts,id_*.pub
\ set wrap nolinebreak
silent! autocmd BufNewFile,BufRead
\ authorized_keys.*
\ set ft=conf
silent! autocmd BufReadPost host-acls %!sexp-conv -w 0
silent! autocmd BufNewFile,BufRead
\ */pam.d/*
\ set ft=pamconf
silent! autocmd BufNewFile,BufRead .muttaliases set ft=muttrc
silent! autocmd BufNewFile,BufRead
\ /etc/systemd/*,/lib/systemd/*,~/.config/systemd/*,~/src/systemd-arch-units/*/*.*
\ set ft=desktop
silent! autocmd BufNewFile,BufRead
\ /tmp/bash-fc-*
\ set ft=sh

func! JoinPara()
	:g/^./ .,/^$/-1 join
endfunc

" swap file location
set dir=~/tmp//,/var/tmp//,/tmp//

if hostname() == "rain"
	set nofsync swapsync=
endif
