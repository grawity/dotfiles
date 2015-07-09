setl ts=4 sw=4 et

syn match ansiSequence /\[\d*\(;\d\+\)*m/

hi def link ansiSequence String

"hi! def link SpecialKey ansiSequence

inoremap <C-c> <C-v><Esc>[38;5;
inoremap <C-x> <C-v><Esc>[m
