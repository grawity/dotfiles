# Show status, update window title after command

case $TERM in
	[xkE]term*|rxvt*|cygwin|dtterm|termite)
		titlestring='\e]0;%s\a'
		wnamestring=
		;;
	screen*|tmux*)
		titlestring='\e]0;%s\a'
		wnamestring='\ek%s\e\\'
		;;
	*)
		titlestring=
		wnamestring=
		;;
esac

# Whether to export the "current working directory" as /net/$HOST/$PWD
nfspwd=0
# This could potentially default to 1, via:
#if [[ -d /net && -d /n ]]; then
#	nfspwd=1
#fi

settitle() { if [[ $titlestring ]]; then printf "$titlestring" "$*"; fi; }

setwname() { if [[ $wnamestring ]]; then printf "$wnamestring" "$*"; fi; }

_show_status() {
	local status=$?
	if (( status > 0 )); then
		if (( status > 128 && status <= 192 )); then
			local sig=$(kill -l $status 2>/dev/null)
			if [[ $sig ]]; then
				status+=" or SIG$sig"
			fi
		fi
		printf "\e[m\e[38;5;172m%s\e[m\n" "(returned $status)"
	fi
}
PROMPT_COMMAND+=(_show_status)

_update_title() {
	# Set window title to "user@host ~/path"
	if [[ ! ${title-} ]]; then
		local title= t_user= t_host= t_display= t_path=
		if [[ $USER != 'grawity' ]]; then
			t_user="$USER@"
		fi
		if [[ ${DISPLAY-} && ( $DISPLAY != :* || ${SSH_TTY-} ) ]]; then
			t_display=" ($DISPLAY)"
		fi
		t_path=${PWD/#"$HOME/"/'~/'}
		t_host=$HOSTNAME
		title="${t_user}${t_host} ${t_path}${t_display}"
	fi
	settitle "$title"
}
PROMPT_COMMAND+=(_update_title)

_update_wname() {
	# Set tmux window name to shortened tail of working directory
	if [[ ${TMUX-} ]]; then
		local t_pwd= t_dir= t_par=
		t_pwd=${PWD%/}/
		t_pwd=${t_pwd/#"$HOME/"/"~/"}
		if [[ "$t_pwd" == "~/" ]]; then
			t_par=${t_pwd%/*}
		else
			t_pwd=${t_pwd%/}
			t_par=${t_pwd%/*}
			t_par=${t_par##*/}
			t_dir=${t_pwd##*/}
		fi
		t_dir=${t_par::2}/${t_dir::5}
		setwname "$t_dir"
	fi
}
PROMPT_COMMAND+=(_update_wname)

_update_termcwd() {
	# Set current path
	if [[ ${VTE_VERSION-}${TILIX_ID-}${TMUX-} || $TERM == *-@(256color|direct) ]]; then
		local p_path=$PWD
		if (( nfspwd )); then
			p_path="/net/${HOSTNAME}${p_path}"
		fi
		local p_url="file://${HOSTNAME}$(urlencode -n -p -a "$p_path")"
		printf '\e]7;%s\e\\' "$p_url"
	fi
}
PROMPT_COMMAND+=(_update_termcwd)
