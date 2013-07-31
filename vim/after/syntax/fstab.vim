syn keyword fsDeviceKeyword contained PARTLABEL nextgroup=fsDeviceLabel
syn keyword fsDeviceKeyword contained PARTUUID nextgroup=fsDeviceUUID
syn keyword fsOptionsGeneral nofail
syn keyword fsOptionsKeywords fsc multiuser rdirplus rwpidforward
syn match fsOptionsKeywords contained /\<sec=/ nextgroup=fsOptionsSecurity
syn keyword fsOptionsSecurity contained none sys ntlm ntlmi ntlmv2 ntlmv2i ntlmssp ntlmsspi krb5 krb5i krb5p
syn match fsOptionsKeywords contained /\<credentials=/ nextgroup=fsOptionsString
syn match fsOptionsKeywords contained /\<\(file\|dir\)_mode=/ nextgroup=fsOptionsString
syn match fsOptionsKeywords contained /\<x-[^=]\+\>/
syn match fsOptionsKeywords contained /\<x-[^=]\+=/ nextgroup=fsOptionsString
