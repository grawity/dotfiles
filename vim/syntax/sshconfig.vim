" Copied from /usr/share/nvim/runtime/syntax/sshconfig.vim
" Locally edited to remove annoying enum highlighting

" Vim syntax file
" Language:	OpenSSH client configuration file (ssh_config)
" Author:	David Necas (Yeti)
" Maintainer:	Jakub Jelen <jakuje at gmail dot com>
" Previous Maintainer:	Dominik Fischer <d dot f dot fischer at web dot de>
" Contributor:  Leonard Ehrenfried <leonard.ehrenfried@web.de>
" Contributor:  Karsten Hopp <karsten@redhat.com>
" Contributor:  Dean, Adam Kenneth <adam.ken.dean@hpe.com>
" Last Change:	2022 Nov 10
"		Added RemoteCommand from pull request #4809
"		Included additional keywords from Martin.
"		Included PR #5753
" SSH Version:	8.5p1
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
syn match sshconfigHostPort "\(Hostname \)\@<=.\+"

" case off
syn case ignore


" Keywords
syn keyword sshconfigHostSect Host

syn keyword sshconfigKeyword AddKeysToAgent
syn keyword sshconfigKeyword AddressFamily
syn keyword sshconfigKeyword BatchMode
syn keyword sshconfigKeyword BindAddress
syn keyword sshconfigKeyword BindInterface
syn keyword sshconfigKeyword CanonicalDomains
syn keyword sshconfigKeyword CanonicalizeFallbackLocal
syn keyword sshconfigKeyword CanonicalizeHostname
syn keyword sshconfigKeyword CanonicalizeMaxDots
syn keyword sshconfigKeyword CanonicalizePermittedCNAMEs
syn keyword sshconfigKeyword CASignatureAlgorithms
syn keyword sshconfigKeyword CertificateFile
syn keyword sshconfigKeyword ChallengeResponseAuthentication
syn keyword sshconfigKeyword ChannelTimeout
syn keyword sshconfigKeyword CheckHostIP
syn keyword sshconfigKeyword Ciphers
syn keyword sshconfigKeyword ClearAllForwardings
syn keyword sshconfigKeyword Compression
syn keyword sshconfigKeyword ConnectionAttempts
syn keyword sshconfigKeyword ConnectTimeout
syn keyword sshconfigKeyword ControlMaster
syn keyword sshconfigKeyword ControlPath
syn keyword sshconfigKeyword ControlPersist
syn keyword sshconfigKeyword DynamicForward
syn keyword sshconfigKeyword EnableEscapeCommandline
syn keyword sshconfigKeyword EnableSSHKeysign
syn keyword sshconfigKeyword EscapeChar
syn keyword sshconfigKeyword ExitOnForwardFailure
syn keyword sshconfigKeyword FingerprintHash
syn keyword sshconfigKeyword ForkAfterAuthentication
syn keyword sshconfigKeyword ForwardAgent
syn keyword sshconfigKeyword ForwardX11
syn keyword sshconfigKeyword ForwardX11Timeout
syn keyword sshconfigKeyword ForwardX11Trusted
syn keyword sshconfigKeyword GatewayPorts
syn keyword sshconfigKeyword GlobalKnownHostsFile
syn keyword sshconfigKeyword GSSAPIAuthentication
syn keyword sshconfigKeyword GSSAPIDelegateCredentials
syn keyword sshconfigKeyword HashKnownHosts
syn keyword sshconfigKeyword HostbasedAcceptedAlgorithms
syn keyword sshconfigKeyword HostbasedAuthentication
syn keyword sshconfigKeyword HostbasedKeyTypes
syn keyword sshconfigKeyword HostKeyAlgorithms
syn keyword sshconfigKeyword HostKeyAlias
syn keyword sshconfigKeyword Hostname
syn keyword sshconfigKeyword IdentitiesOnly
syn keyword sshconfigKeyword IdentityAgent
syn keyword sshconfigKeyword IdentityFile
syn keyword sshconfigKeyword IgnoreUnknown
syn keyword sshconfigKeyword Include
syn keyword sshconfigKeyword IPQoS
syn keyword sshconfigKeyword KbdInteractiveAuthentication
syn keyword sshconfigKeyword KbdInteractiveDevices
syn keyword sshconfigKeyword KexAlgorithms
syn keyword sshconfigKeyword KnownHostsCommand
syn keyword sshconfigKeyword LocalCommand
syn keyword sshconfigKeyword LocalForward
syn keyword sshconfigKeyword LogLevel
syn keyword sshconfigKeyword LogVerbose
syn keyword sshconfigKeyword MACs
syn keyword sshconfigKeyword Match
syn keyword sshconfigKeyword NoHostAuthenticationForLocalhost
syn keyword sshconfigKeyword NumberOfPasswordPrompts
syn keyword sshconfigKeyword ObscureKeystrokeTiming
syn keyword sshconfigKeyword PasswordAuthentication
syn keyword sshconfigKeyword PermitLocalCommand
syn keyword sshconfigKeyword PermitRemoteOpen
syn keyword sshconfigKeyword PKCS11Provider
syn keyword sshconfigKeyword Port
syn keyword sshconfigKeyword PreferredAuthentications
syn keyword sshconfigKeyword ProxyCommand
syn keyword sshconfigKeyword ProxyJump
syn keyword sshconfigKeyword ProxyUseFdpass
syn keyword sshconfigKeyword PubkeyAcceptedAlgorithms
syn keyword sshconfigKeyword PubkeyAcceptedKeyTypes
syn keyword sshconfigKeyword PubkeyAuthentication
syn keyword sshconfigKeyword RekeyLimit
syn keyword sshconfigKeyword RemoteCommand
syn keyword sshconfigKeyword RemoteForward
syn keyword sshconfigKeyword RequestTTY
syn keyword sshconfigKeyword RequiredRSASize
syn keyword sshconfigKeyword RevokedHostKeys
syn keyword sshconfigKeyword SecurityKeyProvider
syn keyword sshconfigKeyword SendEnv
syn keyword sshconfigKeyword ServerAliveCountMax
syn keyword sshconfigKeyword ServerAliveInterval
syn keyword sshconfigKeyword SessionType
syn keyword sshconfigKeyword SetEnv
syn keyword sshconfigKeyword SmartcardDevice
syn keyword sshconfigKeyword StdinNull
syn keyword sshconfigKeyword StreamLocalBindMask
syn keyword sshconfigKeyword StreamLocalBindUnlink
syn keyword sshconfigKeyword StrictHostKeyChecking
syn keyword sshconfigKeyword SyslogFacility
syn keyword sshconfigKeyword Tag
syn keyword sshconfigKeyword TCPKeepAlive
syn keyword sshconfigKeyword Tunnel
syn keyword sshconfigKeyword TunnelDevice
syn keyword sshconfigKeyword UpdateHostKeys
syn keyword sshconfigKeyword UseBlacklistedKeys
syn keyword sshconfigKeyword User
syn keyword sshconfigKeyword UserKnownHostsFile
syn keyword sshconfigKeyword VerifyHostKeyDNS
syn keyword sshconfigKeyword VisualHostKey
syn keyword sshconfigKeyword WarnWeakCrypto
syn keyword sshconfigKeyword XAuthLocation

" Deprecated/ignored/remove/unsupported keywords

syn keyword sshConfigDeprecated Cipher
syn keyword sshconfigDeprecated GSSAPIClientIdentity
syn keyword sshconfigDeprecated GSSAPIKeyExchange
syn keyword sshconfigDeprecated GSSAPIRenewalForcesRekey
syn keyword sshconfigDeprecated GSSAPIServerIdentity
syn keyword sshconfigDeprecated GSSAPITrustDNS
syn keyword sshconfigDeprecated GSSAPITrustDns
syn keyword sshconfigDeprecated Protocol
syn keyword sshconfigDeprecated RSAAuthentication
syn keyword sshconfigDeprecated RhostsRSAAuthentication
syn keyword sshconfigDeprecated CompressionLevel
syn keyword sshconfigDeprecated UseRoaming
syn keyword sshconfigDeprecated UsePrivilegedPort

" Define the default highlighting

hi def link sshconfigComment        Comment
hi def link sshconfigTodo           Todo
hi def link sshconfigHostPort       String
hi def link sshconfigYesNo          Boolean
hi def link sshconfigCipher         sshconfigDeprecated
hi def link sshconfigCiphers        sshconfigEnum
hi def link sshconfigMAC            sshconfigEnum
hi def link sshconfigHostKeyAlgo    sshconfigEnum
hi def link sshconfigLogLevel       sshconfigEnum
hi def link sshconfigSysLogFacility sshconfigEnum
hi def link sshconfigAddressFamily  sshconfigEnum
hi def link sshconfigIPQoS          sshconfigEnum
hi def link sshconfigKbdInteractive sshconfigEnum
hi def link sshconfigKexAlgo        sshconfigEnum
hi def link sshconfigTunnel         sshconfigEnum
hi def link sshconfigPreferredAuth  sshconfigEnum
hi def link sshconfigVar            sshconfigEnum
hi def link sshconfigEnum           Identifier
hi def link sshconfigSpecial        Special
hi def link sshconfigKeyword        Keyword
hi def link sshconfigHostSect       Label
hi def link sshconfigDeprecated     Error

let b:current_syntax = "sshconfig"

" vim:set ts=8 sw=2 sts=2:
