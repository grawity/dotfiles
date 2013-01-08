" ~/.vimrc - |vimrc| - Vim configuration

set nocompatible

""" Appearance

" Window title

set title
set titlelen=0
set titlestring=%t%(\ %m%)%(\ (%{hostname()}\ %{expand(\"%:p:~:h\")})%)%(\ %a%)

if &term =~ "^screen"
	" not present by default
	set t_ts=]2; t_fs=
endif

" Syntax highlighting

if has("syntax")
	syntax on
endif

" Color scheme

"et g:lucius_style="light"
let g:lucius_style="dark"
"et g:molokai_original=1
let g:Powerline_symbols = 'fancy'
let g:zenburn_high_Contrast=1
let g:zenburn_old_Visual=1

if &term == "linux"
	set bg=dark
endif

if has("gui_running")
	" configured in gvimrc
elseif &t_Co == 256
	silent! color desert
	silent! color zenburn
else
	silent! color slate
endif

" UI elements

set ruler
set showmode
set showcmd
set display+=lastline
silent! set number
silent! set numberwidth=4
silent! set mouse=a
set scrolloff=3			" scroll context lines
set laststatus=2		" display status
set tabpagemax=20		" max tabs

if &t_Co > 16
	setl cursorline
	au WinEnter * setl cursorline
	au WinLeave * setl nocursorline
endif

set wildmenu			" completion menu
"set wildmode=list:longest

"silent! set listchars=eol:¶,tab:›\ ,extends:»,precedes:«,trail:•
silent! set listchars=eol:¬,tab:│┈,extends:»,precedes:«,trail:•

set splitbelow

""" File input/output

let g:netrw_http_cmd="curl -s -L"
let g:netrw_http_xcmd="-o"
let g:netrw_silent=1

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp1257,latin1
set modeline

set nobackup
set backupcopy=yes " fixes issues with vipw
set autoread
set autowrite

set viminfo+=n~/.vim/viminfo

if hostname() == "rain"
	set nofsync swapsync=
endif

" Swap file location – use // to include full path in swapnames
if has("unix")
	set backupdir=~/.vim/backup//
	silent! set undodir=~/.vim/tmp/undo//
	set directory=~/.vim/backup//,/var/tmp//,/tmp//
endif

""" Text editing

set tabstop=8
set shiftwidth=8
set smarttab
set autoindent
set smartindent
set nocindent
set cinkeys=0{,0},0),:,!,o,O,e
set formatoptions=tcrqn
set gdefault

set comments-=:%
set comments-=:XCOMM

set noshowmatch
"silent! let loaded_matchparen=1

nnoremap <Tab> %
vnoremap <Tab> %
nnoremap j gj
nnoremap k gk
inoremap <F1> <Esc>
nnoremap <F1> <Esc>
vnoremap <F1> <Esc>
nnoremap ; :
nnoremap q :q

" Searching

set incsearch
set nohlsearch
set ignorecase
set smartcase

""" Keyboard and custom commands

com! -complete=file -bang -nargs=? W :w<bang> <args>

if &term != "builtin_gui"
	set iminsert=1
endif

" list buffers
nnoremap <Leader>l :ls<CR>:b<Space>
" rename word under cursor
nnoremap <Leader>rw :%s/\<<C-r><C-w>\>/
" sort CSS properties
nnoremap <Leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
" display Tagbar
nmap <Leader>t :TagbarToggle<CR>
" reselect pasted text
nnoremap <Leader>v V`]
" rewrap current paragraph
nnoremap <Leader>w gq}
" strip trailing whitespace
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=""<CR>

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

if $TERM =~ "^xterm"
	" Ctrl-(Left/Right)
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

	" Application keypad
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

""" File-specific behavior

silent! autocmd BufNewFile,BufRead
\ COMMIT_EDITMSG,git-rebase-todo
\ setl nomodeline

""" Still not sorted

set backspace=indent,eol,start
set hidden
set history=50
set linebreak
" prevent auto-unindenting on pressing # (by smartindent)
inoremap # X#

"" Autocommands

silent! au BufNewFile,BufRead /tmp/bash-fc-* setl ft=sh
silent! au BufNewFile,BufRead /etc/motd setl et
silent! au BufNewFile,BufRead */pam.d/* setf pamconf

silent! autocmd BufNewFile,BufRead
\ authorized_keys,authorized_keys.*,known_hosts,id_*.pub
\ setl wrap nolinebreak
silent! autocmd BufNewFile,BufRead
\ authorized_keys.*
\ set ft=conf
silent! autocmd BufReadPost host-acls %!sexp-conv -w 0
silent! autocmd BufNewFile,BufRead
\ .muttaliases
\ setf muttrc
"silent! autocmd BufNewFile,BufRead
"\ /etc/systemd/*,/lib/systemd/*,~/.config/systemd/*,~/src/systemd-arch-units/*/*.*
"\ set ft=desktop

au! BufNewFile */_posts/2*.html 0r %:h/_template.html

func! JoinPara()
	:g/^./ .,/^$/-1 join
endfunc


""" Plugins

call pathogen#infect()
filetype plugin on
