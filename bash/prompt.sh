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

declare -A items=(
	[user]=$USER
	[host]=${HOSTNAME%%.*}
	[prompt]='$'
)

declare -A fmts=()

declare -A parts=(
	[left]=":host"
	[mid]=":pwd"
	[right]=":vcs"
	[prompt]=":prompt >"
)

declare -Ai _recursing=()

_dbg() { if [[ $DEBUG ]]; then echo "$*"; fi; }

_awesome_upd_vcs() {
	local git= br= re=

	if ! have git; then
		git=
	elif [[ $PWD == @(/afs|/n/uk)* ]]; then
		# add an exception for slowish network mounts
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
			     #git describe --tags --exact-match HEAD 2>/dev/null ||
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
	fi

	items[vcs]=${br}${re:+" ($re)"}
	items[vcs.br]=$br
	items[vcs.re]=$re
}

_awesome_upd_pwd() {
	local git=${items[.gitdir]} HOME=${HOME%/}

	local wdrepo= wdbase= wdparent= wdhead= wdbody= wdtail=
	local -i collapsed=0 tilde=0

	# find the working directory's root

	if [[ ${fmts[pwd.body]} ]]; then
		if [[ $GIT_WORK_TREE ]]; then
			_dbg "- wdbase <- GIT_WORK_TREE"
			wdbase=$(readlink -f "$GIT_WORK_TREE")
		elif [[ $git == .git ]]; then
			_dbg "- wdbase <- PWD"
			wdbase=$PWD
		elif [[ $git == /*/.git ]]; then
			_dbg "- wdbase <- \$git"
			wdbase=${git%/.git}
			if [[ $PWD != "$wdbase"/* ]]; then
				_dbg "- wdbase <- nil (outside PWD)"
				wdbase=
			fi
		elif [[ $git ]]; then
			_dbg "- wdbase <- wdrepo"
			wdrepo=$(git rev-parse --show-toplevel)
			wdbase=${wdrepo:-$(readlink -f "$git")}
		fi
	else
		wdbase=$PWD
	fi

	# find the parent of the working directory

	wdparent=${wdbase%/*}

	# split into 'head' (normal text) and 'tail' (highlighted text)
	# Now, if only I remembered why this logic is so complex...

	# TODO: clearly handle the following
	#   $PWD = $HOME
	#   inside working tree
	#   inside bare repository

	_dbg "* fullpwd='$fullpwd'"
	_dbg "   wdrepo='$wdrepo'"
	_dbg "   wdbase='$wdbase'"
	_dbg " wdparent='$wdparent'"

	if [[ $fullpwd != [yh] && $PWD == "$HOME" ]]; then
		# special case with fullpwd=n:
		# show full home directory with no highlight
		_dbg "head/tail case 1 (special case for ~)"
		wdhead=$PWD wdtail=''
	elif [[ $wdparent && $PWD != "$wdparent" ]]; then
		# inside a subdirectory of working tree
		_dbg "head/tail case 2 (under wdparent)"
		wdhead=$wdparent/ wdtail=${PWD#$wdparent/}
	elif [[ $git && $wdbase && ! $wdparent ]]; then
		# inside working tree immediately below root (e.g. /etc)
		_dbg "head/tail case 3 (empty wdpaernt)"
		wdhead=/ wdtail=${PWD#/}
	else
		_dbg "head/tail case default"
		wdhead=${PWD%/*}/ wdtail=${PWD##*/}
	fi

	if [[ ! $fullpwd && $PWD == "$HOME" ]]; then
		wdhead='~'
	elif [[ $fullpwd != 'y' ]]; then
		wdhead=${wdhead/#"$HOME/"/"~/"}
		if [[ ${wdhead:0:2} == '~/' ]]; then
			tilde=2
		fi
	fi

	_dbg "* wdhead='$wdhead' [${#wdhead}]"
	_dbg "  wdtail='$wdtail' [${#wdtail}]"
	_dbg "  head+tail=$(( ${#wdhead} + ${#wdtail} )), maxwidth=$maxwidth, tilde=$tilde"

	if (( tilde + ${#wdtail} > maxwidth )); then
		# even the tail alone cannot fit, hence don't show the head
		_dbg "tail case 1, wdtail > maxwidth - tilde"
		wdhead=''
		wdtail=${wdtail:${#wdtail}-(maxwidth-tilde-1)}
		collapsed=1
	elif (( ${#wdhead} + ${#wdtail} >= maxwidth + tilde )); then
		_dbg "tail case 2, wdhead + wdtail > maxwidth + tilde"
		wdhead=${wdhead:${#wdhead}-(maxwidth-tilde-${#wdtail}-1)}
		collapsed=1
	else
		_dbg "tail case 3, wdhead + wdtail all fit"
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

	items[pwd.head]=$wdhead
	items[pwd.body]=$wdbody
	items[pwd.tail]=$wdtail
	items[pwd]=$wdhead$wdbody$wdtail
}

_awesome_add_item() {
	local pos=$1 item=$2

	local full_item=$item
	local add_space=
	local add_prefix=
	local add_suffix=
	local errfmt=${fmts[error]:-"38;5;15|41"}

	local out=""
	local fmt=""

	# handle (condition) prefixes

	while [[ $item == \(*\)* ]]; do
		local cond= cval=
		cond=${item%%\)*}
		cond=${cond#\(}
		item=${item#*\)}
		cval=${cond#!}
		# I'm not proud of this
		if if case ${cval} in
			root)	(( UID == 0 )) ;;
			host=*)	[[ $HOSTNAME == ${cond#*=} ]] ;;
			user=*)	[[ $USER == ${cond#*=} ]] ;;
			remote)	[[ $SSH_TTY || $LOGIN || $REMOTEHOST ]] ;;
			:*)	[[ ${items[${cval#:}]} ]] ;;
		esac; then
			[[ $cond == !* ]]
		else
			[[ $cond != !* ]]
		fi; then
			return
		fi
	done

	# handle probably-useless [format] prefix

	if [[ $item == \[*\]* ]]; then
		fmt=${item%%\]*}
		fmt=${fmt#\[}
		item=${item#*\]}
	fi

	if [[ $item == \<* ]]; then
		add_space=" "
		item=${item#\<}
	fi

	baseitem=$item

	# handle various item types
	#   >		a space
	#   >text	literal text
	#   !part	sub-part with items
	#   :item	text from item

	if [[ $item == \> ]]; then
		out=" "
	elif [[ $item == \>* ]]; then
		out=${item#\>}
	elif [[ $item == !* ]]; then
		if [[ ${_recursing[$item]} == 1 ]]; then
			out="<looped '$item'>"
			fmt=$errfmt
		elif [[ ${parts[$item]+yes} ]]; then
			local subitem=
			_recursing[$item]=1
			if [[ ${items[$item.pfx]+yes} ]]; then
				_awesome_add_item $pos :$item.pfx
			fi
			for subitem in ${parts[$item]}; do
				_awesome_add_item $pos $subitem
			done
			if [[ ${items[$item.sfx]+yes} ]]; then
				_awesome_add_item $pos :$item.sfx
			fi
			_recursing[$item]=0
			return
		else
			out="<no part '$item'>"
			fmt=$errfmt
		fi
	elif [[ $item == :* ]]; then
		item=${item#:}
		if [[ ${items[$item]+yes} ]]; then
			local -i loop=0
			out=${items[$item]}
			fmt=@$item
			_dbg "-- item '$item' value '$out' fmt '$fmt' --"
			while true; do
				if [[ $fmt == @* ]]; then
					subitem=${fmt#@}
					fmt=${fmts[$subitem]}
					_dbg " stripped @, got item '$subitem' fmt '$fmt'"
				fi
				if [[ $fmt && $fmt != @* ]]; then
					_dbg " got final fmt '$fmt'"
					break
				fi
				if [[ ! $fmt && $subitem == *.sfx ]]; then
					subitem=${subitem/%.sfx/.pfx}
					fmt=${fmts[$subitem]}
					_dbg " stripped .sfx, got item '$subitem' fmt '$fmt'"
					if [[ $fmt == @*.pfx ]]; then
						fmt=${fmt/%.pfx/.sfx}
					fi
				fi
				if [[ ! $fmt && $subitem == *.* ]]; then
					subitem=${subitem%.*}
					fmt=${fmts[$subitem]}
					_dbg " stripped .*, got item '$subitem' fmt '$fmt'"
				fi
				if [[ ! $fmt ]]; then
					_dbg " got empty fmt, giving up"
					break
				fi
				if (( loop++ >= 10 )); then
					out="<bad fmt for '$item'>"
					fmt=$errfmt
					break
				fi
			done
			if [[ ${items[$item.pfx]+yes} ]]; then
				add_prefix=:$item.pfx
			fi
			if [[ ${items[$item.sfx]+yes} ]]; then
				add_suffix=:$item.sfx
			fi
		else
			out="<no item '$item'>"
			fmt=$errfmt
		fi
	elif [[ $item ]]; then
		out="<unknown '$item'>"
		fmt=$errfmt
	else
		out="<null '$full_item'>"
		fmt=$errfmt
	fi

	if [[ $add_space && ${strs[$pos]} && $out ]]; then
		lens[$pos]+=${#add_space}
		strs[$pos]+=$add_space
	fi

	if [[ $add_prefix ]]; then
		_awesome_add_item $pos $add_prefix
	fi

	lens[$pos]+=${#out}
	if [[ $fmt ]]; then
		out=$'\001\e['${fmt//'|'/$'m\e['}$'m\002'$out$'\001\e[m\002'
	fi
	strs[$pos]+=$out

	if [[ $add_suffix ]]; then
		_awesome_add_item $pos $add_suffix
	fi
}

_awesome_fill_items() {
	local pos

	for pos in "$@"; do
		set -o noglob
		for item in ${parts[$pos]}; do
			_awesome_add_item $pos $item
		done
		set +o noglob
	done
}

_awesome_prompt() {
	local maxwidth=${COLUMNS:-$(tput cols)}

	local -A strs=()
	local -Ai lens=()

	# handle left & right parts first,
	# to determine available space for middle

	_awesome_upd_vcs

	items[pwd]=$PWD

	_awesome_fill_items 'left' 'right'

	_dbg "* maxwidth before recalc = $maxwidth"
	_dbg "    left = '${strs[left]}' (${lens[left]})"
	_dbg "    right = '${strs[right]}' (${lens[right]})"
	(( maxwidth -= lens[left] + 1 + 1 + lens[right] + 1 ))
	_dbg "  maxwidth after recalc = $maxwidth"

	_awesome_upd_pwd

	_awesome_fill_items 'mid' 'prompt'

	printf "%s\n%s" \
		"${strs[left]} ${strs[mid]} ${strs[right]}" \
		"${strs[prompt]}"
}


# Set prompts (PS1, PS2, &c.)

if (( havecolor )); then
	PS1="\n"
	PS1="${PS1}\$(_awesome_prompt)"
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
	items[status]=$status
	if (( status > 0 )); then
		fmts[status]=@status:err
		if (( status > 128 && status <= 192 )); then
			local sig=$(kill -l $status 2>/dev/null)
			if [[ $sig ]]; then
				status+=" or SIG$sig"
			fi
		fi
		printf "\e[m\e[38;5;172m%s\e[m\n" "(returned $status)"
	else
		fmts[status]=@status:ok
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
		t_path=${PWD/#"$HOME/"/'~/'}
		title="${t_user}${HOSTNAME} ${t_path}${t_display}"
	fi
	settitle "$title"
	if [[ $DISPLAY && $VTE_VERSION ]]; then
		printf '\e]7;file://%s%s\a' "$HOSTNAME" "$(urlencode -r -p "$PWD")"
	fi
}

PROMPT_COMMAND="_show_status; _update_title"
