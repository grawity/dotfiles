augroup filetypedetect
	" Markdown
	au BufNewFile,BufRead *.md setf markdown

	" RDF Notation 3 <http://www.vim.org/scripts/script.php?script_id=944>
	au BufNewFile,BufRead *.n3,*.ttl,*.turtle setf n3
augroup END
