" Syntax for Syncthing ignore files

if exists("b:current_syntax")
	finish
endif

syn match stignoreComment "^//.*"
syn match stignoreNotComment "^#.*"
syn match stignoreInclude "^#include"

syn match stignoreNotPrefix "(?.*)"
syn match stignorePrefix "^\((?[id])\)\+"

hi def link stignoreComment Comment
hi def link stignoreNotComment Error
hi def link stignoreInclude Include

hi def link stignoreNotPrefix Error
hi def link stignorePrefix PreCondit

let b:current_syntax = "stignore"
