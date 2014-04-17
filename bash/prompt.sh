# bashrc -- shell prompt, window title, command exit status in prompt
# (note: depends on $havecolor being set, see main bashrc)
#
# Features:
#
#   - Git branch and basic status (merge, rebase, etc.)
#   - Highlight current directory's basename
#   - Highlight toplevel directory of a Git repo
#   - Collapse long paths to fit in one line
#     ("~/one/two/three" to "~/…o/three")
#
# Formatting:
#
#   <name>:
#     item_name_pfx: prefix
#     item_name: area for the hostname (FQDN shown by default)
#     item_name_sfx: suffix
#   reset_pwd: space between <name> and <pwd>
#   <pwd>:
#     item_pwd_pfx: prefix
#     _item_pwd: current working directory minus body+tail
#     _item_pwd_body: "body" (Git toplevel, etc) of cwd
#     _item_pwd_tail: basename (last element) of cwd
#     item_pwd_sfx: suffix
#   reset_vcs: space between <pwd> and <vcs>
#   <vcs>:
#     item_vcs_pfx: prefix
#     _item_vcs: Git repository status
#     item_cvs_sfx: suffix
#   <second line>:
#     item_prompt: the prompt character
#
#   - all ${_item_*} are recalculated every time and cannot be overridden
#   - prefix/suffix are empty by default
#   - each ${item_*} or ${_item_*} has a corresponding ${fmt_*} with ANSI fmt
#   - each ${reset_*} also has a corresponding ${fmt_reset_*}
#   - formats use '|' to emit separate CSI sequences (e.g. 256-color ones)
#   - for example, fmt_name='1|38;5;71'
#   - ${fmt_*_sfx} inherits from ${fmt_*_pfx}
#   - ${fmt_name_pfx} inherits from ${fmt_prompt}
#   - to suppress inheritance, set value to ${fmt_noop}
#
# Configuration:
#
#   fullpwd = "y" | "h" | unset
#     "y" = full path of working directory is always shown
#     "h" = full unhighlighted path is shown if ~ is cwd
#     unset = cwd is collapsed ("/home/grawity/foo" → "~/foo")

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
	# + 1 ("…/")
	# + 1 (trailing space to avoid hitting rmargin)

	(( maxwidth -= ${#item_name_pfx} + ${#item_name} \
			+ ${#item_name_sfx} + ${#reset_pwd} + 2 ))

	## Right side: Git branch, etc

	# Parts borrowed from git/contrib/completion/git-prompt.sh,
	# trimmed down to not cause any noticeable slowdown.

	local git= br= re=

	if ! have git; then
		git=
	elif [[ $GIT_DIR && -d $GIT_DIR ]]; then
		git=$GIT_DIR
	elif [[ ! $GIT_DIR && -d .git ]]; then
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

	local HOME=${HOME%/}

	local wdbase= wdhead= wdbody= wdtail=
	local -i collapsed=0 tilde=0

	# find the working directory's root

	if [[ $git == .git ]]; then
		wdbase=$PWD
	elif [[ $git == /*/.git ]]; then
		wdbase=${git%/.git}
		if [[ $PWD != "$wdbase"/* ]]; then
			#declare -p git PWD wdbase
			wdbase=
		fi
	elif [[ $git ]]; then
		wdbase=$(git rev-parse --show-toplevel)
		wdbase=${wdbase:-$(readlink -f "$git")}
	fi

	# find the 'base' – the parent of the working directory

	wdbase=${wdbase%/*}

	# split into 'head' (normal text) and 'tail' (highlighted text)
	# Now, if only I remembered why this logic is so complex...

	if [[ $fullpwd != 'y' && $PWD == "$HOME" ]]; then
		wdhead=$PWD wdtail=''
	elif [[ $wdbase && $PWD != "$wdbase" ]]; then
		wdhead=$wdbase/ wdtail=${PWD#$wdbase/}
	elif [[ $git && ! $wdbase ]]; then
		wdhead=/ wdtail=${PWD#/}
	else
		wdhead=${PWD%/*}/ wdtail=${PWD##*/}
	fi

	if [[ ! $fullpwd && $PWD == "$HOME" ]]; then
		wdhead='~'
	elif [[ $fullpwd != 'y' ]]; then
		wdhead=${wdhead/#$HOME\//\~/}
		if [[ ${wdhead:0:2} == '~/' ]]; then
			tilde=2
		fi
	fi

	# I honestly do not know why it's "maxwidth - tilde" in one place, but
	# "maxwidth + tilde" in another.

	if (( ${#wdtail} > maxwidth - tilde )); then
		wdhead=''
		if [[ $wdtail == */* ]]; then
			(( maxwidth -= tilde ))
			wdtail=${wdtail:${#wdtail}-maxwidth}
		fi
		collapsed=1
	elif (( ${#wdhead} + ${#wdtail} > maxwidth + tilde )); then
		(( maxwidth -= tilde ))
		wdhead=${wdhead:${#wdhead}-(maxwidth-${#wdtail})}
		collapsed=1
	fi

	if [[ $wdtail == */* ]]; then
		wdbody=${wdtail%/*}'/' wdtail=${wdtail##*/}
	fi

	if (( collapsed )); then
		wdhead='…'$wdhead
		if (( tilde )); then
			wdhead='~/'$wdhead
		fi
	fi

	local item_pwd=$wdhead item_pwd_body=$wdbody item_pwd_tail=$wdtail

	## Output

	local csi=$'m\e[' # 256-color sequences must be sent as a separate CSI,
	                  # so split the color settings into multiple CSIs

	if [[ $git ]]; then
		local fmt_pwd_body=${fmt_pwd_body-'4'}
	else
		local fmt_pwd_body=${fmt_pwd_body-$fmt_noop}
	fi

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
		"${fmt_pwd_body//|/$csi}"		"$item_pwd_body"	\
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
	if (( status > 0 )); then
		printf "\e[0;33m%s\e[m\n" "(returned $status)"
	fi
}

_update_title() {
	if [[ ! $title ]]; then
		local title= t_user= t_display= t_path=
		if [[ $USER != 'grawity' ]]; then
			t_user="$USER@"
		fi
		if [[ $DISPLAY && ( $DISPLAY != :* || $SSH_TTY ) ]]; then
			t_display=" ($DISPLAY)"
		fi
		t_path=${PWD/#$HOME\//'~'/}
		title="${t_user}${HOSTNAME} ${t_path}${t_display}"
	fi
	settitle "$title"
	if [[ $DISPLAY && $VTE_VERSION ]]; then
		printf '\e]7;file://%s%s\a' "$HOSTNAME" "$(urlencode -r -p "$PWD")"
	fi
}

PROMPT_COMMAND="_show_status; _update_title"
