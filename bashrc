#!bash
# ~/.bashrc: bash(1)

[[ $DEBUG ]] && echo "++ bashrc [self=$0 prefix=$PREFIX]"

have() { command -v "$1" >&/dev/null; }

### Environment

[[ $PREFIX ]] ||
	. ~/lib/dotfiles/environ

[[ $PREFIX ]] ||
	. ~/.profile

[[ $USER ]] ||
	export USER=${LOGNAME:-$(id -un)}

export GPG_TTY=$(tty)
export HOSTALIASES=~/.hosts

[[ $LANG == *.utf8 ]] &&
	LANG=${LANG/%'.utf8'/'.utf-8'}

### Interactive-only options

[[ $- = *i* ]] || return 0

[[ $DEBUG ]] && echo ".. bashrc [interactive=$-]"

shopt -os physical		# resolve symlinks on 'cd'
shopt -s checkjobs 2> /dev/null	# print job status on exit
shopt -s checkwinsize		# update $ROWS/$COLUMNS after command
shopt -s no_empty_cmd_completion

shopt -s cmdhist		# store multi-line commands as single history entry
shopt -s histappend		# append to $HISTFILE on exit
shopt -s histreedit		# allow re-editing failed history subst

HISTFILE=~/.cache/bash.history
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth

### Command line completion

HOSTFILE=~/.hosts

complete -A directory cd

### Terminal

# color capabilities
case $TERM in
	xterm)
		havecolor=y
		if [[ -z $COLORTERM ]] && [[ -f /proc/$PPID/cmdline ]]; then
			read -r -d '' comm </proc/$PPID/cmdline
			comm=${comm##*/}
			case $comm in
				gnome-terminal|konsole|xterm|yakuake)
					COLORTERM=$comm
					;;
				kdeinit4:*konsole*)
					COLORTERM=konsole
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
	'')
		havecolor=n
		;;
	*)
		havecolor=$(have tput && tput setaf)
		;;
esac

# terminal window title
case $TERM in
	[xkE]term*|rxvt*|cygwin|screen*|dtterm)
		titlestring='\e]0;%s\007';;
	*)
		titlestring='';
esac

__ps1_pwd() {
	local dir=${PWD/#$HOME/\~} pref= suff= coll=0
	local maxw=$(( COLUMNS - ${#HOSTNAME} - 4 ))
	if [[ $dir == '~' ]]; then
		pref='' suff=$dir
	else
		pref=${dir%/*}/ suff=${dir##*/}
	fi
	if [[ ${dir:0:2} == '~/' ]]; then
		maxw=$(( maxw - 2 ))
	fi
	if (( ${#suff} > maxw )); then
		pref=${pref##*/}
		coll=1
	else
		while (( ${#pref} + ${#suff} > maxw )); do
			pref=${pref#*/}
			coll=1
		done
	fi
	if (( coll )); then
		pref='…/'$pref
		if [[ ${dir:0:2} == '~/' ]]; then
			pref='~/'$pref
		fi
	fi
	printf '%s\001\e[%sm\002%s\001\e[0m\002' "$pref" "$color_cwd" "$suff"
}

__ps1_git() {
	if have git; then
		local r
		r=$(git symbolic-ref HEAD 2>/dev/null) ||
		r=$(git rev-parse --short HEAD 2>/dev/null)
		r=${r#refs/heads/}
		if [[ $r ]]; then
			printf '\001\e[m\e[%sm\002%s\001\e[m\002' "$color_vcs" "$r"
		fi
	fi
}

__ps1_git_new() {
	local g=$(have git && git rev-parse --git-dir 2>/dev/null) r=
	if [[ $g ]]; then
		r=$(<"$g/HEAD")
		r=${r#ref: }
		r=${r#refs/heads/}
	fi
}

__is_remote() {
	[[ $SSH_TTY || $LOGIN || $REMOTEHOST ]]
}

if [[ $havecolor ]]; then
	PS1="\n"
	if (( $UID == 0 )); then
		color_name='37;41'
		item='\h'
		prompt='#'
	elif [[ $USER == "grawity" ]]; then
		color_name='38;5;71'
		item='\h'
		prompt='$'
	else
		color_name='33'
		item='\u@\h'
		prompt='$'
	fi
	color_pwd='38;5;144'
	color_cwd='1'
	color_vcs='38;5;167'
	color_prompt=''

	__is_remote && prompt='^'

	PS1+="\[\e[;1m\e[\${color_name}m\]${item}\[\e[m\] "
	[[ $TAG ]] &&
		PS1+="\[\e[;34m\]${TAG}:\[\e[m\]"
	#PS1+="\[\e[36m\]\w\[\e[m\]"
	PS1+="\[\e[m\e[\${color_pwd}m\]\$(__ps1_pwd)\[\e[m\] "
	PS1+="\[\e[m\e[\${color_vcs}m\]\$(__ps1_git)\[\e[m\]\n"
	PS1+="\[\e[m\e[\${color_prompt}m\]\${prompt}\[\e[m\] "

	PS2="\[\e[;1;30m\]...\[\e[m\] "
	PS4="+\e[34m\${BASH_SOURCE:--}:\e[1m\$LINENO\e[m:\${FUNCNAME:+\e[33m\$FUNCNAME\e[m} "
else
	PS1='\u@\h \w\n\$ '
	PS2='... '
	PS4="+\${BASH_SOURCE:--}:\$LINENO:\$FUNCNAME "
fi

export -n PS1 PS2; export PS4

settitle() { printf "$titlestring" "$*"; }

setwname() { printf '\ek%s\e\\' "$*"; }

show_status() {
	local status=$?
	(( status )) && printf "\e[;33m%s\e[m\n" "(returned $status)"
}
update_title() {
	if [[ ! $title ]]; then
		local title=
		[[ $USER != 'grawity' ]] && title+="$USER@"
		title+="$HOSTNAME ${PWD/#$HOME/~}"
		[[ $DISPLAY && ( $SSH_TTY || $DISPLAY != ':'* ) ]] &&
			title+=" ($DISPLAY)"
	fi
	printf "$titlestring" "$title"
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
				\$d[1] =~ s/^(.*)\s$/'\$&'/;
				printf qq(%-10s %s\n), @d;
			}"
	fi
}

LS_OPTIONS="ls -Fh"
if [[ $havecolor ]]; then
	case $OSTYPE in
		linux-gnu|cygwin)
			LS_OPTIONS="$LS_OPTIONS -v --color=auto"
			eval $(dircolors ~/lib/dotfiles/dircolors)
			;;
	esac
fi
alias ls="$LS_OPTIONS"
unset LS_OPTIONS

editor() { eval command "${EDITOR:-vim}" '"$@"'; }
browser() { eval command "${BROWSER:-lynx}" '"$@"'; }
pager() { eval command "${PAGER:-less}" '"$@"'; }

count() { sort "$@" | uniq -c | sort -n -r | pager; }
alias cur='cur '
alias dnstracer='dnstracer -s .'
entity() { printf '&%s;<br>' "$@" | w3m -dump -T text/html; }
g() { egrep -rn --color=always "$@" .; }
alias facl='getfacl -pt'
gpgsigs() { gpg --edit-key "$1" check quit; }
alias hex='xxd -p'
alias hup='pkill -HUP -x'
irc() { tmux attach -t irc || tmux new -s irc -n irssi "irssi $*"; }
alias ll='ls -l'
alias md='mkdir'
nul() { cat "$@" | tr '\0' '\n'; }
alias p='pager'
path() { if [[ $1 ]]; then which -a "$@"; else echo "${PATH//:/$'\n'}"; fi; }
alias py='python'
alias py2='python2'
alias py3='python3'
alias rd='rmdir'
alias rot13='tr N-ZA-Mn-za-m A-Za-z'
rpw() { tr -dc "A-Za-z0-9" < /dev/urandom | head -c "${1:-12}"; echo; }
alias sudo='sudo ' # for alias expansion in sudo args
alias tidiff='infocmp -Ld'
alias tracert='traceroute'
tube() {
	local title=$(youtube-dl -e "$1")
	read -e -p 'Title: ' -i "$title" title
	youtube-dl --console-title -c -o "${title//%/%%}.%(ext)s" "$@"
}
tubex() { youtube-dl --console-title -c -o "%(title)s.%(ext)s" "$@"; }
tubes() { youtube-dl --console-title -c --title "$@"; }
up() { local p= i=${1:-1}; while ((i--)); do p+=../; done; cd "$p$2" && pwd; }
alias w='PROCPS_USERLEN=16 w -s -h'
wim() { editor "$(which "$1")"; }
alias xx='chmod a+x'
X() { (setsid "$@" &>> ~/.xsession-errors &); }
alias '~'='grep -P'
alias '~~'='grep -P -i'
alias takeown='sudo chown "${UID}:${GROUPS[0]}"'

case $OSTYPE in
	linux-gnu)
		alias df='df -Th'
		alias dff='df -xtmpfs -xdevtmpfs -xrootfs -xecryptfs'
		;;
	*)
		alias df='df -h'
		;;
esac

ldapsetconf() {
	if [[ $1 ]]; then
		export LDAPCONF="$1"
	else
		unset LDAPCONF
	fi
}

alias logoff='logout'

case $DESKTOP_SESSION in
gnome|ubuntu)
	alias logout='gnome-session-quit --logout --force --no-prompt &&
		echo Logging out of GNOME...'
	;;
kde-plasma)
	alias logout='qdbus org.kde.ksmserver /KSMServer logout 0 -1 -1 &&
		echo Logging out of KDE...'
	;;
openbox)
	alias logout='openbox --exit &&
		echo Logging out of Openbox...'
	;;
esac

if have systemctl; then
	start()   { sudo systemctl start "$@"; systemctl status "$@"; }
	stop()    { sudo systemctl stop "$@"; systemctl status "$@"; }
	restart() { sudo systemctl restart "$@"; systemctl status "$@"; }
	alias enable='sudo systemctl enable'
	alias disable='sudo systemctl disable'
	alias status='systemctl status'
	alias userctl='systemctl --user'
	alias lcstatus='loginctl session-status $XDG_SESSION_ID'
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
elif have start && have stop; then
	start()   { sudo start "$@"; }
	stop()    { sudo stop "$@"; }
	restart() { sudo restart "$@"; }
elif have service; then
	start()   { for _s; do sudo service "$_s" start; done; }
	stop()    { for _s; do sudo service "$_s" stop; done; }
	restart() { for _s; do sudo service "$_s" restart; done; }
elif have rc.d; then
	start()   { sudo rc.d start "$@"; }
	stop()    { sudo rc.d stop "$@"; }
	restart() { sudo rc.d restart "$@"; }
elif have invoke-rc.d; then
	start()   { for _s; do sudo invoke-rc.d "$_s" start; done; }
	stop()    { for _s; do sudo invoke-rc.d "$_s" stop; done; }
	restart() { for _s; do sudo invoke-rc.d "$_s" restart; done; }
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
	else echo "no package manager" >&2; return 1
	fi | sort
}

lcpkg() {
	lspkg "$@" | xargs -d '\n' ls -d --color=always 2>/dev/null | pager
}

llpkg() {
	lspkg "$@" | xargs -d '\n' ls -ldh --color=always 2>/dev/null | pager
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

cmpc() {
	local host=$1 port= pass=
	if [[ $host == ?*@?* ]]; then
		pass=${host%@*}
		host=${host##*@}
	elif [[ $host ]]; then
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

escape_addr() {
	if [[ $1 == *:* ]]; then
		echo "[$1]"
	else
		echo "$1"
	fi
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

man() {
	if [[ $1 == *://* ]]; then
		curl -Ls "$1" | command man /dev/stdin
	else
		command man "$@"
	fi
}

### Environment

export CVS_RSH=ssh

export GREP_OPTIONS='--color=auto'
export SUDO_PROMPT=$(printf 'sudo: Password for %%u@\e[30;43m%%h\e[m: ')

if have pklist; then
	. ~/code/kerberos/kc.bash
fi

if [[ -f ~/.bashrc-"$HOSTNAME" ]]; then
	. ~/.bashrc-"$HOSTNAME"
fi

if [[ ! "$SUDO_USER" ]]; then
	have todo && todo
fi

true
