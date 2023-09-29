if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=//%s
" See `:h format-comments`. The option is a comma separated {flags}:{string},
" where the flags are optional. We say that `//` is a comment and the others
" work to make lists.
setlocal comments=://,fb:-,fb:*,fb:.

" Adapted from runtime/ftplugin/man.vim
function! s:show_toc() abort
    let bufname = bufname('%')
    let info = getloclist(0, {'winid': 1})
    if !empty(info) && getwinvar(info.winid, 'qf_toc') ==# bufname
        lopen
        return
    endif

    let toc = []
    let lnum = 2
    let last_line = line('$') - 1

    while lnum && lnum < last_line
        let text = getline(lnum)
        " Space after the equal signs to distinguish from blocks wrapped in ====
        if text =~# '^=\{2,4} '
            " This shit doesn't work to make the numbers properly align. It
            " seems like the text returned by printf gets converted back to a
            " number, making it kinda useless.
            " call add(toc, {'bufnr': bufnr('%'), 'lnum': printf("%2d", lnum), 'text': text})
            call add(toc, {'bufnr': bufnr('%'), 'lnum': lnum, 'text': text})
        endif
        let lnum = nextnonblank(lnum + 1)
    endwhile

    call setloclist(0, toc, ' ')
    " Sets the title, but it's not very visible or useful.
    call setloclist(0, [], 'a', {'title': 'Table of Contents'})
    lopen
    let w:qf_toc = bufname
endfunction

nnoremap <silent><buffer> gO :call <sid>show_toc()<cr>
