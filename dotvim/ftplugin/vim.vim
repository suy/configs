let b:original_commentstring = &commentstring

function! s:UpdateCommentString()
	let stack = synstack(line('.'), col('.'))
	if !empty(stack)
		let name = synIDattr(stack[0], "name")
		if name ==# 'vimLuaRegion'
			let &commentstring = '--%s'
		elseif name ==# 'vimPerlRegion' || name ==# 'vimPythonRegion' || name ==# 'vimRubyRegion'
			let &commentstring = '#%s'
		else
			let &commentstring = b:original_commentstring
		endif
	else
		let &commentstring = b:original_commentstring
	endif
endfunction

augroup ContextCommentstring
	autocmd!
	autocmd CursorMoved *.vim call <SID>UpdateCommentString()
augroup END
