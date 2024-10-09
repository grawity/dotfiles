# Indicate whether the lid is open when I'm using my laptop via RDP

if [[ ${items@a} != *A* ]]; then
	return
fi

if (( UID == 0 )); then
	# dbus-broker rudely disconnects
	_gnome_remote_session_active() { false; }
	_lid_is_open() { false; }
else
	_gnome_remote_session_active() {
		busctl --user --list tree org.gnome.Shell |
			grep -q '^/org/gnome/Mutter/RemoteDesktop/Session/'
	}
	_lid_is_open() {
		local v=$(busctl --system get-property \
			org.freedesktop.UPower \
			/org/freedesktop/UPower \
			org.freedesktop.UPower \
			LidIsClosed)
		[[ $v != "b true" ]]
	}
fi

_frost_lid_check() {
	items[rdp?]=""
	if _gnome_remote_session_active; then
		items[rdp?]="y"
		items[lid.open?]=""
		if _lid_is_open; then
			items[lid.open?]="y"
		fi
	fi
}

PROMPT_COMMAND+="${PROMPT_COMMAND+; }_frost_lid_check"

items[rdp?]=
items[rdp.active]='[RDP]'
items[lid.open?]=
items[lid.open]='[lid OPEN]'
items[lid.closed]='[lid closed]'
fmts[lid.open]='1;41'
fmts[lid.closed]='32'
parts[right]+=' (:rdp?)<:rdp.active'
parts[right]+=' (:rdp?)(:lid.open?)<:lid.open'
parts[right]+=' (:rdp?)(!:lid.open?)<:lid.closed'
