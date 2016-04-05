# bashrc -- aliases and functions

unalias -a

do:() { (PS4='+ '; set -x; "$@") }

editor() { command ${EDITOR:-vi} "$@"; }
browser() { command ${BROWSER:-lynx} "$@"; }
pager() { command ${PAGER:-more} "$@"; }

alias annex-wanted='git annex find --want-get --not --in .'
alias annex-unwanted='git annex find --want-drop --in .'
alias bat='acpi -i'
alias cal='cal -m'
catsexp() { cat "$@" | sexp-conv -w $COLUMNS; }
alias cindex='env TMPDIR=/var/tmp cindex'
alias cpans='PERL_MM_OPT= PERL_MB_OPT= cpanm --sudo'
count() { sort "$@" | uniq -c | sort -n -r | pager; }
alias csearch='csearch -n'
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
alias etoken-tool='pkcs11-tool --module libeTPkcs11.so'
alias gemalto-tool='pkcs11-tool --module /usr/lib/pkcs11/libgclib.so'
alias facl='getfacl -pt'
alias fdf='findmnt -o target,size,used,avail,use%,fstype'
fc-fontformat() {
	fc-list -f "%10{fontformat}: %{family}\n" \
	| sed 's/,.*//' | sort -t: -k2 -u
}
fc-file() { fc-query -f "%{file}: %{family} (%{fontversion}, %{fontformat})\n" "$@"; }
gerp() { egrep $grepopt -r -I -D skip --exclude-dir={.bzr,.git,.hg,.svn} -H -n "$@"; }
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
	alias logout='env logout'
fi
f() { find . \( -name .git -prune \) , \( -iname "*$1*" "${@:2}" \); }
ff() { find "$PWD" \( -name .git -prune \) , \( -iname "*$1*" "${@:2}" \) \
	| treeify "$PWD"; }
alias lchown='chown -h'
ldapls() {
	ldapsearch -LLL "$@" 1.1 | ldifunwrap | grep ^dn: \
	| perl -MMIME::Base64 -pe 's/^(.+?):: (.+)$/"$1: ".decode_base64($2)/e'
}
ldapshow() { ldapsearch -b "$1" -s base -LLL "${@:2}"; }
ldapstat() { ldapsearch -b "" -s base -x -LLL "$@" \* +; }
alias ldapvi='ldapvi --bind sasl'
alias lp='sudo netstat -lptu --numeric-hosts'
alias lpt='sudo netstat -lpt --numeric-hosts'
alias lpu='sudo netstat -lpu --numeric-hosts'
lscsr() { openssl req -in "${1:-/dev/stdin}" -noout -text; }
alias lsd='ls -d .*'
alias lspart='lsblk -o name,partlabel,size,fstype,label,mountpoint'
alias md='mkdir'
mir() { wget -m -np --reject-regex='.*\?C=.;O=.$' "$@"; }
alias mkcert='mkcsr -x509 -days 3650'
alias mkcsr='openssl req -new -sha256'
mkmaildir() { mkdir -p "${@/%//cur}" "${@/%//new}" "${@/%//tmp}"; }
alias mtrr='mtr --report-wide -c 3'
alias mutagen='mid3v2'
mv() {
	if [[ -t 0 && -t 1 && $# -eq 1 && -e $1 ]]; then
		local old=$1 new=$1
		read -p "rename to: " -e -i "$old" new
		[[ "$old" != "$new" ]] && command mv -v "$old" "$new"
	else
		command mv "$@"
	fi
}
alias nmap='nmap --reason'
alias nm-con='nmcli -f name,type,autoconnect,state,device con'
alias pamcan='pacman'
path() { if (( $# )); then which -a "$@"; else echo "${PATH//:/$'\n'}"; fi; }
alias py='python'
alias py2='python2'
alias py3='python3'
alias qrdecode='zbarimg --quiet --raw'
alias rd='rmdir'
alias re='hash -r && SILENT=1 . ~/.bashrc && echo reloaded .bashrc && :'
alias ere='set -a && . ~/.profile && set +a && echo reloaded .profile && :'
ressh() { ssh -v \
	-o ControlPersist=no \
	-o ControlMaster=no \
	-o ControlPath=none \
	"$@" ":"; }
alias riswhois='do: whois -h riswhois.ripe.net'
alias rot13='tr N-ZA-Mn-za-m A-Za-z'
rpw() { tr -dc "A-Za-z0-9" < /dev/urandom | head -c "${1:-12}"; echo; }
alias run='spawn -c'
alias rsync='rsync -s'
sp() { printf '%s' "$@"; printf '\n'; }
splitext() { split -dC "${2-32K}" "$1" "${1%.*}-" --additional-suffix=".${1##*.}"; }
alias srs='rsync -vshzaHAX'
alias sudo='sudo ' # for alias expansion in sudo args
alias telnets='telnet-ssl -z ssl'
_thiscommand() { history 1 | sed "s/^\s*[0-9]\+([^)]\+)\s\+$1\s\+//"; }
alias tidiff='infocmp -Ld'
alias todo:='todo "$(_thiscommand todo:)" #'
alias traceroute='traceroute -e'
alias tracert='traceroute -I --mtu'
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
alias unwine='printf "\e[?1l \e>"'
alias xf='ps xf -O ppid'
alias xx='chmod a+rx'
alias ypiv='yubico-piv-tool'
alias zt1='zerotier-cli'
alias '~'='egrep'
alias '~~'='egrep -i'
-() { cd -; }
[() {
	if [[ $# -eq 0 || "${@:$#}" == "]" ]]; then
		builtin [ "$@"
	else
		pushd "$*"
	fi
}
]() { popd; }

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

# conditional aliases

if ! have annex; then
	alias annex='git annex'
fi

if have mpv; then
	alias mplayer='mpv'
fi

if have xdg-open; then
	alias open='run xdg-open'
fi

# X11 clipboard

if have xsel; then
	alias psel='xsel -o -p -l /dev/null'
	alias gsel='xsel -i -p -l /dev/null'
	alias pclip='xsel -o -b -l /dev/null'
	alias gclip='xsel -i -b -l /dev/null'
elif have xclip; then
	alias psel='xclip -out -selection primary'
	alias gsel='xclip -in -selection primary'
	alias pclip='xclip -out -selection clipboard'
	alias gclip='xclip -in -selection clipboard'
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

sel() {
	if (( $# )); then
		echo -n "$*" | gsel
	elif [[ ! -t 0 ]]; then
		gsel
	else
		psel
	fi
}

# OS-dependent aliases

grepopt="--color=auto"
alias grep='grep $grepopt'
alias egrep='egrep $grepopt'
alias fgrep='fgrep $grepopt'

lsopt="-F -h"
if (( UID == 0 )); then
	lsopt="$lsopt -a"
fi
case $OSTYPE in
	linux-gnu*|cygwin)
		lsopt="$lsopt --color=auto"
		# fix unnecessary filename quoting
		# (coreutils 8.25 commit 109b9220cead6e979d22d16327c4d9f8350431cc)
		lsopt="$lsopt -N"
		eval $(dircolors ~/lib/dotfiles/dircolors 2>/dev/null)
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
		lsopt="$lsopt --color=auto"
		eval $(dircolors ~/lib/dotfiles/dircolors 2>/dev/null)
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

alias tlsc='tlsg'

tlsg() {
	local host=$1 port=${2:-443}
	gnutls-cli "$host" -p "$port" "${@:3}"
}

tlso() {
	local host=$1 port=${2:-443}
	case $host in
	    *:*) local addr="[$host]";;
	    *)   local addr="$host";;
	esac
	openssl s_client -connect "$addr:$port" -servername "$host" \
		-status -no_ign_eof "${@:3}"
}

sslcert() {
	local host=$1 port=$2
	if have gnutls-cli; then
		tlsg "$host" "$port" --insecure --print-cert
	elif have openssl; then
		tlso "$host" "$port" -showcerts
	fi
}

x509fp() {
	local file=${1:-/dev/stdin}
	openssl x509 -noout -fingerprint -sha1 -in "$file" |
		sed 's/^.*=//; y/ABCDEF/abcdef/'
}

# package management

lspkgs() {
	if have dpkg;		then dpkg -l | awk '/^i/ {print $2}'
	elif have pacman;	then pacman -Qq
	elif have rpm;		then rpm -qa --qf "%{NAME}\n"
	elif have pkg_info;	then pkg_info
	elif have apt-cyg;	then apt-cyg show
	else echo "$FUNCNAME: no known package manager" >&2; return 1; fi
}

lspkg() {
	if [[ -z $1 ]]
	then echo "$FUNCNAME: package not specified" >&2; return 2
	elif have dpkg; then dpkg -L "$@"
	elif have pacman; then pacman -Qql "$@"
	elif have rpm; then rpm -ql "$@"
	elif have pkg; then
		case $OSTYPE in
			FreeBSD) pkg query %Fp "$@";;
		esac
	elif have pkg_info; then pkg_info -Lq "$@"
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

nosr() {
	if have pkgfile;	then pkgfile "$@"
	elif have apt-file;	then apt-file "$@"
	elif have yum;		then yum whatprovides "$@"
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

# service management

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
elif have service; then
	# Debian, other LSB
	start()   { for _s; do sudo service "$_s" start; done; }
	stop()    { for _s; do sudo service "$_s" stop; done; }
	restart() { for _s; do sudo service "$_s" restart; done; }
	status()  { for _s; do sudo service "$_s" status; done; }
	enable()  { for _s; do sudo update-rc.d "$_s" enable; done; }
	disable() { for _s; do sudo update-rc.d "$_s" disable; done; }
fi
