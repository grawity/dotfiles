#!/usr/bin/env bash

have() { command -v "$1" >&/dev/null; }

### Environment

[[ $PREFIX ]] || . ~/lib/dotfiles/environ

# this cannot be in environ.sh because gdm sources profile early;
# Xsession and gnome-session override $LANG later
case $LANG in *.utf8)
	# make `tree` work correctly
	export LANG="${LANG%.utf8}.utf-8"
esac

export GPG_TTY=$(tty)

export SUDO_PROMPT=$(printf 'sudo: Password for %%p@\e[30;43m%%h\e[m: ')

# this is needed for non-interactive mode as well; for example,
# in my git-url-handler script
case $TERM in
	xterm)
		TERM='xterm-256color';
		havecolor=256;;
	*-256color|xterm-termite)
		havecolor=256;;
	"")
		havecolor=0;;
	*)
		havecolor=8;;
esac

### Interactive options

[[ $- != *i* ]] && return

[[ $DEBUG ]] && echo ".. bashrc [interactive=$-]"

shopt -os physical		# resolve symlinks when 'cd'ing
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

complete -A directory cd

### Prompt and window title

. ~/lib/dotfiles/bashrc.prompt

### Aliases

. ~/lib/dotfiles/bashrc.aliases

if have pklist; then
	. ~/code/kerberos/kc.bash
fi

### More environment

export GREP_OPTIONS='--color=auto'

if [[ -f ~/lib/dotfiles/bashrc-$HOSTNAME ]]; then
	. ~/lib/dotfiles/bashrc-$HOSTNAME
elif [[ -f ~/.bashrc-$HOSTNAME ]]; then
	. ~/.bashrc-$HOSTNAME
fi

### Todo list

if [[ ! $SILENT && ! $SUDO_USER ]]; then
	have todo && todo
fi

true
