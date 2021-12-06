# vim: ft=sh:nowrap

# http://stackoverflow.com/a/1088763/49849

_xdiscard() {
	echo -n "${READLINE_LINE:0:READLINE_POINT}" | gclip
	READLINE_LINE=${READLINE_LINE:READLINE_POINT}
	READLINE_POINT=0
}

_xkill() {
	echo -n "${READLINE_LINE:READLINE_POINT}" | gclip
	READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}
}

_xyank() {
	local func=${1:-pclip}
	local str=$(eval $func)
	local len=${#str}
	READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}${str}${READLINE_LINE:READLINE_POINT}
	READLINE_POINT=$((READLINE_POINT + len))
}

_xyankq() {
	local func=${1:-pclip}
	local str=$(eval $func); str="${str@Q} "
	local len=${#str}
	READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}${str}${READLINE_LINE:READLINE_POINT}
	READLINE_POINT=$((READLINE_POINT + len))
}

if have gclip && have pclip; then
	bind -m emacs -x '"\eu": _xdiscard'
	bind -m emacs -x '"\ek": _xkill'
	bind -m emacs -x '"\ey": _xyank'
	bind -m emacs -x '"\C-f": _xyankq psel'
	bind -m emacs -x '"\C-g": _xyankq pclip'
fi
