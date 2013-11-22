command! Gclose :call s:Gclose()
function! s:Gclose() abort
	let previous_buffer = bufnr(expand("%"))
	for buf in tabpagebuflist()
		if getbufvar(buf, "fugitive_type") != ''
			execute bufwinnr(buf).'wincmd w'
			wincmd q
			execute bufwinnr(previous_buffer).'wincmd w'
		endif
	endfor
endfunction

