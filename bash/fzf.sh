# vim: ft=sh:nowrap
# Keyboard shortcuts to select a file using fzf

if have broot; then
	br() {
		local tmp=$(mktemp) r=0 out
		broot --outcmd "$tmp" \
			--git-ignored \
			--no-trim-root \
			"$@"; r=$?
		if (( !r )) && [[ -s "$tmp" ]]; then
			echo "> $(<"$tmp")"
			eval "$(<"$tmp")"
		fi
		rm -f "$tmp"
		return $r
	}
	bind -m emacs -x '"\er": br'
fi

if have fzf; then
	export FZF_DEFAULT_OPTS="--height=30% --info=inline"

	_fzfyank() {
		local cmd=$1
		if [[ $cmd != "fd "* ]]; then
			local cmd="$cmd | xargs -d '\n' ls -dh --color=always"
		fi
		local pre=${READLINE_LINE:0:READLINE_POINT}
		local suf=${READLINE_LINE:READLINE_POINT}
		local qry=${pre##*[ /=]}
		local str=$(FZF_DEFAULT_COMMAND=$cmd fzf -q "$qry" --reverse --ansi)
		if [[ $str ]]; then
			pre=${pre%"$qry"}
			str=${str@Q}" "
			READLINE_LINE=${pre}${str}${suf}
			READLINE_POINT=$((READLINE_POINT - ${#qry} + ${#str}))
		fi
	}
	if have fd; then
		# Alt+[df] - local dir/all selection
		bind -m emacs -x '"\ed": _fzfyank "fd -I --strip-cwd-prefix --color=always --exact-depth=1 --type=d"'
		bind -m emacs -x '"\ef": _fzfyank "fd -I --strip-cwd-prefix --color=always --exact-depth=1"'
		# Alt+Shift+[DF] - recursive dir/all selection
		bind -m emacs -x '"\eD": _fzfyank "fd -I --strip-cwd-prefix --color=always --type=d"'
		bind -m emacs -x '"\eF": _fzfyank "fd -I --strip-cwd-prefix --color=always"'
	else
		# Alt+[df] - local dir/all selection
		bind -m emacs -x '"\ed": _fzfyank "compgen -d | sort"'
		bind -m emacs -x '"\ef": _fzfyank "compgen -f | sort"'
		# Alt+Shift+[DF] - recursive dir/all selection
		bind -m emacs -x '"\eD": _fzfyank "find . -xdev -mindepth 1 -name .\?\* -prune -o -type d -printf %P\\\n"'
		bind -m emacs -x '"\eF": _fzfyank "find . -xdev -mindepth 1 -name .\?\* -prune -o -printf %P\\\n"'
	fi

	_fzfyank_git_branch() {
		local cmd='git branch -a --sort=committerdate | tac | sed "s/^..//; s!^remotes/!!"'
		local pre=${READLINE_LINE:0:READLINE_POINT}
		local suf=${READLINE_LINE:READLINE_POINT}
		local qry=${pre##*[ .:]}
		local str=$(FZF_DEFAULT_COMMAND=$cmd fzf -q "$qry" --reverse --ansi)
		if [[ $str ]]; then
			str=${str%% *}
			pre=${pre%"$qry"}
			str=${str@Q}" "
			READLINE_LINE=${pre}${str}${suf}
			READLINE_POINT=$((READLINE_POINT - ${#qry} + ${#str}))
		fi
	}
	bind -m emacs -x '"\eb": _fzfyank_git_branch'
fi
