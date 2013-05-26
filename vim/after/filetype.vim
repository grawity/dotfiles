augroup filetypedetect
	" config
	au BufNewFile,BufRead *.conf setf c-conf

	" systemd
	au BufNewFile,BufRead *.automount,*.mount,*.service,*.socket,*.target
	\ setf desktop
augroup END
