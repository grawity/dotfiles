# bashrc -- aliases and functions

unalias -a

do:() { (PS4='+ '; set -x; "$@") }

editor() { command ${EDITOR:-vi} "$@"; }
browser() { command ${BROWSER:-lynx} "$@"; }
pager() { command ${PAGER:-more} "$@"; }

alias bat='acpi -i'
alias cindex='env TMPDIR=/var/tmp cindex'
count() { sort "$@" | uniq -c | sort -n -r | pager; }
alias csearch='csearch -n'
alias cur='cur '
dist/head() {
	echo -e "\e[1m== ~/code\e[m"
	(cd ~/code && git tip)
	echo
	echo -e "\e[1m== ~/lib/dotfiles\e[m"
	(cd ~/lib/dotfiles && git tip)
}
dist/pull() { ~/code/dist/pull "$@" && SILENT=1 . ~/.profile; }
alias dnstracer='dnstracer -s .'
alias ed='ed -p:'
entity() { printf '&%s;<br>' "$@" | w3m -dump -T text/html; }
alias facl='getfacl -pt'
alias fdf='findmnt -o target,size,used,avail,use%,fstype'
gerp() { egrep -r -I -D skip --exclude-dir={.bzr,.git,.hg,.svn} -H -n "$@"; }
gpgfp() { gpg --with-colons --fingerprint "$1" | awk -F: '/^fpr:/ {print $10}'; }
alias hex='xxd -p'
alias unhex='xxd -p -r'
alias hup='pkill -HUP -x'
alias init='telinit' # for systemd
alias kssh='ssh \
	-o PreferredAuthentications=gssapi-keyex,gssapi-with-mic \
	-o GSSAPIAuthentication=yes \
	-o GSSAPIDelegateCredentials=yes'
alias l='ls -log'
alias ll='ls -l'
alias logoff='logout'
if [[ $DESKTOP_SESSION ]]; then
	alias logout='~/code/x11/logout'
fi
look() { find . -iname "*$1*" "${@:2}"; }
f() { find "$PWD" -iname "*$1*" "${@:2}" | treeify "$PWD"; }
alias lchown='chown -h'
ldapls() {
	ldapsearch -LLL "$@" 1.1 | ldifunwrap | grep ^dn: \
	| perl -MMIME::Base64 -pe 's/^(.+?):: (.+)$/"$1: ".decode_base64($2)/e'
}
ldapstat() { ldapsearch -b "" -s base -x -LLL "$@" \* +; }
alias lp='sudo netstat -lptu --numeric-hosts'
alias lpt='sudo netstat -lpt --numeric-hosts'
alias lpu='sudo netstat -lpu --numeric-hosts'
alias lsd='ls -d .*'
alias lspart='lsblk -o name,partlabel,fstype,label,mountpoint'
alias md='mkdir'
mir() { wget -m -np --reject-regex='.*\?C=.;O=.$' "$@"; }
alias mutagen='mid3v2'
mv() {
	if [[ -t 0 && -t 1 && $# -eq 1 && -e $1 ]]; then
		local old=$1 new=$1
		read -p "rename to: " -e -i "$old" new
		[[ "$old" != "$new" ]] &&
		command mv -v "$old" "$new"
	else
		command mv "$@"
	fi
}
alias nmap='nmap --reason'
alias nosr='pkgfile -v'
path() { if (( $# )); then which -a "$@"; else echo "${PATH//:/$'\n'}"; fi; }
alias py='python'
alias py2='python2'
alias py3='python3'
alias rd='rmdir'
rdempty() { find "$@" -depth -type d -exec rmdir --ignore-fail-on-non-empty {} +; }
alias re='hash -r && SILENT=1 . ~/.bashrc && echo reloaded .bashrc && :'
alias ere='set -a && . ~/.profile && set +a && echo reloaded .profile && :'
ressh() { ssh -v \
	-o ControlPersist=no \
	-o ControlMaster=no \
	-o ControlPath=none \
	"$@" ":"; }
alias rot13='tr N-ZA-Mn-za-m A-Za-z'
rpw() { tr -dc "A-Za-z0-9" < /dev/urandom | head -c "${1:-12}"; echo; }
alias run='spawn -c'
sp() { printf '%s' "$@"; printf '\n'; }
splitext() { split -dC "${2-32K}" "$1" "${1%.*}-" --additional-suffix=".${1##*.}"; }
alias srs='rsync -vhzaHAX'
alias sudo='sudo ' # for alias expansion in sudo args
alias telnets='telnet-ssl -z ssl'
_thiscommand() { history 1 | sed "s/^\s*[0-9]\+\s\+$1\s\+//"; }
alias tidiff='infocmp -Ld'
alias todo:='todo "$(_thiscommand todo:)" #'
alias traceroute='traceroute -e -A'
alias tracert='traceroute -I'
alias treedu='tree --du -h'
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
wim() { local w=$(which "$1") && [[ $w ]] && editor "$w"; }
alias xf='ps xf -O ppid'
alias xx='chmod a+x'
alias zt1='zerotier-cli'
alias '~'='egrep'
alias '~~'='egrep -i'
-() { cd -; }
[() {
	if [[ "${@:$#}" == "]" ]]; then
		test "${@:1:$#-1}"
	else
		pushd "$*"
	fi
}
]() { popd; }

alias good='git bisect good'
alias bad='git bisect bad'

alias ssdate='date "+%Y%m%d"'
alias sdate='date "+%Y-%m-%d"'
alias sfdate='date "+%Y-%m-%d %H:%M"'
alias ldate='date "+%A, %B %-d, %Y %H:%M"'
alias mboxdate='date "+%a %b %_d %H:%M:%S %Y"'
alias mimedate='date "+%a, %d %b %Y %H:%M:%S %z"' # RFC 2822
alias isodate='date "+%Y-%m-%dT%H:%M:%S%z"' # ISO 8601

if have xclip; then
	alias psel='xclip -out -selection primary'
	alias gsel='xclip -in -selection primary'
	alias pclip='xclip -out -selection clipboard'
	alias gclip='xclip -in -selection clipboard'
elif have xsel; then
	alias psel='xsel -o -p'
	alias gsel='xsel -i -p'
	alias pclip='xsel -o -b'
	alias gclip='xsel -i -b'
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

if have xdg-open; then
	alias open='run xdg-open'
fi

if have mpv; then
	alias mplayer='mpv'
fi

## OS-dependent aliases

export GREP_OPTIONS='--color=auto'

lsopt="-F -h"
if (( UID == 0 )); then
	lsopt="$lsopt -a"
fi
case $OSTYPE in
	linux-gnu*|cygwin)
		if (( havecolor )); then
			lsopt="$lsopt --color=auto"
			eval $(dircolors ~/lib/dotfiles/dircolors 2>/dev/null)
		fi
		alias df='df -Th'
		alias dff='df -xtmpfs -xdevtmpfs -xrootfs -xecryptfs'
		alias lsd='ls -a --ignore="[^.]*"'
		alias w='PROCPS_USERLEN=16 w -hsu'
		;;
	freebsd*)
		lsopt="$lsopt -G"
		alias df='df -h'
		alias w='w -h'
		;;
	gnu)
		if (( havecolor )); then
			lsopt="$lsopt --color=auto"
			eval $(dircolors ~/lib/dotfiles/dircolors 2>/dev/null)
		fi
		alias lsd='ls -a --ignore="[^.]*"'
		alias w='w -hU'
		;;
	netbsd|openbsd*)
		alias df='df -h'
		alias w='w -h'
		;;
	*)
		alias df='df -h'
		;;
esac
alias ls="ls $lsopt"
unset lsopt

alias who='who -HT'

## misc functions

abs() {
	local pkg=$1
	if [[ $pkg != */* ]]; then
		local repo=$(pacman -Si "$pkg" \
			| sed -rn '/^Repository *: *(.+)$/{s//\1/p;q}')
		[[ $repo ]] || return 1
		pkg="$repo/$pkg"
	fi
	echo "Downloading $pkg"
	command abs "$pkg" && cd "$ABSROOT/$pkg"
}

catlog() {
	printf '%s\n' "$1" "$1".* | sort -rn | while read -r file; do
		case $file in
		    *.gz) zcat "$file";;
		    *)    cat "$file";;
		esac
	done
}

cpans() {
	PERL_MM_OPT= PERL_MB_OPT= cpanm --sudo "$@"
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
	else
		command man "$@"
	fi
}

putenv() {
	local pid=$1 var val args=()
	for var in "${@:2}"; do
		val=$(urlencode -x "${!var}")
		var=$(urlencode -x "$var")
		args=("${args[@]}" "-ex" "p putenv(\"$var=$val\")")
	done
	args gdb --batch "${args[@]}" -ex detach -p "$pid"
	gdb --batch "${args[@]}" -ex detach -p "$pid"
}

sslcert() {
	local host=$1 port=$2
	case $host in
	    *:*) local addr="[$host]";;
	    *)   local addr="$host";;
	esac
	if have gnutls-cli; then
		gnutls-cli "$1" -p "$2" --insecure --print-cert </dev/null | openssl x509
	elif have openssl; then
		openssl s_client -no_ign_eof -connect "$addr:$port" \
			</dev/null 2>/dev/null | openssl x509
	fi
}

x509() {
	local file=${1:-/dev/stdin}
	if have certtool; then
		certtool -i <"$file" |
		sed -r '/^-----BEGIN/,/^-----END/d;
			/^\t*([0-9a-f][0-9a-f]:)+[0-9a-f][0-9a-f]$/d;
			/^\t.*random art:$/,/^\t\t\+-+\+$/d'
	else
		openssl x509 -noout -text -certopt no_pubkey,no_sigdump <"$file"
	fi
}

x509der() {
	local file=${1:-/dev/stdin}
	if have certtool; then
		certtool --inder -i <"$file" |
		sed -r '/^-----BEGIN/,/^-----END/d;
			/^\t*([0-9a-f][0-9a-f]:)+[0-9a-f][0-9a-f]$/d;
			/^\t.*random art:$/,/^\t\t\+-+\+$/d'
	else
		openssl x509 -inform der -noout -text -certopt no_pubkey,no_sigdump <"$file"
	fi
}

x509fp() {
	local file=${1:-/dev/stdin}
	openssl x509 -noout -fingerprint -sha1 -in "$file" |
		sed 's/^.*=//; y/ABCDEF/abcdef/'
}

## package management

lspkgs() {
	if have dpkg;		then dpkg -l | awk '/^i/ {print $2}'
	elif have pacman;	then pacman -Qq
	elif have pkg_info;	then pkg_info
	elif have apt-cyg;	then apt-cyg show
	else echo "$FUNCNAME: no known package manager" >&2; return 1; fi
}

lspkg() {
	if [[ -z $1 ]]
	then echo "$FUNCNAME: package not specified" >&2; return 2
	elif have dpkg;		then dpkg -L "$@"
	elif have pacman;	then pacman -Qql "$@"
	elif have rpm;		then rpm -ql "$@"
	elif have pkg_info;	then pkg_info -Lq "$@"
	#elif have pkg;		then pkg -l "$@"
	else echo "$FUNCNAME: no known package manager" >&2; return 1
	fi | sort
}

lcpkg() {
	lspkg "$@" | xargs -d '\n' ls -d --color=always 2>&1 | pager
}

llpkg() {
	lspkg "$@" | xargs -d '\n' ls -ldh --color=always 2>&1 | pager
}

lscruft() {
	if have dpkg;		then dpkg -l | awk '/^r/ {print $2}'
	elif have pacman;	then find /etc -name '*.pacsave'
	else echo "$FUNCNAME: no known package manager" >&2; return 1; fi
}

owns() {
	local file=$1
	if [[ $file != */* ]] && have "$file"; then
		file=$(which "$file")
	fi
	file=$(readlink -f "$file")
	if have dpkg;		then dpkg -S "$file"
	elif have pacman;	then pacman -Qo "$file"
	elif have rpm;		then rpm -q --whatprovides "$file"
	elif have pkg;		then pkg which "$file"
	elif have apt-cyg;	then apt-cyg packageof "$file"
	else echo "$FUNCNAME: no known package manager" >&2; return 1; fi
}

## service management

if have systemctl && [[ -d /run/systemd/system ]]; then
	start()   { sudo systemctl start "$@";   systemctl status -a "$@"; }
	stop()    { sudo systemctl stop "$@";    systemctl status -a "$@"; }
	restart() { sudo systemctl restart "$@"; systemctl status -a "$@"; }
	reload()  { sudo systemctl reload "$@";  systemctl status -a "$@"; }
	status()  { systemctl status -a "$@"; }
	alias enable='sudo systemctl enable'
	alias disable='sudo systemctl disable'
	alias list='systemctl list-units -t path,service,socket --no-legend'
	alias userctl='systemctl --user'
	alias sd='systemctl'
	alias u='systemctl --user'
	ustart()   { userctl start "$@";   userctl status -a "$@"; }
	ustop()    { userctl stop "$@";    userctl status -a "$@"; }
	urestart() { userctl restart "$@"; userctl status -a "$@"; }
	ureload()  { userctl reload "$@";  userctl status -a "$@"; }
	alias ulist='userctl list-units -t path,service,socket --no-legend'
	alias lcstatus='loginctl session-status $XDG_SESSION_ID'
	alias tsd='tree /etc/systemd/system'
	cgls() { SYSTEMD_PAGER='cat' systemd-cgls "$@"; }
	usls() { cgls "/user.slice/user-$UID.slice/$*"; }
	psls() { cgls "/user.slice/user-$UID.slice/session-$XDG_SESSION_ID.scope"; }
elif have start && have stop; then
	# Upstart
	start()   { sudo start "$@"; }
	stop()    { sudo stop "$@"; }
	restart() { sudo restart "$@"; }
elif have service; then
	# Debian, other LSB
	start()   { for _s; do sudo service "$_s" start; done; }
	stop()    { for _s; do sudo service "$_s" stop; done; }
	restart() { for _s; do sudo service "$_s" restart; done; }
fi
