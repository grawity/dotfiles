# Prompt to re-acquire Kerberos tickets
# Loaded by .bashrc on NFS client machines

if [[ $USER == grawity && -t 0 && -t 1 && -t 2 ]]; then
	_krb_init() {(
		[[ $HOSTNAME == star ]] || return
		local path="$XDG_RUNTIME_DIR/krenew.lock"
		local fd
		if [[ -s $path ]]; then
			echo "Waiting for kinit on $(<"$path")..."
		fi
		exec {fd}>"$path"
		flock $fd
		tty >&$fd
		klist -s || kinit
		rm -f "$path"
	)}

	_krb_check() {(
		unset KRB5CCNAME
		local now=$(date +%s) ticket= krbtgt= expires=0 renews=0 flags=
		if klist -s; then
			# First look for an initial ticket (acquired via kinit)
			ticket=$(pklist | awk '$1 == "ticket" && $8 ~ /I/')
			if [[ ! $ticket ]]; then
				# Look for a forwarded ticket
				krbtgt=$(pklist -P | sed 's/.*@\(.*\)/krbtgt\/\1@\1/')
				ticket=$(pklist | awk -v t="$krbtgt" '$1 == "ticket" && $3 == t')
			fi
			expires=$(echo "$ticket" | awk '{print $6}')
			renews=$(echo "$ticket" | awk '{print $7}')
			flags=$(echo "$ticket" | awk '{print $8}')
		fi
		if (( expires < now )); then
			echo "[1;31mKerberos tickets expired[m"
			_krb_init
		elif [[ $flags != *R* ]]; then
			echo "[1;35mKerberos tickets are non-renewable[m"
		elif (( renews < now + 86400 )); then
			echo "[1;33mKerberos tickets are near renewal lifetime[m"
			_krb_init
		fi
	)}

	if have pklist; then
		_krb_check
	fi
fi
