augroup filetypedetect
	au BufNewFile,BufRead accounts.db.txt setf accdb

	au BufNewFile,BufRead /etc/apparmor.d/* setf apparmor

	au BufNewFile,BufRead /etc/motd setf motd

	au BufNewFile,BufRead *.axfr,*.dns,*.zone setf bindzone

	" Basic config
	au BufNewFile,BufRead */pkcs11/modules/*		setf conf

	" C-style config{}
	au BufNewFile,BufRead ~/.irssi/config			setf c-conf
	au BufNewFile,BufRead /etc/rspamd/*			setf c-conf
	au BufNewFile,BufRead *.hcl				setf c-conf

	" XDG Desktop Entry
	au BufNewFile,BufRead *.ontology setf desktop

	au BufNewFile,BufRead ~/.local/share/applications/*	setf desktop
	au BufNewFile,BufRead ~/.config/*mimeapps.list		setf desktop

	au BufNewFile,BufRead /etc/systemd/network/*		setf systemd
	au BufNewFile,BufRead /etc/systemd/system/*		setf systemd
	au BufNewFile,BufRead /etc/systemd/user/*		setf systemd
	au BufNewFile,BufRead /lib/systemd/system/*		setf systemd
	au BufNewFile,BufRead /lib/systemd/user/*		setf systemd
	au BufNewFile,BufRead /run/systemd/system/*		setf systemd
	au BufNewFile,BufRead /run/systemd/user/*		setf systemd
	au BufNewFile,BufRead /usr/lib/systemd/system/*		setf systemd
	au BufNewFile,BufRead /usr/lib/systemd/user/*		setf systemd
	au BufNewFile,BufRead ~/.config/systemd/user/*		setf systemd
	au BufNewFile,BufRead *.nspawn				setf systemd

	" INI-style
	au BufNewFile,BufRead *.inf setf dosini
	au BufNewFile,BufRead *.pkla,*.pkla~ setf dosini
	au BufNewFile,BufRead *.url setf dosini
	au BufNewFile,BufRead php.ini* setf dosini
	au BufNewFile,BufRead /etc/dconf/db/* setf dosini
	au BufNewFile,BufRead /etc/pacman.d/hooks/*.hook setf dosini
	au BufNewFile,BufRead /etc/php*/php-fpm.d/*.conf setf dosini
	au BufNewFile,BufRead /usr/share/libalpm/hooks/*.hook setf dosini

	au BufNewFile,BufRead *.gv setf dot

	" Git
	au BufNewFile,BufRead MERGE_MSG setf gitcommit

	" /etc/group
	au BufNewFile,BufRead *.group,/etc/vigr.*,/etc/.vigr.* setf group

	" ini
	au BufNewFile,BufRead *.pls setf dosini

	" JavaScript
	au BufNewFile,BufRead /etc/polkit-1/rules.d/* setf javascript
	\ | setl ts=4 sw=4 et
	au BufNewFile,BufRead /etc/cjdroute.conf setf javascript
	\ | setl ts=4 sw=4 et

	au BufNewFile,BufRead /tmp/ldapvi*,/tmp/ldbedit.* setf ldif

	" Lua
	au BufNewFile,BufRead *.nse setf lua

	" Mail
	au BufNewFile,BufRead *.msg setf mail

	" Markdown
	au BufNewFile,BufRead *.md setf markdown

	" mutt
	au BufNewFile,BufRead .muttaliases setf muttrc

	" RDF Notation 3 <http://www.vim.org/scripts/script.php?script_id=944>
	au BufNewFile,BufRead *.n3,*.trig,*.ttl,*.turtle setf n3

	" PAM
	au BufNewFile,BufRead */pam.d/* setf pamconf

	" /etc/passwd
	au BufNewFile,BufRead *.passwd,/etc/vipw.*,/etc/.vipw.* setf passwd

	" PHP
	au BufNewFile,BufRead *.phps setf php

	" Shell
	au BufNewFile,BufRead ~/.environ,~/.environ-* setf sh
	au BufNewFile,BufRead /etc/rc.conf setf sh
	au BufNewFile,BufRead /tmp/bash-fc-* setl ft=sh
	au BufNewFile,BufRead policy-rc.d setl ft=sh

	" Syncthing ignore
	au BufNewFile,BufRead .stignore setf stignore

	" tmux
	au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux

	" udev
	au BufNewFile,BufRead /usr/lib/udev/rules.d/* setf udevrules

	" Vala <https://live.gnome.org/Vala/Vim>
	au BufNewFile,BufRead *.vala,*.vapi setf vala

	" vim
	au BufNewFile,BufRead .vimdir setf vim
	au BufNewFile,BufRead *.vala,*.vapi setl efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %

	" xinetd
	au BufNewFile,BufRead *.xinetd setf xinetd
	au BufNewFile,BufRead /etc/xinetd.d/* setf xinetd

	" XML
	au BufNewFile,BufRead *.cdf setf xml
	au BufNewFile,BufRead *.doap setf xml

	" YAML
	au BufNewFile,BufRead *.sls setf yaml | setl ts=2 sw=2 et
augroup END
