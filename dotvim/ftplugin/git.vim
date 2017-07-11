" FIXME: the right thing would be b:git_ftplugin I think, but I was getting
" weird results when opening a new buffer.
if exists('g:git_ftplugin')
    finish
endif

function! s:FindCommit(options) abort
    let flags = a:options . 'W' " Don't wrapscan (i.e. don't return to start)
    return search('^commit ', flags)
endfunction

function! s:ShowCommit() abort
    let position = s:FindCommit('bnc') " Backwards, no cursor move, cursor-match
    if position
        let line = getline(position)
    else
        let line = getline('.')
    endif
    let commit_hash = split(line)[1]
    execute 'Gtabedit ' . commit_hash
endfunction

nnoremap <buffer> <C-n> :<C-u>call <SID>FindCommit('')<Return>
nnoremap <buffer> <C-p> :<C-u>call <SID>FindCommit('b')<Return>
nnoremap <buffer> <Return> :<C-u>call <SID>ShowCommit()<Return>

let g:git_ftplugin = 1
