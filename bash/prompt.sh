#!bash
# bashrc -- shell prompt, window title, command exit status in prompt
#
#     "The problem with programmers is that if you give them the chance, they
#     will start programming."
#
# Features:
#
#   - Git branch and basic status (merge, rebase, etc.)
#   - Highlight current directory's basename
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
	screen*|tmux*)
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
	[prompt]=":prompt _"
)

declare -Ai _recursing=()

_dbg() { if [[ ${PS1_DEBUG-} ]]; then printf '\e[47m%s\e[m %s\n' "[${FUNCNAME[1]}]" "$*"; fi; }

_awesome_upd_vcs() {
	local tmp= git= br= re=

	if ! have git; then
		git=
	elif [[ $PWD == @(/afs|/n/uk)* ]]; then
		# Don't do anything for slowish network mounts
		git=
	elif [[ ${GIT_DIR-} && -d $GIT_DIR ]]; then
		git=$GIT_DIR
	elif [[ $PWD == */vim/bundle/* ]]; then
		# Directly spawn rev-parse for submodules.
		# Kind of a hack :(
		git=$(git rev-parse --git-dir 2>/dev/null)
	else
		# Try to directly check for .git, ../.git, and so on.
		for tmp in {,../{,../{,../{,../{,../}}}}}.git; do
			if [[ -d $tmp ]]; then
				git=$tmp
				break
			fi
		done
		# Give up and fall back to spawning rev-parse
		if [[ ! $git ]]; then
			git=$(git rev-parse --git-dir 2>/dev/null)
		fi
	fi

	if [[ $git && -r $git/HEAD ]]; then
		if [[ -f $git/rebase-merge/interactive ]]; then
			br=$(<"$git/rebase-merge/head-name")
			re='REBASE-i'
		elif [[ -d $git/rebase-merge ]]; then
			br=$(<"$git/rebase-merge/head-name")
			re='REBASE-m'
		else
			br=$(<"$git/HEAD")
			if [[ $br == ref:* ]]; then
				br=${br#ref: }
				br=${br#refs/heads/}
			else
				br=$(git symbolic-ref HEAD 2>/dev/null ||
				     git rev-parse --short HEAD 2>/dev/null ||
				     echo 'unknown')
				br=${br#refs/heads/}
			fi

			# Shorten git-annex adjusted branches
			br=${br/#'adjusted/master('/'('}

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

	items[.gitdir]=$git

	items[vcs]=${br}${re:+" ($re)"}
	items[vcs.br]=$br
	items[vcs.re]=$re
}

_awesome_upd_pwd() {
	local HOME=${HOME%/}

	local wdbase= wdparent= wdhead= wdbody= wdtail=
	local -i collapsed=0 tilde=0

	wdbase=$PWD

	# find the parent of the working directory

	wdparent=${wdbase%/*}

	# split into 'head' (normal text) and 'tail' (highlighted text)
	# Now, if only I remembered why this logic is so complex...

	if [[ ${fullpwd-} != [yh] && $PWD == "$HOME" ]]; then
		# special case with fullpwd=n:
		# show full home directory with no highlight
		wdhead=$PWD wdtail=''
	else
		wdhead=${PWD%/*}/ wdtail=${PWD##*/}
	fi

	if [[ ! ${fullpwd-} && $PWD == "$HOME" ]]; then
		wdhead='~'
	elif [[ ${fullpwd-} != 'y' ]]; then
		wdhead=${wdhead/#"$HOME/"/"~/"}
		if [[ ${wdhead:0:2} == '~/' ]]; then
			tilde=2
		fi
	fi

	if (( tilde + ${#wdtail} > maxwidth )); then
		wdhead=''
		wdtail=${wdtail:${#wdtail}-(maxwidth-tilde-1)}
		collapsed=1
	elif (( ${#wdhead} + ${#wdtail} > maxwidth )); then
		wdhead=${wdhead:${#wdhead}-(maxwidth-tilde-${#wdtail}-1)}
		collapsed=1
	else
		collapsed=0
	fi

	if (( collapsed )); then
		wdhead='…'$wdhead
		if (( tilde )); then
			wdhead='~/'$wdhead
		fi
	fi

	items[pwd:head]=$wdhead
	items[pwd:body]=""
	items[pwd:tail]=$wdtail
	items[pwd]=$wdhead$wdtail
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
			remote)	[[ ${SSH_TTY-} || ${LOGIN-} || ${REMOTEHOST-} ]] ;;
			:*)	[[ ${items[${cval#:}]-} ]] ;;
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
	#   _		a space
	#   >text	literal text
	#   !part	nested part with items
	#   :item	text from item

	if [[ $item == _ ]]; then
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
			if [[ ${items[$item:pfx]+yes} ]]; then
				_awesome_add_item $pos :$item:pfx
			fi
			for subitem in ${parts[$item]}; do
				_awesome_add_item $pos $subitem
			done
			if [[ ${items[$item:sfx]+yes} ]]; then
				_awesome_add_item $pos :$item:sfx
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
				# Format '@foo' is a link to fmts[foo] -- restart
				if [[ $fmt == @* ]]; then
					subitem=${fmt#@}
					fmt=${fmts[$subitem]-}
				fi
				# Format exists and isn't a link -- stop here
				if [[ $fmt && $fmt != @* ]]; then
					break
				fi
				# Missing format for :sfx -- try using the :pfx format
				if [[ ! $fmt && $subitem == *:sfx ]]; then
					subitem=${subitem/%:sfx/:pfx}
					fmt=${fmts[$subitem]-}
					# If it's a link, then pretend it links to :sfx
					if [[ $fmt == @*:pfx ]]; then
						fmt=${fmt/%:pfx/:sfx}
					fi
				fi
				# Missing format for other subitem -- try using main item's format
				# e.g. pwd:head is formatted like pwd
				if [[ ! $fmt && $subitem == *:* ]]; then
					subitem=${subitem%:*}
					fmt=${fmts[$subitem]-}
				fi
				# Missing format for variant -- try using the main item's format
				# e.g. user.root is formatted like user
				if [[ ! $fmt && $subitem == *.* ]]; then
					subitem=${subitem%.*}
					fmt=${fmts[$subitem]-}
				fi
				# Give up, nothing to retry with
				if [[ ! $fmt ]]; then
					break
				elif (( loop++ >= 10 )); then
					out="<fmt cycle for '$item'>"
					fmt=$errfmt
					break
				fi
			done
			if [[ ${items[$item:pfx]+yes} ]]; then
				add_prefix=:$item:pfx
			fi
			if [[ ${items[$item:sfx]+yes} ]]; then
				add_suffix=:$item:sfx
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

	if [[ $add_space ]] && (( ${lens[$pos]} )); then
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
	local maxwidth=$COLUMNS

	local -A strs=()
	local -Ai lens=()

	# handle left & right parts first,
	# to determine available space for middle

	_awesome_upd_vcs

	items[pwd]=$PWD

	_awesome_fill_items 'left' 'right'

	(( maxwidth -= lens[left] + !!lens[left] + !!lens[right] + lens[right] + 1 ))

	_awesome_upd_pwd

	_awesome_fill_items 'mid' 'prompt'

	if [[ ${strs[left]}${strs[mid]}${strs[right]} ]]; then
		printf "%s\n%s" "${strs[left]} ${strs[mid]} ${strs[right]}" "${strs[prompt]}"
	else
		printf "%s" "${strs[prompt]}"
	fi
}


# Set prompts (PS1, PS2, &c.)

PS1="\n"
PS1="${PS1}\$(_awesome_prompt)"
PS2="\[\e[0;1;30m\]...\[\e[m\] "
PS4="+\e[34m\${BASH_SOURCE:--}:\e[1m\$LINENO\e[m:\${FUNCNAME:+\e[33m\$FUNCNAME\e[m} "

. ~/.dotfiles/bash/theme.sh

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
	if [[ ${DISPLAY-} && ${VTE_VERSION-}${TILIX_ID-} ]]; then
		items[pwd.url]="file://${HOSTNAME}$(urlencode -n -p -a "$PWD")"
		printf '\e]7;%s\e\\' "${items[pwd.url]}"
	fi
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

PROMPT_COMMAND="_show_status; _update_title"
