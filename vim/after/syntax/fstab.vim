syn keyword fsOptionsGeneral nofail
syn keyword fsOptionsKeywords multiuser
syn match fsOptionsKeywords contained /\<sec=/ nextgroup=fsOptionsSecurity
syn keyword fsOptionsSecurity contained none sys ntlm ntlmi ntlmv2 ntlmv2i ntlmssp ntlmsspi krb5 krb5i krb5p
syn match fsOptionsKeywords contained /\<credentials=/ nextgroup=fsOptionsString
syn match fsOptionsKeywords contained /\<x-[^=]\+\>/
syn match fsOptionsKeywords contained /\<x-[^=]\+=/ nextgroup=fsOptionsString
