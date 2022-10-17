syn keyword Todo TODO XXX

syn match wlHeader /^[0-9x]\{4}-.*/
"hi def link wlHeader Label
hi def link wlHeader Define

" https://vim.fandom.com/wiki/Regex_lookahead_and_lookbehind
syn match wlDate /- \zs[0-9x]\{4}-[0-9x]\{2}-[0-9x]\{2}/
hi def link wlDate Keyword

syn match Comment /^#.*/
