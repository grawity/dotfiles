" Vim syntax file
" Language:	OpenSSH client configuration file (ssh_config)
" Author:	David Necas (Yeti)
" Maintainer:	Dominik Fischer <d dot f dot fischer at web dot de>
" Contributor:  Leonard Ehrenfried <leonard.ehrenfried@web.de>
" Contributor:  Karsten Hopp <karsten@redhat.com>
" Contributor:  Dean, Adam Kenneth <adam.ken.dean@hpe.com>
" Last Change:	2016 Dec 28
" SSH Version:	7.4p1
"

" Setup
" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

setlocal iskeyword=_,-,a-z,A-Z,48-57


" case on
syn case match


" Comments
syn match sshconfigComment "^#.*$" contains=sshconfigTodo
syn match sshconfigComment "\s#.*$" contains=sshconfigTodo

syn keyword sshconfigTodo TODO FIXME NOTE contained


" Constants
syn keyword sshconfigYesNo yes no ask confirm
syn keyword sshconfigYesNo any auto
syn keyword sshconfigYesNo force autoask none

syn match sshconfigVar "%[rhplLdun]\>"
syn match sshconfigSpecial "[*?]"
syn match sshconfigHostPort "\<\(\d\{1,3}\.\)\{3}\d\{1,3}\(:\d\+\)\?\>"
syn match sshconfigHostPort "\<\([-a-zA-Z0-9]\+\.\)\+[-a-zA-Z0-9]\{2,}\(:\d\+\)\?\>"
syn match sshconfigHostPort "\<\(\x\{,4}:\)\+\x\{,4}[:/]\d\+\>"
syn match sshconfigHostPort "\(Host \)\@<=.\+"
syn match sshconfigHostPort "\(HostName \)\@<=.\+"

" case off
syn case ignore


" Keywords
syn keyword sshconfigHostSect Host

syn keyword sshconfigKeyword AddressFamily
syn keyword sshconfigKeyword AddKeysToAgent
syn keyword sshconfigKeyword BatchMode
syn keyword sshconfigKeyword BindAddress
syn keyword sshconfigKeyword CanonicalDomains
syn keyword sshconfigKeyword CanonicalizeFallbackLocal
syn keyword sshconfigKeyword CanonicalizeHostname
syn keyword sshconfigKeyword CanonicalizeMaxDots
syn keyword sshconfigKeyword CertificateFile
syn keyword sshconfigKeyword ChallengeResponseAuthentication
syn keyword sshconfigKeyword CheckHostIP
syn keyword sshconfigKeyword Cipher
syn keyword sshconfigKeyword Ciphers
syn keyword sshconfigKeyword ClearAllForwardings
syn keyword sshconfigKeyword Compression
syn keyword sshconfigKeyword CompressionLevel
syn keyword sshconfigKeyword ConnectTimeout
syn keyword sshconfigKeyword ConnectionAttempts
syn keyword sshconfigKeyword ControlMaster
syn keyword sshconfigKeyword ControlPath
syn keyword sshconfigKeyword ControlPersist
syn keyword sshconfigKeyword DynamicForward
syn keyword sshconfigKeyword EnableSSHKeysign
syn keyword sshconfigKeyword EscapeChar
syn keyword sshconfigKeyword ExitOnForwardFailure
syn keyword sshconfigKeyword ForwardAgent
syn keyword sshconfigKeyword ForwardX11
syn keyword sshconfigKeyword ForwardX11Timeout
syn keyword sshconfigKeyword ForwardX11Trusted
syn keyword sshconfigKeyword GSSAPIAuthentication
syn keyword sshconfigKeyword GSSAPIClientIdentity
syn keyword sshconfigKeyword GSSAPIDelegateCredentials
syn keyword sshconfigKeyword GSSAPIKeyExchange
syn keyword sshconfigKeyword GSSAPIRenewalForcesRekey
syn keyword sshconfigKeyword GSSAPIServerIdentity
syn keyword sshconfigKeyword GSSAPITrustDNS
syn keyword sshconfigKeyword GSSAPITrustDns
syn keyword sshconfigKeyword GatewayPorts
syn keyword sshconfigKeyword GlobalKnownHostsFile
syn keyword sshconfigKeyword HashKnownHosts
syn keyword sshconfigKeyword HostKeyAlgorithms
syn keyword sshconfigKeyword HostKeyAlias
syn keyword sshconfigKeyword HostName
syn keyword sshconfigKeyword HostbasedAuthentication
syn keyword sshconfigKeyword HostbasedKeyTypes
syn keyword sshconfigKeyword IPQoS
syn keyword sshconfigKeyword IdentitiesOnly
syn keyword sshconfigKeyword IdentityFile
syn keyword sshconfigKeyword IgnoreUnknown
syn keyword sshconfigKeyword Include
syn keyword sshconfigKeyword IPQoS
syn keyword sshconfigKeyword KbdInteractiveAuthentication
syn keyword sshconfigKeyword KbdInteractiveDevices
syn keyword sshconfigKeyword KexAlgorithms
syn keyword sshconfigKeyword LocalCommand
syn keyword sshconfigKeyword LocalForward
syn keyword sshconfigKeyword LogLevel
syn keyword sshconfigKeyword MACs
syn keyword sshconfigKeyword Match
syn keyword sshconfigKeyword NoHostAuthenticationForLocalhost
syn keyword sshconfigKeyword NumberOfPasswordPrompts
syn keyword sshconfigKeyword PKCS11Provider
syn keyword sshconfigKeyword PasswordAuthentication
syn keyword sshconfigKeyword PermitLocalCommand
syn keyword sshconfigKeyword Port
syn keyword sshconfigKeyword PreferredAuthentications
syn keyword sshconfigKeyword Protocol
syn keyword sshconfigKeyword ProxyCommand
syn keyword sshconfigKeyword ProxyJump
syn keyword sshconfigKeyword ProxyUseFDPass
syn keyword sshconfigKeyword PubkeyAcceptedKeyTypes
syn keyword sshconfigKeyword PubkeyAuthentication
syn keyword sshconfigKeyword RSAAuthentication
syn keyword sshconfigKeyword RekeyLimit
syn keyword sshconfigKeyword RemoteForward
syn keyword sshconfigKeyword RequestTTY
syn keyword sshconfigKeyword RhostsRSAAuthentication
syn keyword sshconfigKeyword SendEnv
syn keyword sshconfigKeyword ServerAliveCountMax
syn keyword sshconfigKeyword ServerAliveInterval
syn keyword sshconfigKeyword SmartcardDevice
syn keyword sshconfigKeyword StrictHostKeyChecking
syn keyword sshconfigKeyword TCPKeepAlive
syn keyword sshconfigKeyword Tunnel
syn keyword sshconfigKeyword TunnelDevice
syn keyword sshconfigKeyword UseBlacklistedKeys
syn keyword sshconfigKeyword UsePrivilegedPort
syn keyword sshconfigKeyword User
syn keyword sshconfigKeyword UserKnownHostsFile
syn keyword sshconfigKeyword UseRoaming
syn keyword sshconfigKeyword VerifyHostKeyDNS
syn keyword sshconfigKeyword VisualHostKey
syn keyword sshconfigKeyword XAuthLocation

" Define the default highlighting

hi def link sshconfigComment        Comment
hi def link sshconfigTodo           Todo
hi def link sshconfigHostPort       String
hi def link sshconfigYesNo          Boolean
hi def link sshconfigVar            sshconfigEnum
hi def link sshconfigEnum           Identifier
hi def link sshconfigSpecial        Special
hi def link sshconfigKeyword        Keyword
hi def link sshconfigHostSect       Label

let b:current_syntax = "sshconfig"

" vim:set ts=8 sw=2 sts=2:
