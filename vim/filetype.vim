augroup filetypedetect
	au BufNewFile,BufRead accounts.db.txt setf accdb

	" XDG Desktop Entry
	au BufNewFile,BufRead *.ontology setf desktop

	au BufNewFile,BufRead ~/.local/share/applications/*	setf desktop

	" systemd
	au BufNewFile,BufRead *.automount,*.mount,*.service,*.socket,*.target setf desktop

	au BufNewFile,BufRead /etc/systemd/system/*		setf desktop
	au BufNewFile,BufRead /run/systemd/system/*		setf desktop
	au BufNewFile,BufRead /lib/systemd/system/*		setf desktop
	au BufNewFile,BufRead /usr/lib/systemd/system/*		setf desktop
	au BufNewFile,BufRead /etc/systemd/user/*		setf desktop
	au BufNewFile,BufRead /run/systemd/user/*		setf desktop
	au BufNewFile,BufRead /lib/systemd/user/*		setf desktop
	au BufNewFile,BufRead /usr/lib/systemd/user/*		setf desktop
	au BufNewFile,BufRead ~/.config/systemd/user/*		setf desktop

	" INI-style
	au BufNewFile,BufRead *.pkla,*.pkla~ setf dosini
	au BufNewFile,BufRead *.url setf dosini

	" /etc/group
	au BufNewFile,BufRead *.group,/etc/vigr.* setf group

	" JavaScript
	au BufNewFile,BufRead /etc/polkit-1/rules.d/* setf javascript
	\ | setl ts=4 sw=4 et

	" Markdown
	au BufNewFile,BufRead *.md setf markdown

	" RDF Notation 3 <http://www.vim.org/scripts/script.php?script_id=944>
	au BufNewFile,BufRead *.n3,*.trig,*.ttl,*.turtle setf n3

	" /etc/passwd
	au BufNewFile,BufRead *.passwd,/etc/vipw.* setf passwd

	" PHP
	au BufNewFile,BufRead *.phps setf php

	" Arch PKGBUILD
	au BufNewFile,BufRead PKGBUILD* setf PKGBUILD

	" Shell
	au BufNewFile,BufRead /etc/rc.conf setf sh
	
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
augroup END
