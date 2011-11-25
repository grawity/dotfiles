augroup filetypedetect
	" XDG Desktop Entry
	au BufNewFile,BufRead *.ontology setf desktop
	" systemd
	au BufNewFile,BufRead *.mount,*.service,*.target setf desktop

	" Markdown
	au BufNewFile,BufRead *.md setf markdown

	" RDF Notation 3 <http://www.vim.org/scripts/script.php?script_id=944>
	au BufNewFile,BufRead *.n3,*.trig,*.ttl,*.turtle setf n3
augroup END
