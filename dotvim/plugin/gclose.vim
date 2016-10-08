command! Gclose :call s:Gclose()
function! s:Gclose() abort
	let previous_buffer = bufnr(expand("%"))
	for buffer in tabpagebuflist()
		if getbufvar(buffer, "fugitive_type") != ''
			execute bufwinnr(buffer).'wincmd w'
			wincmd q
			execute bufwinnr(previous_buffer).'wincmd w'
		endif
	endfor
endfunction

