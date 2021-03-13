# Prompt to re-acquire Kerberos tickets
# Loaded by .bashrc on NFS client machines

if [[ $USER == grawity && -t 0 && -t 1 && -t 2 ]]; then
	_krb_init() {(
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
		local now=$(date +%s) expires=0 renews=0
		if klist -s; then
			expires=$(pklist | awk '$1 == "ticket" && $8 ~ /I/ {print $6}')
			renews=$(pklist | awk '$1 == "ticket" && $8 ~ /I/ {print $7}')
		fi
		if (( renews < now )); then
			echo "[91mKerberos tickets expired[m"
			_krb_init
		elif (( renews < now + 86400 )); then
			echo "[93mKerberos tickets are near renewal lifetime[m"
			_krb_init
		fi
	)}

	if have pklist; then
		_krb_check
	fi
fi
