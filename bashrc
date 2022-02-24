# ~/.bashrc - bash interactive startup file
# vim: ft=sh

have() { command -v "$1" >&/dev/null; }

# Reload environ for every terminal because:
# - `sudo -s` preserves $HOME but cleans other envvars
# - bash is built with #define SSH_SOURCE_BASHRC (e.g. Debian)
# - systemd rejects envvars which contain \e (ESC)
. ~/.dotfiles/environ

# Work around a race condition where the creation of LINES/COLUMNS may be
# delayed until bash is in the middle of ~/.environ's "allexport" section.
# It's a race condition most likely caused by bash using the "report window
# size" sequence, and the terminal sometimes being slow to reply.
export -n LINES COLUMNS

if [[ $TERM == @(screen|tmux|xterm) ]]; then
	OLD_TERM="$TERM"
	TERM="$TERM-256color"
fi

export GPG_TTY=$(tty)
export -n VTE_VERSION

if [[ $SSH_CLIENT ]]; then
	SELF=${SSH_CLIENT%% *}
fi

### Interactive options

[[ $- == *i* ]] || return 0

set -o physical			# resolve symlinks when 'cd'ing
shopt -s autocd 2>/dev/null	# assume 'cd' when trying to exec a directory
shopt -s checkjobs 2> /dev/null	# print job status on exit
shopt -s checkwinsize		# update $ROWS/$COLUMNS after command
shopt -s extglob		# @(…) +(…) etc. globs
shopt -s globstar		# the ** glob

shopt -u hostcomplete		# no special treatment for Tab at @
shopt -s no_empty_cmd_completion

set +o histexpand		# disable !history expansion
shopt -s cmdhist		# store multi-line commands as single history entry
shopt -s histappend		# append to $HISTFILE on exit
shopt -s histreedit		# allow re-editing failed history subst

HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
HISTIGNORE="../*/"
HISTTIMEFORMAT="(%F %T) "

complete -A directory cd

. ~/.dotfiles/bash/aliases.sh

if have kc.sh; then
	. kc.sh
fi

. ~/.dotfiles/bash/windowtitle.sh

# Don't load fancy prompt when SSH-ing from old terminals, e.g.
# 'xterm-color' (old OS X 10.6 where everything blinks)
if [[ $TERM == *-256color && $HOSTNAME != vm-* ]]; then
	. ~/.dotfiles/bash/prompt.sh

	if [[ -d /n && -e /etc/dist/hostids ]]; then
		. ~/.dotfiles/bash/krbprompt.sh
	fi
elif [[ $HOSTNAME == vm-* ]]; then
	. ~/.dotfiles/bash/basicprompt.sh
fi

if [[ -f ~/.dotfiles/bashrc-$HOSTNAME ]]; then
	. ~/.dotfiles/bashrc-$HOSTNAME
fi

if [[ -f ~/.bashrc-$HOSTNAME ]]; then
	. ~/.bashrc-$HOSTNAME
fi

if [[ ! $SILENT && ! $SUDO_USER ]]; then
	have todo && todo
fi

true
