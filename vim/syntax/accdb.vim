syn match adLine		/^\s*/		nextgroup=adGuid,adTagMarker,adField

syn match adField		//		contained nextgroup=adFieldPrivate,adFieldName
syn match adFieldName		/\S.\{-}[:=]/	contained nextgroup=adFieldValue
syn match adFieldPrivate	/!\S.\{-}[:=]/	contained nextgroup=adFieldValue
syn match adFieldValue		/.*$/		contained
syn match adGuid		/{[0-9a-f-]*}/	contained
syn match adTagMarker		/+/		contained nextgroup=adTag

syn match adName		/^=.*$/		contains=NONE
syn match adComment		/^;.*$/		contains=NONE

hi def link adName		Title
hi def link adGuid		Delimiter
hi def link adComment		Comment
hi def link adFieldName		Identifier
hi def link adFieldPrivate	Constant
hi def link adFieldValue	String
hi def link adTagMarker		Delimiter
