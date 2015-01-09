augroup FoldComments
    autocmd!
    autocmd BufReadPost * :call s:Fold()
augroup END

function! s:Fold() abort
    let starting_position = getcurpos()
    keepjumps normal! gg
    " TODO: be smart and only fold if the comment has copyright info.
    if hlID("Comment") == synIDtrans(synID(line("."), col("."), 0))
        silent! normal! zc
    endif
    call setpos('.', starting_position)
endfunction
