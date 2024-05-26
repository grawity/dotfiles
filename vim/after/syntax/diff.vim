" Neovim 0.10 now has dedicated styles:
"
" hi def link diffAdded   Added
" hi def link diffChanged Changed
" hi def link diffRemoved Removed
"
" Unfortunately, most themes don't define colors for those, so for now revert
" to the original mechanism.

"hi link diffAdded   Identifier
"hi link diffChanged PreProc
"hi link diffRemoved Special

" (XXX: This doesn't actually work in a syntax file, for some reason – the
" links seem to be applied but actually have no effec? It only works from
" within the color scheme file, so it gets copypasted there.)
