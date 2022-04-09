#!bash
# bashrc/prompt -- shell prompt, window title, command exit status in prompt
#
#     "The problem with programmers is that if you give them the chance, they
#     will start programming."
#
# Note to self (2021-10-01):
#
#     If the prompt seems slow, that's because the C version of `urlencode`
#     hasn't been built so the Perl fallback is being invoked instead.

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

_awp_update_vcs() {
	local tmp= git= br= re=

	if ! have git; then
		git=
	elif [[ $PWD == @(/afs|/n/uk)* ]]; then
		git=
	elif [[ ${GIT_DIR-} && -d $GIT_DIR ]]; then
		git=$GIT_DIR
	else
		git=$(git rev-parse --git-dir 2>/dev/null)
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
				br=${br:0:10}
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

_awp_update_pwd_slashn() {
	if [[ ${fullpwd-} != y && ${fullnfspwd-} != y ]]; then
		if [[ ${items[pwd]} =~ ^/net/([^/]+)/home/([^/]+)(/.*)?$ ]]; then
			if [[ ${BASH_REMATCH[2]} == "$USER" ]]; then
				items[pwd]="/n/${BASH_REMATCH[1]}${BASH_REMATCH[3]}"
			fi
		fi
	fi
}

_awp_update_pwd_collapse() {
	local pwd=${items[pwd]}
	local home="${HOME%/}"
	local head="${pwd%/*}/"
	local tail="${pwd##*/}"
	local -i collapsed=0
	local -i tildewidth=0

	if [[ $pwd == "$home"/* ]]; then
		# With fullpwd=y, never compress paths
		if [[ ${fullpwd-} != y ]]; then
			head=${head/#"$home/"/"~/"}
			tildewidth=2
		fi
	elif [[ $pwd == "$home" ]]; then
		if [[ ${fullpwd-} == "" ]]; then
			# With fullpwd=unset, compress to ~ when exactly at home
			head="~"
			tail=""
		elif [[ ${fullpwd-} == n ]]; then
			# With fullpwd=n, don't compress but still prevent highlighting
			head="$pwd"
			tail=""
		else
			# Other values (e.g. fullpwd=h) don't compress, but do highlight
			true
		fi
	fi

	if (( tildewidth + ${#tail} > maxwidth )); then
		head=""
		tail="${tail:${#tail}-(maxwidth-tildewidth-1)}"
		collapsed=1
	elif (( ${#head} + ${#tail} > maxwidth )); then
		head="${head:${#head}-(maxwidth-tildewidth-${#tail}-1)}"
		collapsed=1
	fi

	if (( collapsed )); then
		head="…$head"
		if (( tildewidth )); then
			head="~/$head"
		fi
	fi

	items[pwd]=$head$tail
	items[pwd:head]=$head
	items[pwd:tail]=$tail
}

_awp_add_item() {
	local pos=$1 item=$2

	local full_item=$item
	local add_pspace=
	local add_sspace=
	local add_prefix=
	local add_suffix=
	local quietmissing=0
	local errfmt=${fmts[error]:-"38;5;15|41"}
	local out=
	local fmt=

	# Handle modifier prefixes
	while true; do
		case $item in
		\(*\)*)
			# '(condition)' prefix
			local cond= cval=
			cond=${item%%\)*}
			cond=${cond#\(}
			cval=${cond#!}
			item=${item#\(*\)}
			# I'm not not proud of this
			if if case $cval in
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
			;;
		\[*\]*)
			# Probably useless '[raw format]' prefix, e.g. [1;35]=Hello
			fmt=${item%%\]*}
			fmt=${fmt#\[}
			item=${item#\[*\]}
			;;
		\<*)
			# Add space before
			add_pspace=" "
			item=${item#\<}
			;;
		\>*)
			# Add space after
			add_sspace=" "
			item=${item#\>}
			;;
		\?*)
			# Ignore if missing
			quietmissing=1
			item=${item#\?}
			;;
		*)
			break
		esac
	done

	# Handle the actual item types
	case $item in
	_)
		# Literal space
		out=" "
		;;
	=*)
		# Literal text (can't have spaces, hence the _ item)
		out=${item#=}
		;;
	!*)
		# Another nested part (probably useless)
		if [[ ${_recursing[$item]} == 1 ]]; then
			out="<looped '$item'>"
			fmt=$errfmt
		elif [[ ${parts[$item]+yes} ]]; then
			local subitem=
			_recursing[$item]=1
			if [[ ${items[$item:pfx]+yes} ]]; then
				_awp_add_item $pos :$item:pfx
			fi
			for subitem in ${parts[$item]}; do
				_awp_add_item $pos $subitem
			done
			if [[ ${items[$item:sfx]+yes} ]]; then
				_awp_add_item $pos :$item:sfx
			fi
			_recursing[$item]=0
			return
		else
			out="<no part '$item'>"
			fmt=$errfmt
		fi
		;;
	:*)
		# A regular item from the items[] dict
		item=${item#:}
		if [[ ${items[$item]+yes} ]]; then
			local -i loop=0
			out=${items[$item]}
			fmt=@$item
			while true; do
				# Format '@foo' is a link to fmts[foo] -- restart
				if [[ $fmt == @* ]]; then
					subitem=${fmt#@}
					fmt=${fmts[$subitem]-}
				fi
				# Format exists and isn't a link -- stop here
				if [[ $fmt && $fmt != '@'* ]]; then
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
		elif (( !quietmissing )); then
			out="<no item '$item'>"
			fmt=$errfmt
		fi
		;;
	?*)
		# Item had an unknown prefix
		out="<unknown '$item'>"
		fmt=$errfmt
		;;
	"")
		# We had modifiers but not the actual item
		out="<null '$full_item'>"
		fmt=$errfmt
	esac

	# If this item is empty, surrounding spaces should merge
	# (XXX: This doesn't correctly consider :pfx and :sfx)
	if [[ ! $out ]]; then
		add_pspace=${add_pspace:-$add_sspace}
		add_sspace=
	fi

	# Suppress initial space if there's no previous output yet, or if it
	# already ends with trailing space (XXX: This should consider :pfx)
	if (( ! ${lens[$pos]:-0} )) || [[ ${strs[$pos]} == *' ' ]]; then
		add_pspace=
	fi

	# Add initial space
	if [[ $add_pspace ]]; then
		lens[$pos]+=${#add_pspace}
		strs[$pos]+=$add_pspace
	fi

	# Add item:pfx
	if [[ $add_prefix ]]; then
		_awp_add_item $pos $add_prefix
	fi

	# Add the item
	lens[$pos]+=${#out}
	if [[ $fmt ]]; then
		fmt=${fmt//'|'/$'m\e['}
		out=$'\001\e['$fmt$'m\002'$out$'\001\e[m\002'
	fi
	strs[$pos]+=$out

	# Add item:sfx
	if [[ $add_suffix ]]; then
		_awp_add_item $pos $add_suffix
	fi

	# Add final space
	if [[ $add_sspace ]]; then
		lens[$pos]+=${#add_sspace}
		strs[$pos]+=$add_sspace
	fi
}

_awp_fill_items() {
	local pos

	for pos in "$@"; do
		set -o noglob
		for item in ${parts[$pos]}; do
			_awp_add_item $pos $item
		done
		set +o noglob
	done
}

_awp_prompt() {
	local -i maxwidth=$COLUMNS
	local -A strs=()
	local -Ai lens=()

	# Fill dynamic items
	_awp_update_vcs

	# Handle left & right first, to determine available space for middle
	_awp_fill_items 'left' 'right'
	(( maxwidth -= lens[left] + !!lens[left] + !!lens[right] + lens[right] + 1 ))

	# Determine the width of :pwd decorations (:pwd:head:pfx) if any
	items[pwd]=
	items[pwd:head]=
	items[pwd:tail]=
	_awp_fill_items 'mid'
	(( maxwidth -= lens[mid] ))
	unset lens[mid]
	unset strs[mid]

	# Now fill the shrunken pwd:{head,tail}
	items[pwd]=$PWD
	_awp_update_pwd_slashn
	_awp_update_pwd_collapse
	_awp_fill_items 'mid'

	# Handle remaining parts
	_awp_fill_items 'prompt'

	# Output the prompt
	if [[ ${strs[left]}${strs[mid]}${strs[right]} ]]; then
		printf "%s\n" "${strs[left]} ${strs[mid]} ${strs[right]}"
	fi
	printf "%s" "${strs[prompt]}"
	# Note that if parts[prompt] was empty, the $() in PS1 will chop away
	# the trailing newline, so the end result is as if left+mid+right was
	# empty instead... except with possibly some weirdness involving pwd
	# recalculation.
}

:pp() {
	local var k
	for var; do
		local -n ref=$var
		if [[ ${ref@a} == *[aA]* ]]; then
			printf '%s=(\n' "$var"
			for k in "${!ref[@]}"; do
				printf '\t[%s]=%s\n' "$k" "${ref[$k]@Q}"
			done
			printf ')\n'
		else
			printf '%s=%s\n' "$var" "${ref@Q}"
		fi
	done
}

PS1="\n\$(_awp_prompt)"
PS2="\[\e[0;1;30m\]...\[\e[m\] "
PS4="+\e[34m\${BASH_SOURCE:--}:\e[1m\$LINENO\e[m:\${FUNCNAME:+\e[33m\$FUNCNAME\e[m} "

. ~/.dotfiles/bash/theme.sh

export -n PS1 PS2
export PS4
