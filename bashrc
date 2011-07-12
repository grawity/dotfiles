#!bash
have() { command -v "$@" >& /dev/null; }

[[ $UNAME ]]	|| UNAME=$(uname)
[[ $SHELL ]]	|| SHELL=$XTERM_SHELL
[[ $USER ]]	|| USER=$LOGNAME
[[ $USER ]]	|| USER=$(id -un)
export UNAME SHELL USER
export GPG_TTY=$(tty)
export HOSTALIASES=~/.hosts
export NCURSES_NO_UTF8_ACS=1

[[ $LANG == *.utf8 ]] && LANG="${LANG%.utf8}.utf-8"

[[ -d ~/.cache ]] && mkdir -pm 0700 ~/.cache

### Interactive-only options

[[ $- = *i* ]] || return 0

shopt -os physical		# resolve symlinks on 'cd'
shopt -s checkjobs 2> /dev/null	# print job status on exit
shopt -s checkwinsize		# update $ROWS/$COLUMNS after command
shopt -s no_empty_cmd_completion

shopt -s cmdhist		# store multi-line commands as single history entry
shopt -s histappend		# append to $HISTFILE on exit
shopt -s histreedit		# allow re-editing failed history subst

HISTFILE=~/.cache/bash.history
HISTCONTROL=ignoreboth

### Command line completion

HOSTFILE=~/.hosts

complete -A directory cd

__expand_tilde_by_ref() { true; }

### Terminal

# color capabilities
case $TERM in
	xterm)
		havecolor=y
		if [[ -z $COLORTERM ]] && [[ -f /proc/$PPID/cmdline ]]; then
			read -r -d '' comm < /proc/$PPID/cmdline
			comm=${comm##*/}
			case $comm in
				gnome-terminal|konsole|xterm|yakuake)
					COLORTERM=$comm
					;;
			esac
			unset comm
		fi
		if [[ $COLORTERM ]]; then
			TERM="$TERM-256color"
		fi
		;;
	xterm-*)
		havecolor=y
		;;
	*)
		havecolor=$(have tput && tput setaf)
		;;
esac

# terminal window title
case $TERM in
	[xkE]term*|rxvt*|cygwin|screen*)
		titlestring='\e]0;%s\007';;
	#screen*)
	#	titlestring='\ek%s\e\\';;
esac

if [[ $havecolor ]]; then
	export -n PS1="\n"
	if (( $UID == 0 )); then
		PS1+="\[\e[;1;37;41m\]\h\[\e[m\]"
	elif [[ $USER == "grawity" ]]; then
		PS1+="\[\e[;1;32m\]\h\[\e[m\]"
	else
		PS1+="\[\e[;1;33m\]\u@\h\[\e[m\]"
	fi
	PS1+=" \[\e[36m\]\w\[\e[m\]"
	PS1+="\n\[\e[1m\]\\\$\[\e[m\] "
	export -n PS2="\[\e[;1;30m\]...\[\e[m\] "
	export PS4=""
	PS4+="+\e[34m\${BASH_SOURCE:-stdin}"
	PS4+=":\e[1m\$LINENO\e[m"
	PS4+=":\${FUNCNAME:+\e[33m\$FUNCNAME\e[m}"
	PS4+=" "
else
	export -n PS1="\u@\h \w\n\$ "
	export -n PS2="... "
	export PS4="+\${BASH_SOURCE:-stdin}:\$LINENO:\$FUNCNAME "
fi

title() { printf "$titlestring" "$*"; }

wname() { printf '\ek%s\e\\' "$*"; }

show_status() {
	local status=$?
	(( status )) && printf "\e[;33m%s\e[m\n" "(returned $status)"
}
update_title() {
	local title="$USER@$HOSTNAME ${PWD/#$HOME/~}"
	[[ $SSH_TTY && $DISPLAY ]] &&
		title+=" (X11)"
	title "$title"
}

PROMPT_COMMAND="show_status; update_title"
PROMPT_DIRTRIM=5

### Aliases
unalias -a

a() {
	if [[ $1 ]]; then
		alias "$@"
	else
		alias | perl -ne "
			if (@d = /^alias (.+?)='(.+)'\$/) {
				\$d[1] =~ s/'\\\''/'/g;
				\$d[1] =~ s/^(.*) $/'\$&'/;
				printf qq(%-10s %s\n), @d;
			}"
	fi
}

LSOPT="ls -Fh"
GREPOPT="grep"
if [[ $havecolor ]]; then
	GREPOPT="$GREPOPT --color=auto"
	#case $UNAME in
	case $OSTYPE in
		#Linux|CYGWIN_*)
		linux-gnu|cygwin)
			LSOPT="$LSOPT --color=auto"
			eval $(dircolors ~/lib/dotfiles/dircolors)
			;;
		#FreeBSD)
		freebsd*)
			LSOPT="$LSOPT -G"
			;;
	esac
fi
alias ls="$LSOPT"
alias grep="$GREPOPT"
unset LSOPT GREPOPT

editor() { eval "${EDITOR:-vim}" '"$@"'; }
browser() { eval "${BROWSER:-lynx}" '"$@"'; }
pager() { eval "${PAGER:-less}" '"$@"'; }

count() { sort | uniq -c | sort -n -r | pager; }
alias cur='cur '
alias df='df -Th'
alias dff='df -x tmpfs -x devtmpfs -x rootfs'
alias egrep='grep -E'
entity() { printf '&%s;' "$@" | w3m -dump -T text/html; }
finge() { [[ $1 == r* ]] && set -- "${1:1}" "${@:2}"; finger "$@"; }
g() { egrep -rn --color=always "$@" . | pager; }
alias hex='xxd -p'
alias hup='pkill -HUP -x'
alias iprules='iptables -L --line-numbers -n'
irc() { tmux attach -t irc || tmux new -s irc -n irssi "irssi $*"; }
alias ll='ls -l'
alias md='mkdir'
alias p='pager'
path() { echo "${PATH//:/$'\n'}"; }
alias preg='grep -P'
alias py='python'
alias py2='python2'
alias rd='rmdir'
alias rot13='tr N-ZA-Mn-za-m A-Za-z'
rpw() { tr -dc "A-Za-z0-9" < /dev/urandom | head -c "${1:-12}"; echo; }
alias sudo='sudo ' # for alias expansion in sudo args
alias tidiff='infocmp -Ld'
alias tube='youtube-dl --console-title --title'
up() { local p= i=${1:-1}; while (( i-- )); do p+=../; done; cd "$p$2" && pwd; }
alias w='PROCPS_USERLEN=16 w -s -h'
alias xx='chmod a+x'
X() { ("$@" &> /dev/null &); }
alias '~'='preg'

case $DESKTOP_SESSION in
gnome)
	alias logout='gnome-session-quit --logout --force --no-prompt'
	;;
esac

userports() { netstat -lte --numeric-host | sort -k 7; }

alias sd='systemctl'
alias tsd='tree /etc/systemd/system'
cgls() { systemd-cgls "$@" | pager; }
psls() {
	if [[ $1 == "-a" ]]; then
		cgls "/user/$USER"
	elif [[ $1 ]]; then
		cgls "/user/$1"
	else
		cgls "/user/$USER/${XDG_SESSION_ID:-$(</proc/self/sessionid)}"
	fi
}

if have systemctl; then
	start() { sudo systemctl start "$@"; systemctl status "$@"; }
	stop() { sudo systemctl stop "$@"; systemctl status "$@"; }
	restart() { sudo systemctl restart "$@"; systemctl status "$@"; }
	#alias start='systemctl start'
	#alias stop='systemctl stop'
	#alias restart='systemctl restart'
	alias enable='systemctl enable'
	alias disable='systemctl disable'
	alias status='systemctl status'
fi

alias lp='sudo netstat -lptu --numeric-hosts'
alias lpt='sudo netstat -lpt --numeric-hosts'
alias lpu='sudo netstat -lpu --numeric-hosts'

# list package contents
lspkg() {
	if [[ -z $1 ]]; then
		echo "$FUNCNAME: package not specified" >&2
		return 2
	elif have dpkg;		then dpkg -L "$@"
	elif have pacman;	then pacman -Qql "$@"
	elif have rpm;		then rpm -ql "$@"
	elif have pkg_info;	then pkg_info -Lq "$@"
	else echo "no package manager" >&2; return 1; fi
}

lcpkg() {
	lspkg "$@" | xargs -d '\n' ls -d --color=always 2>/dev/null | pager
}

llpkg() {
	lspkg "$@" | xargs -d '\n' ls -ld --color=always 2>/dev/null | pager
}

# list installed packages
lspkgs() {
	if have dpkg;		then dpkg -l | awk '/^i/ {print $2}'
	elif have pacman;	then pacman -Qq
	elif have pkg_info;	then pkg_info
	else echo "no package manager" >&2; return 1; fi
}

# list leftover configs from removed packages
lscruft() {
	if have dpkg;		then dpkg -l | awk '/^r/ {print $2}'
	elif have pacman;	then find /etc -name '*.pacsave'
	else echo "no package manager or configs not tracked" >&2; return 1; fi
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
	else echo "no package manager" >&2; return 1; fi
}

# install a package
getpkg() {
	if [[ -f $1 ]]; then
		if have dpkg;		then sudo dpkg -i "$@"
		elif have pacman;	then sudo pacman -U "$@"
		elif have rpm;		then sudo rpm -U "$@"
		elif have pkg_add;	then sudo pkg_add "$@"
		else echo "no package manager" >&2; return 1; fi
	else
		if have aptitude;	then sudo aptitude install "$@"
		elif have apt-get;	then sudo apt-get install "$@" \
			--no-install-recommends
		elif have pacman;	then sudo pacman -S "$@"
		elif have yum;		then sudo yum install "$@"
		elif have pkg_add;	then sudo pkg_add "$@"
		elif have mingw-get;	then mingw-get install "$@"
		else echo "no package manager" >&2; return 1; fi
	fi
}

google() {
	browser "http://www.google.com/search?q=$(urlencode "$*")"
}

rfc() {
	browser "http://tools.ietf.org/html/rfc$1"
}

wiki() {
	browser "http://en.wikipedia.org/w/index.php?search=$(urlencode "$*")"
}

todo() {
	if [[ $1 ]]; then
		echo "($(date +"%b %d")) $*" >> ~/todo
		nl ~/todo | tail -n 1
	elif [[ -s ~/todo ]]; then
		nl ~/todo
	fi
}
rmtodo() {
	sed -i "${1:-\$}d" ~/todo
	[[ -s ~/todo ]] || rm ~/todo
}

cmpc() {
	local host=$1 port= pass=
	if [[ $host ]]; then
		MPD_HOST=$host
		pass=$(getnetrc -df '%p' "mpd@$host")
	elif [[ -S ~/.cache/mpd/control ]]; then
		host=~/.cache/mpd/control
		if [[ -r ~/.config/mpd/password ]]; then
			pass=$(< ~/.config/mpd/password)
		fi
	fi
	if [[ $host && $pass ]]; then
		export MPD_HOST=${pass}@${host}
	elif [[ $host ]]; then
		export MPD_HOST=${host}
	else
		unset MPD_HOST MPD_PORT
	fi
}

cpans() {
	PERL_MM_OPT= PERL_MB_OPT= cpanm --sudo "$@"
}

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

alias sdate='date "+%Y-%m-%d %H:%M"'
alias ldate='date "+%A, %B %-d, %Y %H:%M"'
alias mboxdate='date "+%a %b %_d %H:%M:%S %Y"'		# mbox
alias mimedate='date "+%a, %d %b %Y %H:%M:%S %z"'	# RFC 2822
alias isodate='date "+%Y-%m-%dT%H:%M:%S%z"'		# ISO 8601

x509() {
	local file=${1:-/dev/stdin}
	if have certtool; then
		certtool -i <"$file" |
		sed -r '/^-----BEGIN/,/^-----END/d;
			/^\t*([0-9a-f][0-9a-f]:)+[0-9a-f][0-9a-f]$/d'
	else
		openssl x509 -noout -text -certopt no_pubkey,no_sigdump <"$file"
	fi
}

x509fp() {
	local file=${1:-/dev/stdin}
	openssl x509 -noout -fingerprint -sha1 -in "$file" |
		sed 's/^.*=//; y/ABCDEF/abcdef/'
}

sslcert() {
	if have gnutls-cli; then
		gnutls-cli "$1" -p "$2" --insecure --print-cert </dev/null | openssl x509
	elif have openssl; then
		openssl s_client -no_ign_eof -connect "$(escape_addr "$1"):$2" \
			</dev/null 2>/dev/null | openssl x509
	fi
}

sshfp() {
	local key=$(mktemp)
	ssh-keyscan -t rsa,dsa "$@" >> "$key"
	ssh-keygen -lf "$key"
	rm -f "$key"
}

tcp() {
	local host=$1 port=$2
	[[ $host = *:* ]] && host="[$host]"
	socat stdio tcp:"$host":"$port"
}

abs() {
	local pkg=$1
	if [[ $pkg != */* ]]; then
		local repo=$(pacman -Si "$pkg" | sed -nr 's/^Repository *: *(.+)$/\1/p' | sed 1q)
		[[ $repo ]] || return 1
		pkg="$repo/$pkg"
	fi
	echo "Downloading $pkg"
	command abs "$pkg" && cd "$ABSROOT/$pkg"
}

fixlog() {
	local file=$1 temp=; shift
	if ! [[ $file ]]; then
		echo "Usage: fixlog <file> <perl_condition>" >&2
		return 2
	fi
	temp=$(mktemp /tmp/log.XXXXXXXX)
	cp "$file" "$temp" && perl -ne "unless ($*) {print}" "$temp" > "$file"
	rm -f "$temp"
}

catlog() {
	local prefix=$1
	printf '%s\n' "$prefix" "$prefix".* | sort -rn | while read -r file; do
		if [[ $file == *.gz ]]; then
			zcat "$file"
		else
			cat "$file"
		fi
	done
}

### Environment

export ABSROOT=~/build
export ACK_PAGER=$PAGER
export LESS="-eMqR -FX"
export LESSHISTFILE=~/.cache/less.history
export MYSQL_HISTFILE=~/.cache/mysql.history
if [[ -f ~/.pythonrc ]]; then
	export PYTHONSTARTUP=~/.pythonrc
	export PYTHONHISTFILE=~/.cache/python.history
fi
export SUDO_PROMPT=$(printf 'sudo: Password for %%u@\e[30;43m%%h\e[m: ')

if [[ -f ~/lib/kc.bash ]]; then
	. ~/lib/kc.bash
fi

todo
