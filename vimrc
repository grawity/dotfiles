" ~/.vimrc - |vimrc| - Vim configuration

set nocompatible

""" Appearance

" Window title

set title
set titlelen=0			" do not left-truncate titles
set titlestring=%t%(\ %m%)%(\ (%{hostname()}\ %{expand(\"%:p:~:h\")})%)%(\ %a%)

if &term =~ "^screen"
	" teach vim to set window title inside screen
	set t_ts=]2; t_fs=
endif

" Syntax highlighting

let perl_no_extended_vars=1
let python_no_builtin_highlight=1

if has("syntax")
	syntax on
endif

" Color scheme

"et g:lucius_style="light"
let g:lucius_style="dark"
"et g:molokai_original=1
let g:Powerline_symbols="fancy"
let g:solarized_contrast="high"
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

" For gitgutter, make sign column look the same as number
" column, as zenburn sets it to something crazy
highlight clear SignColumn
highlight link SignColumn GitGutterChange

let solarized=0

" UI elements

set ruler
set showmode
set showcmd
set display+=lastline
set linebreak			" soft word-wrap
set showbreak=»\ 		" prefix wrapped lines
silent! set number
silent! set numberwidth=4
silent! set mouse=a
set scrolloff=3			" scroll context lines
set laststatus=2		" always display status line
set splitbelow splitright
set tabpagemax=20		" increase max tab pages

if &t_Co > 16
	"setl cursorline
	"au WinEnter * setl cursorline
	"au WinLeave * setl nocursorline
endif

set wildmenu
"set wildmode=list:longest
silent! set wildignorecase

set noerrorbells visualbell t_vb=	" turn off all bells

set shortmess+=I		" do not show :intro message
"set shortmess+=A		" do not warn about existing swapfiles

""" File input/output

let g:netrw_http_cmd="curl -s -L"
let g:netrw_http_xcmd="-o"
let g:netrw_silent=1

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp1257,latin1
set modeline

set backupcopy=yes		" fixes issues with vipw
set autoread
set autowrite

set viminfo+=n~/.vim/viminfo
set hidden			" do not unload abandoned buffers

" Swap file location – use // to include full path in swapnames
if has("unix")
	set backupdir=~/.vim/backup//
	silent! set undodir=~/.vim/tmp/undo//
	set directory=~/.vim/backup//,/var/tmp//,/tmp//
endif
if hostname() == "rain"
	set nofsync swapsync=
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
silent! set listchars=eol:¬,tab:→.,extends:»,precedes:«,trail:•

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
nnoremap <Leader>t :TagbarToggle<CR>
" display Command-T
nnoremap <C-t> :CommandT<CR>
" reselect pasted text
nnoremap <Leader>v `[V`]
" rewrap current paragraph
nnoremap <Leader>w gq}
" strip trailing whitespace
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=""<CR>

nnoremap <Tab> %
vnoremap <Tab> %

nnoremap <Down> gj
nnoremap <Up> gk
nnoremap j gj
nnoremap k gk

inoremap <F1> <Esc>
nnoremap <F1> <Esc>
vnoremap <F1> <Esc>

nnoremap ; :
nnoremap q :q
nnoremap Q <nop>
nnoremap K <nop>

" CUA cut/copy, non-CUA paste
"vmap <C-x> "pd
"nmap <C-x> "pdiw
"vmap <C-c> "py
"nmap <C-c> "pyiw
"vmap <C-p> "pP
nmap <C-p> "+gp
imap <C-p> <Esc>"+gpa

nmap ,s :source $MYVIMRC<CR>
nmap ,e :e $MYVIMRC<CR>

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

silent! au BufNewFile,BufRead
\ COMMIT_EDITMSG,git-rebase-todo
\ setl nomodeline

silent! au BufNewFile,BufRead
\ /etc/motd
\ setl et

silent! au BufNewFile,BufRead
\ authorized_keys,authorized_keys.*,known_hosts,id_*.pub
\ setl wrap nolinebreak

silent! au BufNewFile,BufRead
\ authorized_keys.*
\ set ft=conf

silent! au BufReadPost
\ host-acls
\ %!sexp-conv -w 0

au! BufNewFile
\ */_posts/2*.html
\ 0r %:h/_template.html

""" Still not sorted

set backspace=indent,eol,start
set history=50
" prevent auto-unindenting on pressing # (by smartindent)
inoremap # X#

func! JoinPara()
	:g/^\S/ .,/^$/-1 join
endfunc

""" Plugins

let g:gitgutter_sign_column_always=1
let g:gitgutter_eager=0

if &term !~ "^\\(xterm\\|builtin_gui\\)\\(-\\|$\\)"
	let g:Powerline_loaded = 1
endif

call pathogen#infect()

filetype plugin on

if solarized
	set bg=dark
	call togglebg#map("<F5>")
	color solarized
end
