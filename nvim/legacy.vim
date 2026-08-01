"  _  __                 _
" | |/ /___ _   _    ___| |__   __ _ _ __   __ _  ___  ___
" | ' // _ \ | | |  / __| '_ \ / _` | '_ \ / _` |/ _ \/ __|
" | . \  __/ |_| | | (__| | | | (_| | | | | (_| |  __/\__ \
" |_|\_\___|\__, |  \___|_| |_|\__,_|_| |_|\__, |\___||___/
"           |___/                          |___/

" Note to self: possible key candidates to be remapped as handy operators,
" since I rarely use them: K, H, L, M, Q, ^Q, ^P, ^N.

" Like & (repeat last substitute), but repeating the same flags.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Don't do dangerous things.
nnoremap ZQ <Nop>
nnoremap ZZ <Nop>

" Try to be smart: if accidentally you press 'jj' or 'kk' in insert mode, you
" will be brought back to normal mode. Is also easier to press than <ESC>.
inoremap jj <ESC>
inoremap kk <ESC>
" Be more carful with this, because 'll' and 'hh' are somewhat used in practice
" inoremap lll <ESC>
" inoremap hhh <ESC>

" If pumvisible accept the entry (C-y) and add a punctuation char at the end.
inoremap <expr> ,, pumvisible() ? "\<C-y>\<C-o>A," : "\<C-o>A,"
inoremap <expr> ,: pumvisible() ? "\<C-y>\<C-o>A:" : "\<C-o>A:"
inoremap <expr> ,; pumvisible() ? "\<C-y>\<C-o>A;" : "\<C-o>A;"
inoremap <expr> ,. pumvisible() ? "\<C-y>\<C-o>A." : "\<C-o>A."

" Make some keys add an undo break, which allows one to undo a long piece of
" inserted text piecewise, not all at once. Since some keys are already mapped
" by some plugins (smartinput for example), the tweak has to be done there.
" inoremap <CR> <C-G>u<CR>
" inoremap <BS> <C-G>u<BS>

" Make the dot command useful in visual mode (good suggestion, nelstrom).
xnoremap . :normal .<CR>

" Map the return and backspace keys to a function that edits in normal mode.
nnoremap <silent> <CR> :<C-u>call <SID>NormalModeEdit('cr')<CR>
nnoremap <silent> <BS> :<C-u>call <SID>NormalModeEdit('bs')<CR>
" The function is still rough, some edge cases might need polish. See the
" insertlessly plugin as an alternative.
function! s:NormalModeEdit(key)
	if a:key ==# "cr"
		if &buftype ==# ""
			execute "normal! i\<CR>"
		else
			execute "normal! \<CR>"
		endif
	elseif a:key ==# "bs"
		if col('.') == 1
			execute "normal! kJl"
		else
			execute "normal! X"
		endif
	endif
endfunction

" Press the space key (which is easier to press) to start command line mode.
nmap <space> :
xmap <space> :

" Change the single quote and the grave to be the opposite of each other
nnoremap ' `
nnoremap ` '

" A little trick for opening 'local' folds. First close all folds in the
" context, then open them recursively. The net result is opening folds not in
" the cursor, but in the same context (e.g., a function).
nmap z<space> zczO

" Map <leader>l (for 'label') as a synonym for for the 'tag' shortcut.
nmap <leader>l <C-]>

" Map the CTRL-F (almost unused in insert mode) to the omnicompletion one
"imap <C-f> <C-x><C-o>

" Mappings for the command-line.
" cnoremap <C-A> <Home>
" cnoremap <C-F> <Right>
" cnoremap <C-B> <Left>
cnoremap <C-J> <C-F>

" Make window management a little bit more easy: map all the C-W <foobar> to
" <leader>w<foobar>
nmap <leader>w <C-w>
xmap <leader>w <C-w>

" Convenient shortcut for closing a buffer without closing a window. First
" change to another buffer (depending on if the alternate buffer is listed or
" not), and then close the initial one.
nmap <silent> <leader>q :if buflisted(expand('#'))<BAR>b #<BAR>
	\ else<BAR>bnext<BAR>endif<BAR>
	\ bdelete #<CR>
	" \ if buflisted(expand('#'))<BAR>bdelete #<BAR>endif<CR>

" Clear and redraw the screen. Usually is C-L, but is mapped to something else.
nmap <leader>r :redraw!<CR>

" Easily hide the highlighting of the search
nmap <leader>h :nohlsearch<CR>

" Common paste operations.
nmap <leader>p "+p
nmap <leader>P "*p

" Toggle the use of cursor column and cursor line
nmap <silent> <leader><leader>cc :set cursorcolumn!<CR>
nmap <silent> <leader><leader>cl :set cursorline!<CR>

" Switch to the previous buffer
nmap <leader>bb :b #<CR>

" Helper trick to switch buffers comfortably.
nmap <leader>b<space> :ls<CR>:b<space>
nmap <leader>B<space> :ls!<CR>:b<space>

" Update the diff highlighting.
nmap <leader>du :diffupdate<CR>

" Substitute what's under the cursor, or current selection.
" FIXME: escape regex character, like selecting /foo/bar and the slashes are there
nnoremap <leader>S :%s/\<<C-R><C-w>\>//c<left><left>
xnoremap <leader>S y:%s/<C-R>"//c<left><left>

" Select what was recently 'modified' (changed, yanked or pasted).
nnoremap <expr> <leader>m "`[" . strpart(getregtype(), 0, 1) . "`]"

" Experiment
" imap <M-.> <C-X>/ " Doesn't work in qvim...
" imap <C-F> <Right>
" imap <C-B> <Left>
" Craptastic
" imap <M-H> <Left>
" imap <M-J> <Down>
" imap <M-K> <Up>
" imap <M-L> <Right>
" inoremap <M-A> <C-O>^ "Shit, this is equivalent to 'á'. :-(
" inoremap <M-E> <C-O>$

" Toggle the 'a' option (automatic formatting) in formatoptions.
nnoremap <silent> <leader>fa :call <SID>ToggleAutoFormatting()<CR>
function! s:ToggleAutoFormatting()
	if &formatoptions=~'a'
		let &l:formatoptions = substitute(&fo, 'a', '', '')
		echo 'Format options: ' . &fo
	else
		let &l:formatoptions.= 'a'
		echo 'Format options: ' . &fo
	endif
endfunction

" This should change the behaviour of Spanish keys in normal/visual/etc. mode.
" However, it has been buggy in my experience, as it only worked on native Vim
" actions with brackets (e.g., [c or ]p), but not on sequences mapped by the
" user, like the ones provided by unimpaired.vim.
" http://groups.google.com/group/vim_use/browse_thread/thread/bda0c89bcdb330d1
" Will try to research about it, because it might be a bug to report.
set langmap=ñ[,ç],Ñ{,Ç}

" The langmap above doesn't work in all situations, but adding the next mappings
" to the mix makes the Ñ/Ç keys do what I want, so keep both for now.
map ñ [
map Ñ {
map ç ]
map Ç }

" Ease the pain in insert mode that is to type {} and [] with a Spanish
" keyboard, because smartinput helps, but not that much with the first char.
inoremap <C-x>r []<left>
inoremap <C-x>b {}<left>
inoremap <C-x>m {{}}<left><left>

" Text objects for 'rectangular' and 'angular' brackets (surround plugin-style).
onoremap ir i[
onoremap ar a]
" onoremap ia i<
" onoremap aa i>

" Stuff for whatever reason I type awfully bad all the time.
iabbr tODO TODO
iabbr fIXME FIXME
iabbr hte the

" Function and command for removing (with confirmation) trailing whitespace.
command! RemoveTrailingWhiteSpace call <SID>RemoveTrailingWhiteSpace()
function! s:RemoveTrailingWhiteSpace()
	" Save last search and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	%s/\s\+$//ce
	" Restore previous search history and cursor position.
	let @/=_s
	call cursor(l, c)
endfunction


"  _______                 _             _
" |__   __|               (_)           | |
"   | | ___ _ __ _ __ ___  _ _ __   __ _| |
"   | |/ _ \ '__| '_ ` _ \| | '_ \ / _` | |
"   | |  __/ |  | | | | | | | | | | (_| | |
"   |_|\___|_|  |_| |_| |_|_|_| |_|\__,_|_|

" Sources of inspiration:
" http://michaelabrahamsen.com/posts/replace-tmux-with-neovim/
" http://hkupty.github.io/2016/Ditching-TMUX/
" https://www.reddit.com/r/neovim/comments/6kf7vh/i_have_been_doing_everything_inside_of_neovims/
" https://medium.com/@garoth/neovim-terminal-usecases-tricks-8961e5ac19b9

function! TerminalList() abort
	let result = []
	for i in range(1, bufnr("$"))
		if bufexists(i) && getbufvar(i, '&buftype') == 'terminal'
			call add(result, i)
		endif
	endfor
	return result
endfunction

function! TerminalPrevious() abort
	let list = TerminalList()
	let current = index(list, bufnr('%'))
	execute "buffer " . list[ current - 1 ]
endfunction

function! TerminalNext() abort
	let list = TerminalList()
	let current = index(list, bufnr('%'))
	execute "buffer " . list[ current + 1 ]
endfunction

" Neovim's terminal
if has('nvim')
	" I need to figure out the really comfortable way to escape. Many apps (e.g.
	" aptitude) use the 'j' key to do something meaningful. The delay when
	" running interactive apps it's a problem, but typing it's not.
	tnoremap ,, <C-\><C-n>
	" tnoremap <Esc> <C-\><C-n>
	" tnoremap jj <C-\><C-n>
	" tnoremap kk <C-\><C-n>

	tnoremap <silent> <C-j>c <C-\><C-n>:terminal<Return>

	" Consider this simple buffer change, instead of terminal specific ones.
	" tnoremap <silent> <C-j>p <C-\><C-n>:bprevious<Return>
	" tnoremap <silent> <C-j>n <C-\><C-n>:bnext<Return>
	tnoremap <silent> <C-j>p <C-\><C-n>:call TerminalPrevious()<Return>
	tnoremap <silent> <C-j>n <C-\><C-n>:call TerminalNext()<Return>
endif

" Start in 'terminal mode' (i.e. type to the terminal) automatically
" autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
" TODO: doesn't work on the first invocation of ':terminal'

" TODO: Features to implement to migrate away from tmux:
" <prefix>l change to last terminal
" <prefix>c create a new terminal (DONE!)
" <prefix>0 jump to terminal 0 (likewise for 1, 2, ...)
" <prefix>w show the list of terminals to jump to them easily (use Unite buffer?)
" <prefix>n Go to the next terminal (DONE!)
" <prefix>p Go to the next terminal (DONE!)

" vim:foldmethod=marker:noet:ts=4:sw=4:
