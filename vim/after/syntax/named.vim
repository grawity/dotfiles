syn keyword namedOption		contained dnssec-enable
				\ nextgroup=namedBool,namedNotBool skipwhite

syn keyword namedOption		contained dnssec-validation dnssec-lookaside
				\ nextgroup=namedTriBool,namedNotBool skipwhite

syn keyword namedOption		contained listen-on listen-on-v6
				\ nextgroup=namedIPList skipwhite

syn keyword namedTriBool	contained yes no auto

syn match namedIPaddr		contained /\<[0-9a-f:]\+;/he=e-1

hi def link namedTriBool	namedBool
