" By default, all -Options are matched as Label and that's just wrong. (Label
" is supposed to be used for actual goto/jump labels, so it's underlined in
" many syntax themes.)

"syn clear ps1Label
hi link ps1Label Identifier
