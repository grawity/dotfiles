# PS1 used on gw-core that turned out to be nice

if [[ $TERM == @(xterm|screen|tmux) ]]; then
	export TERM="$TERM-256color"
fi

if [[ $TERM == *-256color ]]; then
	# vim mustang theme
	#c_user='\e[38;5;208m\e[48;5;235m'
	c_user='\e[38;5;208m'
	c_host="$c_user"
	c_path='\e[38;5;103m'
	c_sigl='\e[38;5;244m'
	c_none='\e[m'
else
	c_user='\e[1;33m'
	c_host="$c_user"
	c_path='\e[;33m'
	c_sigl='\e[;37m'
	c_none='\e[m'
fi

PS1="\\[$c_user\\]\\u\\[$c_user\\]@\\[$c_host\\]\\h\\[$c_sigl\\] \\[$c_path\\]\$PWD\\[$c_sigl\\] \\$\\[$c_none\\] "

if [[ $TERM == @(xterm|screen|tmux)* ]]; then
	PS1="\\[\\e]2;\\u@\\h \\w\\e\\\\\\]$PS1"
fi
