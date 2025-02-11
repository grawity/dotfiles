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

# Fix up TERM for Neovim, which needs 'putty(-256color)' for Home/End keys.
if [[ $TERM == xterm ]] && isterm putty; then
	export TERM="${TERM/#xterm/putty}"
fi
# Assume that xterm-emulating terminals support 256 colors.
if [[ $TERM == @(putty|screen|tmux|xterm) ]]; then
	OLD_TERM="$TERM"
	export TERM="$TERM-256color"
fi
# ...and assume that they support RGB colors as well. See also 'set tgc' in
# vimrc. (With an exception for JuiceSSH and Mosh, which don't.)
if [[ ! $COLORTERM ]]; then
	if [[ $TERM == xterm-256color ]] && isterm juicessh; then
		export JUICESSH="yes"
	elif [[ $TERM == *-@(256color|direct) || $TERM == xterm-ghostty ]]; then
		export COLORTERM="truecolor"
	fi
fi
if [[ $TERM == tmux-256color ]]; then
	if gettermbg -l; then
		export BRIGHT=1
	fi
fi

# Temporary hack as WT 1.22 supports sixel but lsix doesn't recognize it.
export LSIX_FORCE_SIXEL_SUPPORT="1"

export GPG_TTY=$(tty)
export -n VTE_VERSION

if [[ $SSH_CLIENT ]]; then
	SELF=${SSH_CLIENT%% *}
fi

### Interactive options

[[ $- == *i* ]] || return 0

#set +h				# Disable command hashing
shopt -s checkhash		# Re-check $PATH on hash failure

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

if [[ -d ~/.local/state ]]; then
	HISTFILE=~/.local/state/bash_history
fi

HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
HISTIGNORE="../*/"
HISTTIMEFORMAT="(%F %T) "

# Prevent commands from accumulating across reloads
# - Note: OFB (Ubu18.04) still has bash 4.4 where PROMPT_COMMAND is a
#   scalar, not an array.
unset PROMPT_COMMAND

# Resolve symlinks for initial working directory
cd -P .

complete -A directory cd

bind -f ~/.dotfiles/inputrc

. ~/.dotfiles/bash/aliases.sh

if have kc.sh; then
	. kc.sh
fi

. ~/.dotfiles/bash/windowtitle.sh

# Don't load fancy prompt when SSH-ing from old terminals, e.g.
# 'xterm-color' (old OS X 10.6 where everything blinks)
if [[ ($COLORTERM == truecolor || $TERM == *-256color) && $HOSTNAME != vm-* ]]; then
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

if [[ ! $SILENT && ! $SUDO_USER && $TERM_PROGRAM != vscode ]]; then
	have todo && todo || :
fi

true
