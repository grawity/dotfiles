#!bash
have() { command -v "$@" >& /dev/null; }

# For Cygwin
[[ $USER ]] || export USER=$LOGNAME
[[ $USER ]] || export USER=$(id -un)

export GPG_TTY=$(tty)

[[ -t 0 ]] || return # stdin is tty
[[ $- = *i* ]] || return # mode is interactive

### Interactive-only options

# history
HISTFILE=~/tmp/bash.history
HISTCONTROL=ignoreboth
shopt -s cmdhist		# store multi-line commands as single history entry
shopt -s histappend		# append to $HISTFILE on exit
shopt -s histreedit		# allow re-editing failed history subst

shopt -os physical		# resolve symlinks on 'cd'
shopt -s checkjobs 2> /dev/null	# print job status on exit
shopt -s checkwinsize		# update $ROWS/$COLUMNS after command
shopt -s no_empty_cmd_completion

### Terminal

if [[ $TERM == "xterm" ]] && [[ $COLORTERM ]]; then
	TERM="$TERM-256color"
fi

havecolor=$(tput setaf 0)

# terminal window title
case $TERM in
	[xkE]term*|rxvt*|cygwin|screen*)
		titlestring='\e]0;%s\007';;
	#screen*)
	#	titlestring='\ek%s\e\\';;
esac

unset ${!c_*} ${!cx_*} ${!PS*}
if [[ $havecolor ]]; then
	c_no="\[\e[m\]"
	if [[ $(id -u) -eq 0 ]]; then
		c_uh="\[\e[;1;37;41m\]"
	elif [[ $(whoami) == "grawity" ]]; then
		c_uh="\[\e[;1;32m\]"
	else
		c_uh="\[\e[;1;33m\]"
	fi
	c_wd="\[\e[;36m\]"
	c_dk="\[\e[;1;30m\]"

	cx_file="\e[34m"
	cx_line="\e[1m"
	cx_func="\e[33m"
	cx_norm="\e[m"
fi
if (( $(id -u) == 0 )) || [[ $(whoami) == "grawity" ]]; then
	PS1="\h"
else
	PS1="\u@\h"
fi
PS1="${c_uh}${PS1}${c_no} ${c_wd}\w${c_no} \\\$ "
PS2="${c_dk}...${c_no} "
export PS4="+${cx_file}\${BASH_SOURCE:-stdin}:${cx_line}\$LINENO${cx_norm}:\${FUNCNAME:+${cx_func}\$FUNCNAME${cx_norm}:} "
unset ${!c_*} ${!cx_*}

title() { printf "$titlestring" "$*"; }

show_status() {
	local status=$?
	if (( status )); then
		printf "\e[;33m%s\e[m\n" "(returned $status)"
	fi
}
update_title() {
	local title="$USER@$HOSTNAME ${PWD/#$HOME/~}"
	[[ $SSH_TTY && $DISPLAY ]] &&
		title+=" (display=$DISPLAY)"
	title "$title"
}

PROMPT_COMMAND="show_status; update_title"
PROMPT_DIRTRIM=2

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

ls_opt="ls -Fh"
grep_opt="grep"
if [[ $havecolor ]]; then
	grep_opt="$grep_opt --color=auto"
	case "$(uname)" in
		Linux|CYGWIN_*)
			ls_opt="$ls_opt --color=auto"
			eval "$(dircolors --sh)"
			;;
		FreeBSD)
			ls_opt="$ls_opt -G"
			;;
	esac
fi
alias ls="$ls_opt"
alias grep="$grep_opt"
unset ls_opt grep_opt

editor() { eval "${EDITOR:-vim}" '"$@"'; }
browser() { eval "${BROWSER:-lynx}" '"$@"'; }
pager() { eval "${PAGER:-less}" '"$@"'; }

alias cur='cur '
alias df='df -Th'
alias egrep='grep -E'
entity()	{ printf '&%s;' "$@" | w3m -dump -T text/html; }
g() { egrep -rn "$@" .; }
gg() { g --color=always "$@" | pager; }
alias hex='xxd -p'
alias hup='pkill -HUP -x'
alias iprules='iptables -L --line-numbers -n'
#irc() { screen -dr irc || screen -S irc irssi "$@"; }
irc() { tmux attach -t irc || tmux new -s irc -n irssi "irssi $*"; }
alias ll='ls -l'
mail() { if [[ $1 ]]; then mutt -x "$@"; else mutt -Z; fi; }
alias md='mkdir'
alias p='pager'
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
alias w='PROCPS_USERLEN=16 w -shu'
alias xx='chmod a+x'
X() { ("$@" &> /dev/null &); }
alias '~'='preg'

alias sd='systemctl'
alias tsd='tree /etc/systemd/system'
cgls() { systemd-cgls "$@" | pager; }

alias lp='sudo netstat -lptu --numeric-hosts'
alias lpt='sudo netstat -lpt --numeric-hosts'
alias lpu='sudo netstat -lpu --numeric-hosts'

# list package contents
lspkg() {
	if [[ -z $1 ]]; then
		echo "$FUNCNAME: package not specified" >&2
		return 2
	fi
	if have dpkg;		then dpkg -L "$@"
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
get() {
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
		else echo "no package manager" >&2; return 1; fi
	fi
}

web() {
	if pgrep -xu "$USER" firefox > /dev/null; then
		firefox "$@"
	else
		browser "$@"
	fi
}
google() { web "http://www.google.com/search?q=$(urlencode "$*")"; }
rfc() { web "http://tools.ietf.org/html/rfc$1"; }
wiki() { web "http://en.wikipedia.org/w/index.php?search=$(urlencode "$*")"; }

todo() {
	if [[ $1 ]]; then
		echo "($(date +"%b %d")) $*" >> ~/todo
		nl ~/todo | tail -n 1
	else
		nl ~/todo
	fi
}
rmtodo() { sed -i "${1:-\$}d" ~/todo && todo; }

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
alias mboxdate='date "+%a %b %_d %H:%M:%S %Y"'
alias mimedate='date "+%a, %d %b %Y %H:%M:%S %z"' # RFC 2822
alias isodate='date "+%Y-%m-%dT%H:%M:%S%z"' # ISO 8601

x509() {
	[[ $1 ]] && [[ -t 0 ]] && set -- -in "$@"
	openssl x509 -noout -text -certopt no_pubkey,no_sigdump "$@"
}
x509fp() {
	[[ $1 ]] && [[ -t 0 ]] && set -- -in "$@"
	openssl x509 -noout -fingerprint -sha1 "$@" | sed 's/^.*=//; y/ABCDEF/abcdef/'
}

sslcert() {
	openssl s_client -no_ign_eof -connect "$@" </dev/null 2>/dev/null | openssl x509
}
sshfp() {
	local key=$(mktemp)
	ssh-keyscan -t rsa,dsa "$@" >> "$key"
	ssh-keygen -lf "$key"
	rm -f "$key"
}

abs() {
	local repo=$(pacman -Si "$1" | sed -nr 's/^Repository *: *(.+)$/\1/p')
	[[ $repo ]] || return 1
	local package="$repo/$1"
	local dir="$ABSROOT/$package"
	if [[ -d $dir ]]; then
		echo "==> Already downloaded to $dir"
		cd "$dir"
	else
		echo "==> Downloading $package to $dir"
		command abs "$package" && cd "$dir" && \
			find ~/lib/abs-patches/ -name "$1-*.patch" \
			-print -exec patch -i {} \;
	fi
}

fixlog() {
	local file=$1; shift
	perl -i -n -e "unless ($*) {print;}" "$file"
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

if [[ $PLAN9 ]]; then
	9man() { MANPATH=$PLAN9/man man "$@"; }
fi

### completion

HOSTFILE=~/.hosts
complete -A directory cd
# stop bash_completion from expanding ~/
__expand_tilde_by_ref() { true; }

### misc environ

export ABSROOT=~/build
export ACK_PAGER=$PAGER
# for gethostbyname; see hostname(7)
export HOSTALIASES=~/.hosts
export LESS="-eMqR -FX"
export LESSHISTFILE=~/tmp/less.history
export MYSQL_HISTFILE=~/tmp/mysql.history
if [[ -f ~/.pythonrc ]]; then
	export PYTHONSTARTUP=~/.pythonrc
	export PYTHONHISTFILE=~/tmp/python.history
fi
export SUDO_PROMPT=$(printf 'sudo password for %%u@\e[30;43m%%h\e[m: ')

# fixes PuTTY, doesn't hurt otherwise
export NCURSES_NO_UTF8_ACS=1

if [[ $DISPLAY == :* ]] && have gvim; then
	alias vim='gvim'
	if [[ $EDITOR == vim ]]; then
		EDITOR=gvim
	fi
fi

if [[ -f ~/lib/kc.bash ]]; then
	. ~/lib/kc.bash
fi

if [[ -f ~/todo ]]; then
	todo
fi
