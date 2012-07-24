" ~/.gvimrc - |gvimrc| - additional GVim configuration

set columns=90 lines=40

if has("gui_gtk")
	let &guifont="Monospace 9"
"	set guifont=DejaVu\ Sans\ Mono\ 10
elseif has("gui_win32")
	let &guifont="Consolas:h9"
"	set guifont=DejaVu_Sans_Mono:h9
endif

set guioptions+=ag		" autoselect, grey menuitems
set guioptions-=m		" menu
set guioptions-=t		" tearoff menus
set guioptions-=T		" toolbar
set guioptions-=L
set guioptions-=R

if has("gui_running")
	map	<silent>	<C-Tab>		:tabnext<CR>
	imap	<silent>	<C-Tab>		<Esc>:tabnext<CR>
	map	<silent>	<C-S-Tab>	:tabprevious<CR>
	imap	<silent>	<C-S-Tab>	<Esc>:tabprevious<CR>
	map	<silent>	<C-S>		:w<CR>
	imap	<silent>	<C-S>		<Esc>:w<CR>
	map	<silent>	<C-Q>		:q<CR>
	map	<silent>	<S-Insert>	"*p
	imap	<silent>	<S-Insert>	<Esc>"*pa
	map	<silent>	<C-S-C>		"+y
	imap	<silent>	<C-S-C>		<Esc>"+yya
	map	<silent>	<C-S-V>		"+p
	imap	<silent>	<C-S-V>		<Esc>"+pa
	imap			<C-BS>		<C-W>
endif
