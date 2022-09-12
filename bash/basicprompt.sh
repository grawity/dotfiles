# Basic prompt for VMs or old terminals

if [[ $TERM == *-@(256color|direct) ]]; then
	if (( UID > 0 )); then
		PS1='\[\e[m\e[38;5;138m\]\u@\h \[\e[38;5;103m\]$PWD \[\e[38;5;244m\]\$\[\e[m\] '
	elif [[ $HOSTNAME == vm-vol* ]]; then
		PS1='\[\e[m\e[38;5;208m\]\u@\h \[\e[38;5;103m\]$PWD \[\e[38;5;244m\]\$\[\e[m\] '
	else
		PS1='\[\e[m\e[38;5;203m\]\u@\h \[\e[38;5;103m\]$PWD \[\e[38;5;244m\]\$\[\e[m\] '
	fi
else
	if (( UID > 0 )); then
		PS1='\[\e[m\e[1m\](\u@\h \W)\$\[\e[m\] '
	else
		PS1='\[\e[m\e[1;31m\](\u@\h \W)\$\[\e[m\] '
	fi
fi

if [[ $TERM == @(xterm|screen|tmux)* ]]; then
	PS1+='\[\e]2;\u@\h \w\e\\\]'
fi
