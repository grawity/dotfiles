syn match adLine		/^\s*/
				\ nextgroup=adFileMeta,adGuid,adGuidError,adTagMarker,adField

syn match adField		//
				\ contained nextgroup=adFieldPrivate,adFieldName

syn match adFieldName		/\S.\{-}[:=]\s*/
				\ contained nextgroup=adFieldValue
syn match adFieldPrivate	/pass[:=]\s*/
				\ contained nextgroup=adFieldPrivateValue
syn match adFieldPrivate	/!\S.\{-}[:=]\s*/
				\ contained nextgroup=adFieldPrivateValue

syn match adFieldPrivateValue	/.*$/		contained
syn match adFieldValue		/.*$/		contained

syn match adGuidError		/{[^}]*}/	contained
syn match adGuid		/{\x\{8}-\x\{4}-\x\{4}-\x\{4}-\x\{12}}/ contained

syn match adFileMeta		/^(.*)$/	contained

syn match adTagMarker		/+/		contained nextgroup=adTag

syn match adName		/^=.*$/		contains=NONE

syn match adComment		/^\s*;.*$/		contains=NONE

hi def link adName		Title
hi def link adComment		Comment
hi def link adGuid		Delimiter
hi def link adGuidError		Error
hi def link adFieldName		Identifier
hi def link adFieldValue	String
hi def link adFieldPrivate	Constant
hi def link adFieldPrivateValue	NonText
hi def link adTagMarker		Delimiter
hi def link adFileMeta		Comment
