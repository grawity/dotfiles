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

	" Markdown
	au BufNewFile,BufRead *.md setf markdown

	" RDF Notation 3 <http://www.vim.org/scripts/script.php?script_id=944>
	au BufNewFile,BufRead *.n3,*.trig,*.ttl,*.turtle setf n3

	" PHP
	au BufNewFile,BufRead *.phps setf php

	" xinetd
	au BufNewFile,BufRead *.xinetd setf xinetd
	au BufNewFile,BufRead /etc/xinetd.d/* setf xinetd
augroup END
