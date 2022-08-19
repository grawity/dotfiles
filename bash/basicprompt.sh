# PS1 used on gw-core that turned out to be nice

if [[ $TERM == *-256color ]]; then
	if (( UID > 0 )); then
		PS1='\[\e[m\e[38;5;138m\]\u@\h \[\e[38;5;103m\]$PWD \[\e[38;5;244m\]\$\[\e[m\] '
	elif [[ $HOSTNAME == vm-vol* ]]; then
		PS1='\[\e[m\e[38;5;208m\]\u@\h \[\e[38;5;103m\]$PWD \[\e[38;5;244m\]\$\[\e[m\] '
	else
		PS1='\[\e[m\e[38;5;203m\]\u@\h \[\e[38;5;103m\]$PWD \[\e[38;5;244m\]\$\[\e[m\] '
	fi
fi

if [[ $TERM == @(xterm|screen|tmux)* ]]; then
	PS1+='\[\e]2;\u@\h \w\e\\\]'
fi
