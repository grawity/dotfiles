syn keyword namedOption		contained dnssec-enable inline-signing
				\ nextgroup=namedBool,namedNotBool skipwhite

syn keyword namedOption		contained auto-dnssec
				\ nextgroup=namedDnssecEnum skipwhite

syn keyword namedOption		contained dnssec-validation dnssec-lookaside
				\ nextgroup=namedTriBool,namedNotBool skipwhite

syn keyword namedOption		contained key-directory tkey-gssapi-keytab
				\ nextgroup=namedString skipwhite

syn keyword namedOption		contained listen-on listen-on-v6
				\ nextgroup=namedIPList skipwhite

syn keyword namedTriBool	contained yes no auto

syn keyword namedDnssecEnum	contained maintain

syn match namedIPaddr		contained /\<[0-9a-f:]\+;/he=e-1
syn match namedIPaddr		contained /\<any;/he=e-1

hi def link namedTriBool	namedBool

" DLZ section

syn keyword namedKeyword	dlz nextgroup=namedDlzString skipwhite

syn region namedDlzString	contained oneline start=+"+ end=+"+ skipwhite
				\ nextgroup=namedDlzSection

syn region namedDlzSection	contained start=+{+ end=+}+
				\ contains=namedDlzOpt

syn keyword namedDlzOpt		contained database
				\ nextgroup=namedString skipwhite

hi def link namedDlzOpt		namedOption
