setl ts=4 sw=4 et

syn match ansiSequence /\[\d*\(;\d\+\)*m/

hi def link ansiSequence String
hi! def link SpecialKey ansiSequence
