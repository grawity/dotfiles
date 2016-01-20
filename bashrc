# ~/.bashrc - bash interactive startup file
# vim: ft=sh

have() { command -v "$1" >&/dev/null; }

if [[ ! $PREFIX ]]; then
	. ~/lib/dotfiles/environ
	# this currently happens when:
	# - `sudo -s` preserves $HOME but cleans other envvars
	# - bash is built with #define SSH_SOURCE_BASHRC (e.g. Debian)
	#(. lib.bash && warn "had to load .environ from .bashrc")
fi

if [[ $TERM == @(screen|tmux|xterm) ]]; then
	OLD_TERM="$TERM"
	TERM="$TERM-256color"
fi

export GPG_TTY=$(tty)
export -n VTE_VERSION

### Interactive options

[[ $- == *i* ]] || return 0

set -o physical			# resolve symlinks when 'cd'ing
shopt -s autocd 2>/dev/null	# assume 'cd' when trying to exec a directory
shopt -s checkjobs 2> /dev/null	# print job status on exit
shopt -s checkwinsize		# update $ROWS/$COLUMNS after command
shopt -s extglob		# @(…) +(…) etc. globs
shopt -s globstar		# the ** glob
shopt -s no_empty_cmd_completion

set +o histexpand		# disable !history expansion
shopt -s cmdhist		# store multi-line commands as single history entry
shopt -s histappend		# append to $HISTFILE on exit
shopt -s histreedit		# allow re-editing failed history subst

HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
HISTIGNORE="../*/"

complete -A directory cd

. ~/lib/dotfiles/bash/prompt.sh
. ~/lib/dotfiles/bash/aliases.sh

have kc.sh && . kc.sh

if [[ -f ~/lib/dotfiles/bashrc-$HOSTNAME ]]; then
	. ~/lib/dotfiles/bashrc-$HOSTNAME
elif [[ -f ~/.bashrc-$HOSTNAME ]]; then
	. ~/.bashrc-$HOSTNAME
fi

if [[ ! $SILENT && ! $SUDO_USER ]]; then
	have todo && todo
fi

true
