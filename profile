# ~/.profile: bash(1)

have() { command -v "$1" >/dev/null; }

mkpath() { local IFS=":"; export PATH="$*"; }

umask 022

export LOCAL="$HOME/.local"

#export PYTHONPATH="$LOCAL/lib/python"
export PERL5LIB="$LOCAL/lib/perl5:$HOME/cluenet/perl5"
export GEM_HOME="$LOCAL/ruby"

mkpath \
	"$HOME/bin"		\
	"$LOCAL/bin"		\
	"$HOME/code/bin"	\
	"$HOME/cluenet/bin"	\
	"$GEM_HOME/bin"		\
	"$PATH"			\
	"/usr/local/sbin" 	\
	"/usr/sbin"		\
	"/sbin"

export PAGER='less'
export EDITOR='vim'
unset VISUAL
have open-browser &&
	export BROWSER='open-browser'

unset LC_ALL
case $TERM in
	vt*|ansi)	export LANG='en_US';;
	*)		export LANG='en_US.utf-8';;
esac
export TZ='Europe/Vilnius'
export NAME='Mantas Mikulėnas'
export EMAIL='grawity@nullroute.eu.org'

[ -f ~/.mailrc ] ||
	export MAILRC=~/lib/dotfiles/mailrc

[ "$BASH_VERSION" ] &&
[ -f ~/.bashrc ] &&
	. ~/.bashrc

if [ -t 0 ]; then
	[ -f ~/.hushlogin ] &&
	[ -x ~/code/bin/motd ] &&
		~/code/bin/motd -q
	echo $(uptime)
fi

[ -f ~/.profile-$HOSTNAME ] &&
	. ~/.profile-$HOSTNAME

if [ "$LOCAL_PERL" = "n" ]; then
	export PERL_CPANM_OPT='--sudo'
else
	export PERL_MM_OPT="INSTALL_BASE='$LOCAL'"
	export PERL_MB_OPT="--install_base '$LOCAL'"
fi

true
