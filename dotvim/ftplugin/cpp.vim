setlocal commentstring=//%s

" Changes from '.cpp' to '.h' files and vice versa.
nmap <silent> <buffer> <leader>A :call AlternateHeaderWithImplementation()<CR>
if !exists('*AlternateHeaderWithImplementation')
	function! AlternateHeaderWithImplementation()
		let thisfile=bufname("%")
		" TODO: strridx  and strlen return 'byte index'. Is this OK with all files?
		let dot=strridx(thisfile, ".")
		let length=strlen(thisfile)
		if dot == -1
			echom "Can't find header: no dot terminated name"
		else
			let base=strpart(thisfile, 0, dot)
			let ext=strpart(thisfile, dot+1)
			if ext ==? "h"
				execute "edit " . base . ".cpp"
			else
				execute "edit " . base . ".h"
			endif
		endif
	endfunction
endif
