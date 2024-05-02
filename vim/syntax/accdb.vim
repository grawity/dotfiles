syn match adLine		/^\s*/
				\ nextgroup=adFileMeta,adGuid,adGuidError,adTagMarker,adField

syn match adField		//
				\ contained nextgroup=adFieldMetaName,adFieldPrivateName,adFieldRefName,adFieldName,adFieldComment,adFieldError

syn match adFieldError		/.*/
				\ contained
syn match adFieldName		/[^.]\S.\{-}[:=]\s*/
				\ contained nextgroup=adFieldValue
syn match adFieldMetaName	/[.@]\S.\{-}[:=]\s*/
				\ contained nextgroup=adFieldMetaValue
syn match adFieldPrivateName	/pass[:=]\s*/
				\ contained nextgroup=adFieldPrivateValue
syn match adFieldPrivateName	/!\S.\{-}[:=]\s*/
				\ contained nextgroup=adFieldPrivateValue
syn match adFieldRefName	/ref\.\S.\{-}[:=]\s*/
				\ contained nextgroup=adGuid,adGuidError
syn match adFieldComment	/-- .*/
				\ contained

syn match adFieldValue		/.*$/		contained
syn match adFieldMetaValue	/.*$/		contained
syn match adFieldPrivateValue	/.*$/		contained
syn match adFieldRefValue	/.*$/		contained

syn match adGuidError		/{[^}]*}/	contained
syn match adGuid		/{\x\{8}-\x\{4}-\x\{4}-\x\{4}-\x\{12}}/ contained

syn match adFileMeta		/^(.*)$/	contained

syn match adTagMarker		/+/		contained nextgroup=adTag

syn match adName		/^=.*$/		contains=NONE

syn match adComment		/^\s*;.*$/	contains=NONE


hi def link adComment		Comment
hi def link adFieldComment	Comment
hi def link adFieldError	Error
hi def link adFieldName		Identifier
hi def link adFieldValue	String
hi def link adFieldMetaName	Delimiter
hi def link adFieldMetaValue	Delimiter
hi def link adFieldPrivateName	Constant
hi def link adFieldPrivateValue	NonText
hi def link adFieldRefName	StorageClass
hi def link adFileMeta		Comment
hi def link adGuid		Delimiter
hi def link adGuidError		Error
hi def link adName		Title
hi def link adTagMarker		Delimiter
