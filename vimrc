lua require 'init-prelude'
lua require 'init-options'

"  ____  _             _         _       _ _
" |  _ \| |_   _  __ _(_)_ __   (_)_ __ (_) |_
" | |_) | | | | |/ _` | | '_ \  | | '_ \| | __|
" |  __/| | |_| | (_| | | | | | | | | | | | |_
" |_|   |_|\__,_|\__, |_|_| |_| |_|_| |_|_|\__|
"                |___/
" {{{

" Set and create specific directories on $HOME and similar to avoid littering
" the filesystem with Vim specific stuff at the root level. Do this early to
" allow plugins to be configured in terms of this directory.
let s:data_dir = has('win32') ? '$APPDATA/Vim' :
			\ match(system('uname'), "Darwin") > -1 ? '~/Library/Vim' :
			\ empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'
let s:data_dir = expand(s:data_dir)

if exists("*mkdir")
	if !isdirectory(s:data_dir)
		call mkdir(s:data_dir, "p")
	endif
endif

" Pathogen is a freaking awesome plugin for managing other plugins where each
" one is in a directory of it's own, instead of all mixed in the same. This
" allows to install, remove and update your plugins with lots of ease. You just
" have to put them in a directory that pathogen can find and initialize. By
" default is '~/.vim/bundle' (or '~\vimfiles\bundle' under windows). First, load
" the pathogen plugin itself from its own directory.
runtime bundle/pathogen/autoload/pathogen.vim

" You can disable a plugin (but keep the files around) renaming the directory to
" a name with a trailing '~'. In my case I use git submodules, so renaming is
" not convenient. I use the g:pathogen_blacklist variable (with a helper
" function), to disable plugins conditionally. To disable plugins without
" changing the configuration, use the $VIMBLACKLIST environment variable.
function! s:disable(...)
	for plugin in a:000
		call add(g:pathogen_blacklist, plugin)
	endfor
endfunction

let g:pathogen_blacklist = []

" Initialize all the plugins by calling pathogen, but only if it exists, since
" I might be using this vimrc but without all the runtime files on '~/.vim'.
if exists('*pathogen#infect')
	execute pathogen#infect()
	" Equivalent to :Helptags (which generates the help tags for all plugins),
	" but better not to run it at startup/reload, since it is too slow.
	" call pathogen#helptags()
	" helptags ALL
endif

" This is copied from sensible.vim. There is not any updated matchit version.
" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
endif

" }}}


"  ____  _             _                  _
" |  _ \| |_   _  __ _(_)_ __    ___  ___| |_ _   _ _ __
" | |_) | | | | |/ _` | | '_ \  / __|/ _ \ __| | | | '_ \
" |  __/| | |_| | (_| | | | | | \__ \  __/ |_| |_| | |_) |
" |_|   |_|\__,_|\__, |_|_| |_| |___/\___|\__|\__,_| .__/
"                |___/                             |_|
" {{{

" TODO: The setup of the plugins is fine for now, but if I want to eventually
" move to an init.lua that is usable standalone, without plugins (e.g. for root
" user), like this vimrc used to be, I would need to add a check on plugins
" presence, then call this setup, or fallback to some manual settings. An
" example of it is the statusline set (far) below. It used to check for Airline,
" but now it checks for mini.nvim. That setting needs to be moved and grouped
" with other ones, that are only done so conditionally as fallback.
lua require 'init-setup-plugins'
lua require 'init-lsp'

" Fugitive mappings that restore previous mappings. We make them recursive, so
" they trigger the new maps, which trigger the right fugitive function.
autocmd FileType fugitive      nmap <buffer> q gq
autocmd FileType fugitiveblame nmap <buffer> q gq

" Enable markdown folding.
let g:markdown_folding=1

" }}}



" Submode. "{{{
" Raise the timeout length in submodes a little bit (default is timeoutlen).
let g:submode_timeoutlen=3000

" Configuration for the submode plugin.
runtime autoload/submode.vim
" FIXME: For some reason submode fails with Neovim 0.8. Figure out what's wrong.
if exists('*submode#map') && v:lua.vim.version().minor < 8
	" Submode for resizing the window.
	call submode#enter_with('resize-window', 'n', '', '<C-W>+', '<C-W>+')
	call submode#enter_with('resize-window', 'n', '', '<C-W>-', '<C-W>-')
	call submode#enter_with('resize-window', 'n', '', '<C-W>>', '<C-W>>')
	call submode#enter_with('resize-window', 'n', '', '<C-W><', '<C-W><')
	call submode#map('resize-window', 'n', '', '+', '<C-W>+')
	call submode#map('resize-window', 'n', '', '-', '<C-W>-')
	call submode#map('resize-window', 'n', '', '<', '<C-W><')
	call submode#map('resize-window', 'n', '', '>', '<C-W>>')
endif
"}}}

" }}}



"""
""" TODO: convert this into a plugin, or find one equivalent.
"""

" augroup Binary
"   au!
"   au BufReadPre  *.bin let &bin=1
"   au BufReadPost *.bin if &bin | %!xxd -g 1
"   au BufReadPost *.bin set ft=xxd | endif
"   au BufWritePre *.bin if &bin | %!xxd -g 1 -r
"   au BufWritePre *.bin endif
"   au BufWritePost *.bin if &bin | %!xxd -g 1
"   au BufWritePost *.bin set nomod | endif
" augroup END




"  __  __ _
" |  \/  (_)___  ___
" | |\/| | / __|/ __|
" | |  | | \__ \ (__
" |_|  |_|_|___/\___|
"
" {{{

" Add some usual path directory for me.
if (isdirectory('/home/alex/local/bin'))
	let $PATH = '/home/alex/local/bin' . ':' . $PATH
endif

" Allow loading configuration files in the current directory. I've read the
" help, and this seems worth the risk/power tradeoff, as files need to be
" trusted first, and I only expect to ever run simple files from myself.
set exrc

" Allow to move the cursor one character beyond the last. This allows to use
" Return to insert blank lines in between others, without unimpaired's map.
set virtualedit=onemore

" Add 'mac' fileformat, because there are still people as silly as v2msoft.com.
set fileformats+=mac

" Syntax highlighting reduced to some reasonable column.
set synmaxcol=250

" Accelerates saving to swap file and triggering CursorHold.
set updatetime=500

if has("autocmd")
	augroup vimrc
		" Clear all autocommands in the group to avoid defining them multiple
		" times each time vimrc is reloaded. It has to be only once and at the
		" beginning of each augroup.
		autocmd!

		" Jump to the last position when reopening a file.
		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
			\ | exe "normal! g`\"" | endif

	augroup END
endif

" For the `fc` (fix command) in bash
autocmd BufEnter /tmp/bash-fc.* if &filetype == 'sh' | :set tw=0 | endif

" Limit suggestions when spell checking with z=.
set spellsuggest=best,15

" Disable autoselection of the visual region to the clipboard.
set guioptions-=a
set clipboard-=autoselect

" Don't leave two spaces between two sentences (foo.  Bar) when joining lines
set nojoinspaces

" Enable modelines
set modeline

" Show commands as you type them
set showcmd

" Use specific plugins and indentation of the filetype
filetype plugin indent on

" Use visualbell instead of the system beep
set visualbell

" Allow hidden buffers without that many prompts, but caution when using ':q!'
set hidden

" scrolloff: Make the text scroll some lines before the cursor reaches the border
set so=3

" Allow the backspace to do useful things (is not the default everywhere)
set backspace=indent,eol,start

" Allow more time between keystrokes for some key mappings.
set timeout timeoutlen=1600

" But not for for key codes. Use a very small value for them.
set ttimeout ttimeoutlen=50

" Ensure the swap and undo directories.
if exists("*mkdir")
	if !isdirectory(s:data_dir . "/undo")
		call mkdir(s:data_dir . "/undo", "p")
	endif
	if !isdirectory(s:data_dir . "/swap")
		call mkdir(s:data_dir . "/swap", "p")
	endif
endif

" Save the undo history in a persistent file, not just while Vim is running.
if has('persistent_undo')
	set undofile
	set undolevels=2000 " Double the number of undo levels.
	let &undodir = s:data_dir . '/undo,.,/var/tmp,/tmp'
	autocmd BufEnter /tmp/* setlocal noundofile
endif


" Save the swap files on a different directory.
let &directory = s:data_dir . '/swap,.,/var/tmp,/tmp'

" Save a lot more history
set history=200

" Better to be noisy than find something unexpected.
set noautoread
set noautowrite

" Trigger checktime to get updates on file change more often
au FocusGained * :checktime

" Set Blowfish for encryption method, but only on Vim >=7.3.
if has('cryptv') && v:version >= 703 | set cryptmethod=blowfish | endif

" Save and restore g:UPPERCASE variables in viminfo.
if !empty(&viminfo)
	set viminfo^=!
endif

" Change diff options. Careful don't overwrite the defaults, which include
" `internal`, which is essential in Windows, as there is no `diff.exe` anymore.
set diffopt+=vertical

" Neovim specific tweaks.
if has('nvim')
	" Unfortunately, is quite problematic with Konsole.
	set guicursor=
	" Still under test
	let $VISUAL = "nvr --remote-tab-wait +'set bufhidden=delete'"

	" :h vim.highlight.on_yank
	autocmd TextYankPost * silent! lua vim.highlight.on_yank({timeout=350})
endif


"  _   _ _       _     _ _       _     _   _
" | | | (_) __ _| |__ | (_) __ _| |__ | |_(_)_ __   __ _
" | |_| | |/ _` | '_ \| | |/ _` | '_ \| __| | '_ \ / _` |
" |  _  | | (_| | | | | | | (_| | | | | |_| | | | | (_| |
" |_| |_|_|\__, |_| |_|_|_|\__, |_| |_|\__|_|_| |_|\__, |
"          |___/           |___/                   |___/

" Enable highlight of lua, python and ruby in vimscript.
let g:vimsyn_embed= "lPr"

" Activates syntax highlighting, but keeping current color settings. From the
" documentation: "If you want Vim to overrule your settings with the
" defaults, use ':syntax on'".
syntax enable

" Highlight the opening bracket/parentheses when the closing one is written
set showmatch


"
"    / \   _ __  _ __   ___  __ _ _ __ __ _ _ __   ___ ___
"   / _ \ | '_ \| '_ \ / _ \/ _` | '__/ _` | '_ \ / __/ _ \
"  / ___ \| |_) | |_) |  __/ (_| | | | (_| | | | | (_|  __/
" /_/   \_\ .__/| .__/ \___|\__,_|_|  \__,_|_| |_|\___\___|
"         |_|   |_|

" Seems to speed a lot the redraw on GVim, and makes cursorline usable again.
set lazyredraw

" Set the characters for statusline (& non current stl), vsplit, fold & diff.
" TODO: some characters don't work with some colorschemes because use bold, etc.
" set fillchars=vert:┃,fold:=,diff:·
set fillchars=vert:┃,fold:═,diff:·

" See the cursor line and the offset with the adjacent lines.
set number
if exists('+relativenumber')
	set relativenumber
endif

" cul: Highlight the line in which the cursor is in. Caution, can be very slow.
set cursorline

" Show some chars to denote clearly where there is a tab or trailing space
set list
" Boring but 'safe' characters.
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
" TODO: only set this characters in some constrained conditions. But which ones?
let &listchars = "tab:\u21e5 ,nbsp:\u00b7,extends:\u276d,precedes:\u276c,trail:\u2423"

" This is what sensible.vim uses. I'm not sure that I understand the checks. Why
" can't be set on win32? See:
" https://github.com/tpope/vim-sensible/commit/3ffe25ce1d78e884879cc8c26d5a7ea6a14f4d49
" if !has('win32') && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
" 	let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
" endif

" colorcolumn: Use a colored column to mark the textwidh+1 column (Vim >=7.3).
if exists('+colorcolumn')
	set cc=+1
endif

" fen: enable folds by default. Can be swiftly disabled with 'zi'.
set foldenable

" fdm: sets the default folding behaviour.
set foldmethod=syntax

" fdls: the level of nested folds that will be closed initially.
set foldlevelstart=4

" foldcolumn: Use a 0 characters wide column to display folding information.
set fdc=0

" laststatus: Show the statusbar always, not only on last window
set ls=2

" For default statusline.
set ruler

" Customize the statusbar. The default is something like this (with ruler):
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" An example using several colors
" set statusline=
" set statusline +=%1*\ %n\ %*            "buffer number
" set statusline +=%5*%{&ff}%*            "file format
" set statusline +=%3*%y%*                "file type
" set statusline +=%4*\ %<%F%*            "full path
" set statusline +=%2*%m%*                "modified flag
" set statusline +=%1*%=%5l%*             "current line
" set statusline +=%2*/%L%*               "total lines
" set statusline +=%1*%4c\ %*             "column number
" set statusline +=%2*0x%04B\ %*          "character under cursor

" Set a fallback statusline, but only if mini.nvim is not present.
if !empty(globpath(&packpath, 'pack/plugin/start/mini.nvim', 0, 1))
	" Clear it first to start fresh each invocation
	set statusline=
	" Buffer name with 2 minimum width
	set statusline+=%2.n
	" Full path, but truncate the statusbar here if it's too long
	set statusline+=\ %<%F
	" a space, User1 color, modified flag, restore color
	set statusline+=\ %1*%m%*
	" Git information from fugitive plugin.
	if exists('fugitive#statusline')
		set statusline+=\ %{fugitive#statusline()}
	endif
	" Push everything else to the right
	set statusline+=\ %=
	" Modified, RO, help, preview, quickfix
	" set statusline+=\ %R%H%W%q " 'q' is not available in 7.2??
	set statusline+=\ %R%H%W
	" Filetype in User1 color
	set statusline+=\ %1*%y%*
	" Ruler
	set statusline+=\ %-14.(%l,%c%V%)
	" Percentage
	set statusline+=\ %P
endif

if has('termguicolors') " Both Vim8 and Neovim support this
	set termguicolors
endif

" Set some things depending on the OS and the presence of a GUI
if has("gui_running")
	if !has('win32') && !has('mac')
		set guifont=DejaVu\ Sans\ Mono\ 9
		" TODO: support some kind of ".local" file that overrides this things.
		if hostname() ==# 'rallo'
			set guifont=DejaVu\ Sans\ Mono\ 12
		endif
	elseif has('win32')
		set guifont=Consolas:h10:cANSI
		set guifont=DejaVu_Sans_Mono:h10:cANSI
	else
		set guifont=DejaVu_Sans_Mono:h13
	endif
	set guioptions-=T " Get rid of the toolbar and the menu.
	set guioptions-=m
	set guioptions+=LlRrb " Get rid of scrollbars...
	set guioptions-=LlRrb " ... for some reason requires 2 lines (???)
	set background=dark
else
	try
		colorscheme gruvbox8_hard
	catch
		colorscheme desert
	endtry
endif

" Extra space (in pixels) between two lines (GUI only).
set linespace=2

" TODO: I don't even remember this, but I think this was the logic I wanted, and
" it only works as it should with my pull request to NeovimQt. I would have to
" look into the help of nvim-gui-shim, but that suggests ginit.vim.
if has('nvim') && exists('g:GuiLoaded')
	function! s:NeovimGuiSetup()
		GuiLinespace 2
		GuiFont DejaVu Sans Mono:h12
		call GuiWindowMaximized(1)
		colorscheme solarized8_flat
	endfunction
	augroup neovimguiattached
		autocmd!
		autocmd User NeovimGuiAttached call s:NeovimGuiSetup()
		" Doesn't work to detect Neovim-Qt 0.2.15 (triggers on the TUI).
		" autocmd UIEnter * call s:NeovimGuiSetup()
	augroup END
endif


"  _  __                 _
" | |/ /___ _   _    ___| |__   __ _ _ __   __ _  ___  ___
" | ' // _ \ | | |  / __| '_ \ / _` | '_ \ / _` |/ _ \/ __|
" | . \  __/ |_| | | (__| | | | (_| | | | | (_| |  __/\__ \
" |_|\_\___|\__, |  \___|_| |_|\__,_|_| |_|\__, |\___||___/
"           |___/                          |___/

lua require 'init-mappings'

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

" Mappings for the altr plugin.
nmap <leader>A <Plug>(altr-back)
nmap <leader>Z <Plug>(altr-forward)

" Shorthand for HTML/XML completion.
imap <leader>< </<Plug>ragtagHtmlComplete

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

" Restore original fold settings (FIXME: this duplicates the values from this
" very same file, and is not variable).
nmap <leader>fo :set foldmethod=syntax foldlevel=4 foldcolumn=4<Return>

" Substitute what's under the cursor, or current selection.
" FIXME: escape regex character, like selecting /foo/bar and the slashes are there
nnoremap <leader>S :%s/\<<C-R><C-w>\>//c<left><left>
xnoremap <leader>S y:%s/<C-R>"//c<left><left>

" Select what was recently 'modified' (changed, yanked or pasted).
nnoremap <expr> <leader>m "`[" . strpart(getregtype(), 0, 1) . "`]"

" Shortcuts for the exjumplist plugin.
nmap <Leader>i <Plug>(exjumplist-next-buffer)
nmap <Leader>o <Plug>(exjumplist-previous-buffer)

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
if exists(':Abolish')
	Abolish definetely definitely
endif

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


"   ____                      _      _   _
"  / ___|___  _ __ ___  _ __ | | ___| |_(_) ___  _ __
" | |   / _ \| '_ ` _ \| '_ \| |/ _ \ __| |/ _ \| '_ \
" | |__| (_) | | | | | | |_) | |  __/ |_| | (_) | | | |
"  \____\___/|_| |_| |_| .__/|_|\___|\__|_|\___/|_| |_|
"                      |_|

" Activate completion of the command line.
set wildmenu

" Complete longest common string, then each full match
set wildmode=list:longest,list:full

" Behaviour of completion 'popup'
set completeopt=menuone,longest

" suffixes: Patterns with a lower priority in completion.
set su+=.asc,.cfg

" wildignore: Patterns to completely ignore when completing.
set wig+=*.pdf,*.png,*.jpg,*.jpeg,*.ttf,*.otf,*.qpf2,*.wav,*.mp3,*.ogg

" Ignore case in the command line.
if exists('+wildignorecase') | set wildignorecase | endif

" A moderately simple alternative to the SuperTab plugin.
function! s:CleverTab()
	" Use tab for going forward in the pop up menu (pum).
	if pumvisible()
		return "\<C-n>"
	" Check if the cursor is at the beginning of line or after whitespace
	elseif col('.') == 1 || strpart( getline('.'), 0, col('.')-1 ) =~ '\s$'
		return "\<Tab>"
	else
		" If the previous text looks like a path, use filename completion.
		if strpart( getline('.'), 0, col('.')-1 ) =~ '/$'
			return "\<C-x>\<C-f>"
		" Use omnifunc if available
		elseif &omnifunc != ''
			return "\<C-X>\<C-O>"
		" Otherwise use the dictionary completion
		elseif &dictionary != ''
			return "\<C-K>"
		else
			return "\<C-P>"
		endif
	endif
endfunction
inoremap <silent> <Tab> <C-R>=<SID>CleverTab()<CR>
inoremap <silent> <S-Tab> <C-p>


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
