# bashrc -- aliases and functions

unalias -a

do:() { (PS4=$'\e[32m+\e[m '; set -x; "$@") }

editor() { command ${EDITOR:-vim} "$@"; }
pager() { command ${PAGER:-less} "$@"; }

alias aa-reload='apparmor_parser -r -T -W'
bat() { if (( $# )) || [[ ! -t 0 ]]; then command bat "$@"; else acpi -i; fi; }
btar() { tar -czf - "$@" | base64; }
buntar() { base64 -d | tar -xvvzf -; }
alias bridge='bridge --color=auto'
catsexp() { cat "$@" | sexp-conv -w $((COLUMNS-1)); }
count() { sort "$@" | uniq -c | sort -n -r | pager; }
alias demo='PS1="\\n\\$ "'
dist/pull() { ~/bin/dist/pull "$@" && SILENT=1 . ~/.profile; }
alias dnstrace='dnstracer -s .'
alias easy-rsa='easyrsa'
alias ed='ed -p:'
entity() { printf '&%s;<br>' "$@" | w3m -dump -T text/html; }
alias ccard-tool='pkcs11-tool --module libccpkip11.so'
alias etoken-tool='pkcs11-tool --module /usr/lib/sac-10.0/libeToken.so'
alias efips-tool='pkcs11-tool --module /usr/lib/pkcs11/libeToken.so'
alias gemalto-tool='pkcs11-tool --module /usr/lib/pkcs11/libgclib.so'
alias ykcs11-tool='pkcs11-tool --module libykcs11.so'
alias pwpw-tool='pkcs11-tool --module pwpw-card-pkcs11.so'
alias osc-tool='pkcs11-tool --module opensc-pkcs11.so'
alias cryptoki-tool='pkcs11-tool --module /usr/lib/pkcs11/libopencryptoki.so'
alias tpm11-tool='pkcs11-tool --module /usr/lib/pkcs11/libtpm2_pkcs11.so'
cymruname() { arpaname "$1" | sed 's/\.in-addr\.arpa/.origin/i;
                                   s/\.ip6\.arpa/.origin6/i'; }
cymrudig() { local n=$(cymruname "$1") && [[ $n ]] && dig +short "$n" TXT; }
etsn() { pwsh -nop -noe -c "etsn $*"; tput rmkx; }
alias facl='getfacl -pt'
fc-lsformat() { fc-list -f "%10{fontformat}: %{family}\n" | sed 's/,.*//' | sort -t: -k2 -u; }
fc-fileinfo() { fc-query -f "%{file}: %{family} (%{fontversion}, %{fontformat})\n" "$@"; }
alias fanficfare='fanficfare -f html'
alias fff='fanficfare -f html'
alias fiemap='xfs_io -r -c "fiemap -v"'
alias foreach='while IFS= read -r'
gerp() { grep $grepopt -ErIHn -Dskip --exclude-dir={.bzr,.git,.hg,.svn,_undo} "$@"; }
gpgfp() { gpg --with-colons --fingerprint "$1" | awk -F: '/^fpr:/ {print $10}'; }
alias gmpv='celluloid'
alias gte='gnome-text-editor'
alias hd='hexdump -C'
hostname.bind() {
	for _s in id.server hostname.bind version.bind; do
		echo "$_s = $(dig +short "${@:2}" "@${1#@}" "$_s." TXT CH)"
	done
}
alias hup='pkill -HUP -x'
alias init='telinit' # for systemd
alias kssh='ssh \
	-o PreferredAuthentications=gssapi-keyex,gssapi-with-mic \
	-o GSSAPIAuthentication=yes \
	-o GSSAPIDelegateCredentials=yes'
alias l='~/bin/thirdparty/l'
alias ll='ls -l'
alias loc='locate -A -b -i'
alias logoff='logout'
if [[ $DESKTOP_SESSION ]]; then
	alias logout='env logout'
fi
f() { find . \( -name .git -prune \) , \( -iname "*$1*" "${@:2}" \) | natsort; }
ff() { f "$@" | sed 's,^\./,,' | treeify --fake-root "$PWD"; }
alias lchown='chown -h'
ldapls() {
	ldapsearch -LLL -o ldif-wrap=no "$@" 1.1 | grep ^dn: \
	| perl -MMIME::Base64 -pe 's/^(.+?):: (.+)$/"$1: ".decode_base64($2)/e'
}
alias lp='sudo netstat -lptu --numeric-hosts'
alias lpt='sudo netstat -lpt --numeric-hosts'
alias lpu='sudo netstat -lpu --numeric-hosts'
alias lsd='ls -d */'
alias lsh='ls -d .*'
alias lss='ls -sSr'
alias lsfonts="fc-list --format='%{family}\n' | sed 's/,.*//' | sort -u"
lsftp() {
	case $1 in
	*:.)	lftp "sftp://${1/:/}$PWD";;
	*:/*)	lftp "sftp://${1/:/}";;
	*:*)	lftp "sftp://${1/:/'/~/'}";;
	*)	lftp "sftp://$1";;
	esac
}
alias lspart='lsblk -o name,partlabel,size,fstype,label,mountpoint'
alias m='micro'
alias mg='micro -colorscheme gotham-darksb'
alias mariadb-local='mariadb --skip-ssl --skip-ssl-verify-server-cert'
mkmaildir() { mkdir -p "${@/%//cur}" "${@/%//new}" "${@/%//tmp}"; }
mtr() { settitle "$HOSTNAME: mtr $*"; command mtr --show-ips "$@"; }
alias mtrr='mtr --report-wide --report-cycles 3 --show-ips --aslookup --mpls'
alias mutagen='mid3v2'
alias muttgmail='mutt -e "set folder=imaps://imap.gmail.com spoolfile=+"' gmail='muttgmail'
alias muttwork='mutt -e "set folder=imaps://mail.utenos-kolegija.lt spoolfile=+"'
mvln() { mv "$1" "$2" && sym -v "$2" "$1"; }
alias nmap='nmap --reason'
alias nm-con='nmcli -f name,type,autoconnect,state,device con'
alias plink='plink -no-antispoof'
alias pring='prettyping'
alias py='python3'
alias py2='python2'
alias py3='python3'
alias qrdecode='zbarimg --quiet --raw'
alias rd='rmdir'
rdu() { (( $# )) || set -- */; du -hsc "$@" | awk '$1 !~ /K/ || $2 == "total"' | sort -h; }
alias re='hash -r && SILENT=1 . ~/.bashrc && echo reloaded .bashrc && :'
alias ere='set -a && . ~/.profile && set +a && echo reloaded .profile && :'
ressh() { ssh -v -S none "$@" "true"; }
alias rawhois='do: whois -h whois.ra.net --'
alias riswhois='do: whois -h riswhois.ripe.net --'
alias rot13='tr N-ZA-Mn-za-m A-Za-z'
alias run='spawn -c'
sp() { printf '%s' "$@"; printf '\n'; }
splitext() { split -dC "${2-32K}" "$1" "${1%.*}-" --additional-suffix=".${1##*.}"; }
alias sudo='sudo ' # for alias expansion in sudo args
alias telnets='telnet-ssl -z ssl'
_thiscommand() { history 1 | sed "s/^\s*[0-9]\+\s\+([^)]\+)\s\+$1\s\+//"; }
tigdiff() { diff -u "$@" | tig; }
alias todo:='todo "$(_thiscommand todo:)" #'
alias traceroute='traceroute -N3'
alias tracert='traceroute -I'
alias try-openconnect='openconnect --verbose --authenticate'
alias try-openvpn='openvpn --verb 3 --dev null --{ifconfig,route}-noexec --client'
up() { local p i=${1-1}; while ((i--)); do p+=../; done; cd "$p$2" && pwd; }
vercmp() {
	case $(command vercmp "$@") in
	-1) echo "$1 < $2";;
	 0) echo "$1 = $2";;
	 1) echo "$1 > $2";;
	esac
}
vimpaste() { vim <(getpaste "$1"); }
virdf() { vim -c "setf n3" <(rapper -q -o turtle "$@"); }
visexp() { (echo "; vim: ft=sexp"; echo "; file: $1"; sexp-conv < "$1") \
	| vipe | sexp-conv -s canonical | sponge "$1"; }
alias w3m='w3m -title'
wim() { local file=$(which "$1") && [[ $file ]] && editor "$file" "${@:2}"; }
alias unpickle='python -m pickletools'
alias unwine='tput rmkx' # Disable application keypad mode DECCKM+DECPNM
xar() { xargs -r -d '\n' "$@"; }
alias xf='ps xf -O ppid'
alias xx='chmod a+rx'
alias '~'='grep -E'
alias '~~'='grep -E -i'
-() { cd -; }
,() {
	for _a in "${@:-.}"; do
		if [[ $_a == *://* || -e $_a ]]
			then run xdg-open "$_a"
			else (. lib.bash; err "path '$_a' not found"); return
		fi
	done
}
,,() { show-file "$@"; }
alias open=,
bind -m emacs -x '"\e,": ,'
@cd() { cd "${1:+/net/$1}/${PWD#/net/*/}"; }
@pwd() { echo "${1:+/net/$1}/${PWD#/net/*/}"; }

for host in dust ember frost land myth rain sky star wind wolke; do
	alias $host="on $host -D"
	alias @$host="@ $host"
done

# dates

alias ssdate='date "+%Y%m%d"'
alias sdate='date "+%Y-%m-%d"'
alias mmdate='date "+%Y-%m-%d %H:%M"'
alias mdate='date "+%Y-%m-%d %H:%M:%S %z"'
alias ldate='date "+%A, %B %-d, %Y %H:%M"'
alias mboxdate='date "+%a %b %_d %H:%M:%S %Y"'
alias mimedate='date "+%a, %d %b %Y %H:%M:%S %z"' # RFC 2822
alias isodate='date "+%Y-%m-%dT%H:%M:%S%z"' # ISO 8601

# git bisect

alias good='git bisect good'
alias bad='git bisect bad'

# X11 clipboard

if have xclip; then
	alias psel='xclip -out -selection primary'
	alias gsel='xclip -in -selection primary'
	alias pclip='xclip -out -selection clipboard'
	alias gclip='xclip -in -selection clipboard'
	alias lssel='psel -target TARGETS'
	alias lsclip='pclip -target TARGETS'
elif have xsel; then
	alias psel='xsel -o -p -l /dev/null'
	alias gsel='xsel -i -p -l /dev/null'
	alias pclip='xsel -o -b -l /dev/null'
	alias gclip='xsel -i -b -l /dev/null'
fi

clip() {
	if (( $# )); then
		echo -n "$*" | gclip
	elif [[ ! -t 0 ]]; then
		gclip
	else
		pclip
	fi
}

# OS-dependent aliases

grepopt="--color=auto"
alias grep='grep $grepopt'
alias egrep='grep -E $grepopt'
alias fgrep='grep -F $grepopt'

lsopt="-F -h"
treeopt="-F --dirsfirst"
if (( UID == 0 )); then
	lsopt="$lsopt -a"
	treeopt="$treeopt -a"
fi
case $OSTYPE in
	linux-gnu*|cygwin)
		lsopt="$lsopt --color=auto"
		# Disable filename quoting in new Coreutils
		lsopt="$lsopt -N"
		eval $(dircolors ~/.dotfiles/dircolors)
		alias df='df -Th'
		alias dff='df -xtmpfs -xdevtmpfs -xrootfs -xecryptfs -xafs'
		alias ip='ip --color=auto'
		alias lsd='ls -d --indicator-style=none */'
		alias lsh='ls -a --ignore="[^.]*"'
		;;
	freebsd*)
		lsopt="$lsopt -G"
		alias df='df -h'
		;;
	gnu)
		lsopt="$lsopt --color=auto"
		eval $(dircolors ~/.dotfiles/dircolors)
		alias lsd='ls -a --ignore="[^.]*"'
		;;
	netbsd|openbsd*)
		alias df='df -h'
		;;
	*)
		alias df='df -h'
		;;
esac
alias ls="ls $lsopt"
unset lsopt
alias tree="tree $treeopt"
unset treeopt

hyls() { ls -C -w "$COLUMNS" --color --hyperlink "$@" | sed 's!file://!&/net/!g'; }

alias who='who -HT'

# misc functions

catlog() {
	printf '%s\n' "$1" "$1".* | natsort | tac | while read -r file; do
		case $file in
		    *.gz) zcat "$file";;
		    *)    cat "$file";;
		esac
	done
}

cat() {
	if [[ $1 == *://* ]]; then
		curl -LsfS "$1"
	else
		command cat "$@"
	fi
}

man() {
	if [[ $1 == *://* ]]; then
		curl -LsfS "$1" | command man /dev/stdin
	elif [[ $1 == *.[0-9]* && $1 != */* && ! $2 && -f $1 ]]; then
		command man "./$1"
	elif [[ $1 == annex ]]; then
		command man git-annex "${@:2}"
	else
		command man "$@"
	fi
}

oldssh() {
	ssh -o KexAlgorithms="+diffie-hellman-group1-sha1,diffie-hellman-group14-sha1" \
	    -o HostKeyAlgorithms="+ssh-rsa,ssh-dss" \
	    -o PubkeyAcceptedAlgorithms="+ssh-rsa" \
	    -o Ciphers="+3des-cbc" \
	    "$@";
}

alias tlsc='tlsg'

tlsg() {
	if [[ $2 == -p ]]; then
		set -- "$1" "${@:3}"
	fi
	local host=$1 port=${2:-443}
	gnutls-cli "$host" -p "$port" "${@:3}"
}

tlso() {
	if [[ $2 == -p ]]; then
		set -- "$1" "${@:3}"
	fi
	local host=$1 port=${2:-443}
	case $host in
	    *:*) local addr="[$host]";;
	    *)   local addr="$host";;
	esac
	openssl s_client -connect "$addr:$port" -servername "$host" \
		-verify_hostname "$host" -status -no_ign_eof -nocommands "${@:3}"
}

tlsb() {
	if [[ $2 == -p ]]; then
		set -- "$1" "--port=$3" "${@:4}"
	fi
	botan tls_client "$@"
}

tlscert() {
	if [[ $2 == -p ]]; then
		set -- "$1" "${@:3}"
	fi
	local host=$1 port=${2:-443}
	if have gnutls-cli; then
		tlsg "$host" "$port" --insecure --print-cert
	elif have openssl; then
		tlso "$host" "$port" -showcerts
	fi < /dev/null
}

alias sslcert='tlscert'

lspkcs12() {
	if [[ $1 == -g ]]; then
		certtool --p12-info --inder "${@:2}"
	elif [[ $1 == -n ]]; then
		pk12util -l "${@:2}"
	elif [[ $1 == -o ]]; then
		openssl pkcs12 -info -nokeys -in "${@:2}"
	fi
}

x509fp() {
	local file=${1:-/dev/stdin}
	openssl x509 -in "$file" -noout -fingerprint -sha256 | sed 's/.*=//' | tr A-F a-f
}

x509subj() {
	local file=${1:-/dev/stdin}
	openssl x509 -in "$file" -noout -subject -nameopt RFC2253 | sed 's/^subject=//'
}

x509subject() {
	local file=${1:-/dev/stdin}
	openssl x509 -in "$file" -noout -subject -issuer -nameopt multiline,dn_rev
}

# service management

if have systemctl && [[ -d /run/systemd/system ]]; then
	start()   { sudo systemctl start "$@";   _status "$@"; }
	stop()    { sudo systemctl stop "$@";    _status "$@"; }
	restart() { sudo systemctl restart "$@"; _status "$@"; }
	reload()  { sudo systemctl reload "$@";  _status "$@"; }
	status()  { SYSTEMD_PAGER='cat' systemctl status -a "$@"; }
	_status() { sudo SYSTEMD_PAGER='cat' systemctl status -a -n0 "$@"; }
	alias enable='sudo systemctl enable'
	alias disable='sudo systemctl disable'
	alias list='systemctl list-units -t path,service,socket --no-legend'
	alias userctl='systemctl --user'
	alias u='systemctl --user'
	alias y='systemctl'
	ustart()   { userctl start "$@";   userctl status -a "$@"; }
	ustop()    { userctl stop "$@";    userctl status -a "$@"; }
	urestart() { userctl restart "$@"; userctl status -a "$@"; }
	ureload()  { userctl reload "$@";  userctl status -a "$@"; }
	alias ulist='userctl list-units -t path,service,socket --no-legend'
	alias lcstatus='loginctl session-status $XDG_SESSION_ID'
	alias tsd='tree /etc/systemd/system'
	cgls() { SYSTEMD_PAGER='cat' systemd-cgls "$@"; }
	usls() { cgls "/user.slice/user-$UID.slice/$*"; }
fi

# shortcuts for making connections over alternate uplink

mycurl()       { do: curl --interface "$routed6" "$@"; }
mymtr()        { do: mtr -a "$routed6" "$@"; }
myping()       { do: ping -I "$routed6" "$@"; }
myssh()        { do: ssh -b "$routed6" "$@"; }
mytraceroute() { do: traceroute -s "$routed6" "$@"; }
mytracert()    { do: sudo traceroute --icmp -6 -s "$routed6" "$@"; }
mytracert6()   { do: tracert6 -s "$routed6" "$@"; }

if [[ $HOSTNAME == @(wolke|sky|ember|star|land) ]]; then
	//() {
		sudo birdc "$@"
	}
	//path() {
		sudo birdc show route all "$@" |
		ssh wolke "perl ~/bin/bird-bgpath"
	}
	//proto() {
		sudo birdc show protocols |
		perl -nE 'say join "", split /\s+/, $_, 7' |
		column -ts ''
	}
fi

if have broot; then
	br() {
		local tmp=$(mktemp) r=0 out
		broot --outcmd "$tmp" \
			--git-ignored \
			--no-trim-root \
			"$@"; r=$?
		if (( !r )) && [[ -s "$tmp" ]]; then
			echo "> $(<"$tmp")"
			eval "$(<"$tmp")"
		fi
		rm -f "$tmp"
		return $r
	}
fi

if have fzf; then
	export FZF_DEFAULT_OPTS="--height=30% --info=inline"

	_fzfyank() {
		local cmd=$1
		if [[ $cmd != "fd "* ]]; then
			local cmd="$cmd | xargs -d '\n' ls -dh --color=always"
		fi
		local pre=${READLINE_LINE:0:READLINE_POINT}
		local suf=${READLINE_LINE:READLINE_POINT}
		local qry=${pre##*[ /=]}
		local str=$(FZF_DEFAULT_COMMAND=$cmd fzf -q "$qry" --reverse --ansi)
		if [[ $str ]]; then
			pre=${pre%"$qry"}
			str=${str@Q}" "
			READLINE_LINE=${pre}${str}${suf}
			READLINE_POINT=$((READLINE_POINT - ${#qry} + ${#str}))
		fi
	}
	if have fd; then
		# Alt+[df] - local dir/all selection
		bind -m emacs -x '"\ed": _fzfyank "fd -I --strip-cwd-prefix --color=always --exact-depth=1 --type=d"'
		bind -m emacs -x '"\ef": _fzfyank "fd -I --strip-cwd-prefix --color=always --exact-depth=1"'
		# Alt+Shift+[DF] - recursive dir/all selection
		bind -m emacs -x '"\eD": _fzfyank "fd -I --strip-cwd-prefix --color=always --type=d"'
		bind -m emacs -x '"\eF": _fzfyank "fd -I --strip-cwd-prefix --color=always"'
	else
		# Alt+[df] - local dir/all selection
		bind -m emacs -x '"\ed": _fzfyank "compgen -d | sort"'
		bind -m emacs -x '"\ef": _fzfyank "compgen -f | sort"'
		# Alt+Shift+[DF] - recursive dir/all selection
		bind -m emacs -x '"\eD": _fzfyank "find . -xdev -mindepth 1 -name .\?\* -prune -o -type d -printf %P\\\n"'
		bind -m emacs -x '"\eF": _fzfyank "find . -xdev -mindepth 1 -name .\?\* -prune -o -printf %P\\\n"'
	fi

	_fzfyank_git_branch() {
		local cmd='git branch -a --sort=committerdate | tac | sed "s/^..//; s!^remotes/!!"'
		local pre=${READLINE_LINE:0:READLINE_POINT}
		local suf=${READLINE_LINE:READLINE_POINT}
		local qry=${pre##*[ .:]}
		local str=$(FZF_DEFAULT_COMMAND=$cmd fzf -q "$qry" --reverse --ansi)
		if [[ $str ]]; then
			str=${str%% *}
			pre=${pre%"$qry"}
			str=${str@Q}" "
			READLINE_LINE=${pre}${str}${suf}
			READLINE_POINT=$((READLINE_POINT - ${#qry} + ${#str}))
		fi
	}
	bind -m emacs -x '"\eb": _fzfyank_git_branch'
fi

if have chafa; then
	# Leave space for orig. command (1 line) + new prompt (3 lines)
	alias imgrgb='chafa --symbols=vhalf --size=$[COLUMNS]x$[LINES-1-3]'
	if [[ $TERM_PROGRAM == BlackBox ]]; then
		alias imgrgb='chafa -f sixel -s $[COLUMNS]x$[LINES-1-3]'
	fi
fi

if have step-cli; then
	# Arch's unusual packaging
	alias step='step-cli'
fi
