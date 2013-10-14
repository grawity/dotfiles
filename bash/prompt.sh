# bashrc -- shell prompt, window title, command exit status in prompt
# (note: depends on $havecolor being set, see main bashrc)

case $TERM in
	[xkE]term*|rxvt*|cygwin|dtterm|termite)
		titlestring='\e]0;%s\a';
		wnamestring=;;
	screen*)
		titlestring='\e]0;%s\a';
		wnamestring='\ek%s\e\\';;
	*)
		titlestring=;
		wnamestring=;;
esac

settitle() { [[ $titlestring ]] && printf "$titlestring" "$*"; }

setwname() { [[ $wnamestring ]] && printf "$wnamestring" "$*"; }

# This function automatically collapses long paths to fit on screen.
# It is invoked from within $PS1 below.

_awesome_prompt() {
	local maxwidth=${COLUMNS:-$(tput cols)}

	# hostname or system name
	# + 2 ("…/")
	# + 1 (trailing space to avoid hitting rmargin)

	(( maxwidth -= ${#item_name_pfx} + ${#item_name} \
			+ ${#item_name_sfx} + ${#reset_pwd} + 3 ))

	## Right side: Git branch, etc

	# Parts borrowed from git/contrib/completion/git-prompt.sh,
	# trimmed down to not cause any noticeable slowdown.

	local git= br= re=

	if ! have git; then
		git=
	elif [[ -n $GIT_DIR && -d $GIT_DIR ]]; then
		git=$GIT_DIR
	elif [[ -z $GIT_DIR && -d .git ]]; then
		git=.git
	else
		git=$(git rev-parse --git-dir 2>/dev/null)
	fi

	if [[ $git ]]; then
		if [[ -f $git/rebase-merge/interactive ]]; then
			br=$(<"$git/rebase-merge/head-name")
			re='REBASE-i'
		elif [[ -d $git/rebase-merge ]]; then
			br=$(<"$git/rebase-merge/head-name")
			re='REBASE-m'
		else
			br=$(git symbolic-ref HEAD 2>/dev/null ||
			     git describe --tags --exact-match HEAD 2>/dev/null ||
			     git rev-parse --short HEAD 2>/dev/null ||
			     echo 'unknown')

			br=${br#refs/heads/}

			if [[ -f $git/rebase-apply/rebasing ]]; then
				re='REBASE'
			elif [[ -f $git/rebase-apply/applying ]]; then
				re='AM'
			elif [[ -d $git/rebase-apply ]]; then
				re='AM/REBASE'
			elif [[ -f $git/MERGE_HEAD ]]; then
				re='MERGE'
			elif [[ -f $git/CHERRY_PICK_HEAD ]]; then
				re='CHERRY'
			elif [[ -f $git/BISECT_LOG ]]; then
				re='BISECT'
			fi
		fi

		br=${br}${re:+"|$re"}
	fi

	local item_vcs=$br

	if [[ $item_vcs ]]; then
		(( maxwidth -= ${#reset_vcs} + ${#item_vcs_pfx} \
				+ ${#item_vcs} + ${#item_vcs_sfx} ))
	else
		local reset_vcs= item_vcs_pfx= item_vcs_sfx=
	fi

	## Center: working directory

	local wdbase= wdhead= wdtail=
	local -i collapsed=0

	if [[ $git == .git ]]; then
		wdbase=$PWD
	elif [[ $git == /*/.git ]]; then
		wdbase=${git%/.git}
	elif [[ $git ]]; then
		wdbase=$(git rev-parse --show-toplevel)
	fi

	if [[ $PWD == "$HOME" ]]; then
		wdhead='' wdtail='~'
	elif [[ $wdbase && $PWD == "$wdbase" ]]; then
		wdhead=$wdbase wdtail=''
	elif [[ $wdbase ]]; then
		wdhead=$wdbase/ wdtail=${PWD#$wdbase/}
	else
		wdhead=${PWD%/*}/ wdtail=${PWD##*/}
	fi

	if [[ $fullpwd != 'y' ]]; then
		wdhead=${wdhead/#${HOME%/}\//\~/}
	fi

	# You are not expected to understand this.
	# After I woke up, I don't understand it anymore either.

	if (( ${#wdtail} > maxwidth )); then
		wdhead='/'
		collapsed=1
	elif (( ${#wdhead} + ${#wdtail} > 2 + maxwidth )); then
		if [[ ${wd:0:2} == '~/' ]]; then
			(( maxwidth -= 2 ))
		fi
		while (( ${#wdhead} + ${#wdtail} > maxwidth )); do
			if (( ! collapsed++ )); then
				wdhead=${wdhead#/}
			elif (( collapsed > 20 )); then
				break
			fi
			wdhead=${wdhead#*/}
		done
	fi

	if (( collapsed )); then
		wdhead='…/'$wdhead
		if [[ ${wd:0:2} == '~/' ]]; then
			wdhead='~/'$wdhead
		fi
	fi

	local item_pwd=$wdhead item_pwd_tail=$wdtail

	## Output

	local csi=$'m\e[' # 256-color sequences must be sent as a separate CSI,
	                  # so split the color settings into multiple CSIs

	local fmt_name_pfx=${fmt_name_pfx-$fmt_prompt}
	local fmt_name_sfx=${fmt_name_sfx-$fmt_name_pfx}
	local fmt_pwd_sfx=${fmt_pwd_sfx-$fmt_pwd_pfx}
	local fmt_vcs_sfx=${fmt_vcs_sfx-$fmt_vcs_pfx}

	printf '\001\e[%sm\002%s' \
		"${fmt_name_pfx//|/$csi}"		"$item_name_pfx"	\
		"${fmt_name//|/$csi}"			"$item_name"		\
		"${fmt_name_sfx//|/$csi}"		"$item_name_sfx"	\
		"${fmt_reset_pwd//|/$csi}"		"$reset_pwd"		\
		"${fmt_pwd_pfx//|/$csi}"		"$item_pwd_pfx"		\
		"${fmt_pwd//|/$csi}"			"$item_pwd"		\
		"${fmt_pwd_tail//|/$csi}"		"$item_pwd_tail"	\
		"${fmt_pwd_sfx//|/$csi}"		"$item_pwd_sfx"		\
		"${fmt_reset_vcs//|/$csi}"		"$reset_vcs"		\
		"${fmt_vcs_pfx//|/$csi}"		"$item_vcs_pfx"		\
		"${fmt_vcs//|/$csi}"			"$item_vcs"		\
		"${fmt_vcs_sfx//|/$csi}"		"$item_vcs_sfx"		\
		""					""			;
}

_is_remote() {
	[[ $SSH_TTY || $LOGIN || $REMOTEHOST ]]
}

# Set prompts (PS1, PS2, &c.)

if (( havecolor )); then
	PS1="\n"
	PS1="${PS1}\$(_awesome_prompt)\n"
	PS1="${PS1}\[\e[m\e[\${fmt_prompt//|/m\e[}m\]\${item_prompt}\[\e[m\] "
	PS2="\[\e[0;1;30m\]...\[\e[m\] "
	PS4="+\e[34m\${BASH_SOURCE:--}:\e[1m\$LINENO\e[m:\${FUNCNAME:+\e[33m\$FUNCNAME\e[m} "
else
	PS1='\n\u@\h \w\n\$ '
	PS2='... '
	PS4="+\${BASH_SOURCE:--}:\$LINENO:\$FUNCNAME "
fi

. ~/lib/dotfiles/bash/theme.sh

export -n PS1 PS2
export PS4

# Show status, update window title after command

_show_status() {
	local status=$?
	(( status > 0 )) &&
		printf "\e[0;33m%s\e[m\n" "(returned $status)"
}

_update_title() {
	if [[ ! $title ]]; then
		local title= t_user= t_display=
		[[ $USER != 'grawity' ]] &&
			t_user="$USER@"
		[[ $DISPLAY && ( $DISPLAY != :* || $SSH_TTY ) ]] &&
			t_display=" ($DISPLAY)"
		title="${t_user}${HOSTNAME} ${PWD/#$HOME/~}${t_display}"
	fi
	settitle "$title"
	if [[ $DISPLAY && $VTE_VERSION ]]; then
		printf '\e]7;file://%s%s\a' "$HOSTNAME" "$(urlencode -r -p "$PWD")"
	fi
}

PROMPT_COMMAND="_show_status; _update_title"
