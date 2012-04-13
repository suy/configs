"  ____  _             _
" |  _ \| |_   _  __ _(_)_ __  ___
" | |_) | | | | |/ _` | | '_ \/ __|
" |  __/| | |_| | (_| | | | | \__ \
" |_|   |_|\__,_|\__, |_|_| |_|___/
"                |___/

" Pathogen is a freaking awesome plugin for managing other plugins where each
" one is in a directory of it's own, instead of all mixed in the same. This
" allows to install, remove and update your plugins with lots of ease. You just
" have to put them in a directory that pathogen can find and initialize. By
" default is '~/.vim/bundle' (or '~\vimfiles\bundle' under windows). First, load
" the pathogen plugin itself from its own directory.
runtime bundle/pathogen/autoload/pathogen.vim

" You can disable a plugin (but keep the files) if you rename the directory by
" adding a trailing '~' to it. In my case I use git submodules, so renaming is
" not convenient, and I use the g:pathogen_disabled variable, that you can
" manipulate conditionally if you want.
let g:pathogen_disabled = [
		\ 'simple-javascript-indenter',
		\ 'web-indent',
		\ 'autoclose',
		\ 'space']

" Disable css-color in the console, because it slows down too much.
if !has('gui_running')
	call add(g:pathogen_disabled, 'css-color')
endif

" Initialize all the plugins by calling pathogen, but only if it exists, since
" I might be using this vimrc but without all the runtime files on '~/.vim'.
if exists('*pathogen#infect')
	call pathogen#infect()
	" Equivalent to :Helptags (which generates the help tags for all plugins),
	" but better not to run it at startup/reload, since it is too slow.
	" call pathogen#helptags()
endif

" Use plugins that are included with Vim 7
runtime macros/matchit.vim

" Configuration for UltiSnips. Use CTRL+S (unused in insert mode) to invoke a
" snippet. This way, your <tab> can be free for other completion actions.
let g:UltiSnipsExpandTrigger="<C-S>"
let g:UltiSnipsListSnippets="<C-Q>"
" These other two are the defaults. Left here as a reminder.
" let g:UltiSnipsJumpForwardTrigger="<C-J>"
" let g:UltiSnipsJumpBackwardTrigger="<C-K>"
" Since I don't like the default snippets much, use my own directory only.
let g:UltiSnipsSnippetDirectories=["ultisnippets"]

" Powerline configuration.
let g:Powerline_symbols="unicode"
let g:Powerline_stl_path_style="short"
" let g:Powerline_theme="solarized"
if exists('*Pl#Theme#RemoveSegment')
	call Pl#Theme#RemoveSegment('fileformat')
	call Pl#Theme#RemoveSegment('fileencoding')
endif

" Configuration for Insertlessly.
let g:insertlessly_cleanup_trailing_ws = 0
let g:insertlessly_cleanup_all_ws = 0

" Raise the timeout length in submodes a little bit (default is timeoutlen).
let g:submode_timeoutlen=3000

" Configuration for the submode plugin.
if exists('*submode#map')
	" Submode for resizing the window.
	call submode#enter_with('resize-window', 'n', '', '<C-W>+', '<C-W>+')
	call submode#enter_with('resize-window', 'n', '', '<C-W>-', '<C-W>-')
	call submode#enter_with('resize-window', 'n', '', '<C-W>>', '<C-W>>')
	call submode#enter_with('resize-window', 'n', '', '<C-W><', '<C-W><')
	call submode#map('resize-window', 'n', '', '+', '<C-W>+')
	call submode#map('resize-window', 'n', '', '-', '<C-W>-')
	call submode#map('resize-window', 'n', '', '<', '<C-W><')
	call submode#map('resize-window', 'n', '', '>', '<C-W>>')

	" Submode for moving through the changelist.
	call submode#enter_with('changelist', 'n', '', 'g,', 'g,')
	call submode#enter_with('changelist', 'n', '', 'g;', 'g;')
	call submode#map('changelist', 'n', '', ',', 'g,')
	call submode#map('changelist', 'n', '', ';', 'g;')

	" Submode for moving through changes in diff mode.
	call submode#enter_with('diff-mode', 'n', '', '[c', '[c')
	call submode#enter_with('diff-mode', 'n', '', ']c', ']c')
	call submode#map('diff-mode', 'n', '', 'k', '[c')
	call submode#map('diff-mode', 'n', '', 'j', ']c')
	call submode#map('diff-mode', 'n', '', 'p', 'dp')
	call submode#map('diff-mode', 'n', '', 'o', 'do')
endif

" Define commands for the exjumplist plugin.
command! JumplistLast           call exjumplist#go_last()
command! JumplistFirst          call exjumplist#go_first()
command! JumplistPreviousBuffer call exjumplist#next_buffer()
command! JumplistNextBuffer     call exjumplist#previous_buffer()

" Smartinput customization. Rules have to be added with define_rule. But for
" rules to be triggered a mapping is needed. Since the default rules already map
" some keys to the generic function that looks for a match, one doesn't need to
" create that map. The exception is if you want to change the default behaviour
" of a key, like how is done here, where <Space>, if it doesn't expand anything
" returns a <Space> but preceded with an undo break.
call smartinput#define_rule({
\	'at':       '/\%#',
\	'char':     '*',
\	'input':    '**/<Left><Left>',
\	'filetype': ['css']
\})
call smartinput#define_rule({
\	'at':       '/\*\%#\*/',
\	'char':     '<Space>',
\	'input':    '<Space><Space><Left>',
\	'filetype': ['css']
\})
call smartinput#define_rule({
\	'at':       '/\* \%# \*/',
\	'char':     '<BS>',
\	'input':    '<Del><BS>',
\	'filetype': ['css']
\})
call smartinput#define_rule({
\	'at':       '/\*\%#\*/',
\	'char':     '<BS>',
\	'input':    '<Del><Del><BS><BS>',
\	'filetype': ['css']
\})
call smartinput#map_to_trigger('i', '*', '*', '*')
call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<C-G>u<Space>')

" Additional rules for spaces inside parentheses.
call smartinput#define_rule({
\	'at':       '(\%#)',
\	'char':     '<Space>',
\	'input':    '<Space><Space><Left>',
\})
call smartinput#define_rule({
\	'at':       '( \%# )',
\	'char':     '<BS>',
\	'input':    '<Del><BS>',
\})


"  _____                          _   _   _
" |  ___|__  _ __ _ __ ___   __ _| |_| |_(_)_ __   __ _
" | |_ / _ \| '__| '_ ` _ \ / _` | __| __| | '_ \ / _` |
" |  _| (_) | |  | | | | | | (_| | |_| |_| | | | | (_| |
" |_|  \___/|_|  |_| |_| |_|\__,_|\__|\__|_|_| |_|\__, |
"                                                 |___/

" textwidth: break lines when this maximum line length is reached (use 0 to
" disable). This is sometimes called 'hard breaking', because it inserts an EOL.
set tw=80

" wrapmargin: break lines when only 'wm' columns are left. Ignored if tw is set,
" which is probably the proper one to use, since 'wm' would make line formatting
" dependent on the size of the window.
" set wm=5

" Change default formatting options. Options are described in fo-table. The 'a'
" option is for automatic formatting.
" TODO: This format option is plain wrong for all files. Try to think which
" filetypes should use it (if any) by default, and add the option conditionally.
" set fo+=a

" Don't display long lines that don't fit in the window as if were broken.
" set nowrap

" linebreak: break wrapped lines at specific characters, not simply at the last
" one that fits. Doesn't apply if 'wrap' is unset, or 'list' is set.
set lbr

" breakat: fine tune which character can cause a soft break (the one caused by
" linebreak). Vim defaults are appropriate in general.
" set brk

" showbreak: show this string at the beginning of a line that is soft broken.
set sbr=➥➥➥


"  _____     _
" |_   _|_ _| |__  ___
"   | |/ _` | '_ \/ __|
"   | | (_| | |_) \__ \
"   |_|\__,_|_.__/|___/
"

" tabstop: Set how many spaces _looks_ a tab.
set ts=4

" shiftwidth: Number of spaces to use for each step of (auto)indent.
" Usually you set it to the tabstop, unless you want to mix spaces and tabs.
set sw=4

" softtabstop: Makes the backspace more consistent with the tab in insert mode
" if you set the shiftwidth and the softtabstop the same value
set sts=4

" Changes tabs with spaces (*beware* when you edit Makefiles)
"set expandtab

" noautoindent: don't autoindent text, cause it's annoying when pasting text
set smartindent


"  __  __ _
" |  \/  (_)___  ___
" | |\/| | / __|/ __|
" | |  | | \__ \ (__
" |_|  |_|_|___/\___|
"

" Set PATH in Windows, because the sysadmins at my workplace are idiots
if has("win32")
	let $PATH.=';D:\Cygwin\bin'
endif

if has("autocmd")
	augroup vimrc
		" Clear all autocommands in the group to avoid defining them multiple
		" times each time vimrc is reloaded. It has to be only once and at the
		" beginning of each augroup.
		autocmd!

		" Jump to the last position when reopening a file.
		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
		  \ | exe "normal! g'\"" | endif

		" Automatically resize window splits when the application is resized.
		autocmd VimResized * exe "normal! \<c-w>="

		" Source .vimrc automatically when it is saved.
		autocmd BufWritePost *vimrc source $MYVIMRC
		" Work around to fix Powerline colors (something clears highlighting).
		" https://github.com/Lokaltog/vim-powerline/issues/28#issuecomment-3492408
		autocmd BufWritePost *vimrc call Pl#Load()

		" Set nopaste once insert mode is left, just in case.
		autocmd InsertLeave * set nopaste
	augroup END
endif

" Use the mouse for selection of text, and position the cursor
"set mouse=a

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

" Automatically cd into the directory that the file is in
"set autochdir

" Allow the backspace to do useful things (is not the default everywhere)
set backspace=indent,eol,start

" Set the ruler (is not visible by default everywhere)
set ruler

" Set encoding to utf-8 for systems that don't have it by default
set encoding=utf-8

" Allow more time between keystrokes for some key shortcuts
set timeoutlen=1600

" Save all the undo history, even of closed files, in a specific directory
set undofile
set undodir=$HOME/.local/share/vim/undo

" Save only cursor and folds on view files
set viewoptions=cursor,folds

" Use a different view directory
set viewdir=$HOME/.local/share/vim/view

" Automatically create and load views of files in entering or exiting them
" FIXME: don't create views for fugitive:// or other temp files
" augroup vimrc
" 	au!
" 	autocmd BufWinLeave *
" 		\   if expand('%') != '' && &buftype !~ 'nofile'
" 		\|      mkview!
" 		\|  endif
" 	autocmd BufWinEnter *
" 		\   if expand('%') != '' && &buftype !~ 'nofile'
" 		\|      silent loadview
" 		\|  endif
" augroup END

" Save a lot more history
set history=200


"  _   _ _       _     _ _       _     _   _
" | | | (_) __ _| |__ | (_) __ _| |__ | |_(_)_ __   __ _
" | |_| | |/ _` | '_ \| | |/ _` | '_ \| __| | '_ \ / _` |
" |  _  | | (_| | | | | | | (_| | | | | |_| | | | | (_| |
" |_| |_|_|\__, |_| |_|_|_|\__, |_| |_|\__|_|_| |_|\__, |
"          |___/           |___/                   |___/

" Activates syntax highlighting
syntax on

" Force a specific type of syntax highlighting
"set syntax=php

" Highlight the opening bracket/parentheses when the closing one is written
set showmatch

" Use the Error colors for trailing whitespace.
match Error /\v\s+$/


"
"    / \   _ __  _ __   ___  __ _ _ __ __ _ _ __   ___ ___
"   / _ \ | '_ \| '_ \ / _ \/ _` | '__/ _` | '_ \ / __/ _ \
"  / ___ \| |_) | |_) |  __/ (_| | | | (_| | | | | (_|  __/
" /_/   \_\ .__/| .__/ \___|\__,_|_|  \__,_|_| |_|\___\___|
"         |_|   |_|

" number: show line number
"set nu

" Set the characters for statusline (& non current stl), vsplit, fold & diff.
" set fillchars=vert:┃,fold:═,diff:·
" TODO: some characters don't work with some colorschemes because use bold, etc.
set fillchars=vert:┃,fold:=,diff:·

" cul: Highlight the line in which the cursor is in. Caution, can be very slow.
set cursorline

" Show some chars to denote clearly where there is a tab or trailing space
set list
set listchars=tab:⇥\ ,trail:·,extends:❬,precedes:❬

" colorcolumn: Use a colored column to mark the textwidh+1 column
set cc=+1

" fen: enable folds by default. Can be swiftly disabled with 'zi'.
set foldenable

" fdm: sets the default folding behaviour.
set foldmethod=indent

" fdl: the level of nested folds that will be closed initially.
set foldlevel=4

" foldcolumn: Use a 4 characters wide column to display folding information.
set fdc=4

" laststatus: Show the statusbar always, not only on last window
set ls=2

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

" Comment out all statusline settings because I handle the statusline with the
" Powerline plugin. TODO: Use the regular statusline when the plugin is not
" available (e.g. on my server).
" " Clear it first to start fresh each invocation
" set statusline=
" " Buffer name with 2 minimum width
" set statusline+=%2.n
" " Full path, but truncate the statusbar here if it's too long
" set statusline+=\ %<%F
" " a space, User1 color, modified flag, restore color
" set statusline+=\ %1*%m%*
" " Git information
" set statusline+=\ %{fugitive#statusline()}
" " Syntastic information
" "set statusline+=\ %{SyntasticStatuslineFlag()}
" " Push everything else to the right
" set statusline+=\ %=
" " Modified, RO, help, preview, quickfix
" set statusline+=\ %R%H%W%q
" " Filetype in User1 color
" set statusline+=\ %1*%y%*
" " Ruler
" set statusline+=\ %(%l,%c%V%)
" " Percentage
" set statusline+=\ %P

" Some configuration options for solarized that have to be applied previously
let g:solarized_termcolors='256'
let g:solarized_italic='0'
let g:solarized_contrast='normal'
" Don't highlight the listchars too much...
let g:solarized_visibility='low'
" ...except the trailing whitespace
let g:solarized_hitrail='1'

" Set some things depending on the OS and the presence of a GUI
if has("gui_running")
	if has("win32")
		set guifont=DejaVu_Sans_Mono:h7.8:cANSI
	else
		set guifont="DejaVu Sans Mono 10"
	endif
	set guioptions-=T " Get rid of the toolbar and the menu.
	set guioptions-=m
	set guioptions+=LlRrb " Get rid of scrollbars...
	set guioptions-=LlRrb " ... for some reason requires 2 lines (???)
	colorscheme solarized
else
	colorscheme molokai
	" Make the listchars darker
	hi SpecialKey ctermfg=240
endif


"  ____                      _     _
" / ___|  ___  __ _ _ __ ___| |__ (_)_ __   __ _
" \___ \ / _ \/ _` | '__/ __| '_ \| | '_ \ / _` |
"  ___) |  __/ (_| | | | (__| | | | | | | | (_| |
" |____/ \___|\__,_|_|  \___|_| |_|_|_| |_|\__, |
"                                          |___/

" Ignore case in searches unless you specify it explicitly (like /PaTTern).
set ignorecase
set smartcase

" Highlight search results, but not on startup.
set hlsearch
nohlsearch

" Use global matching by default in regexes (override adding a /g back)
set gdefault

" Remap the search keys to use the more compatible regular expressions
"nnoremap / /\v
"vnoremap / /\v

" Don't open folds when searching for a match, and show match only one
set foldopen-=search


"  _  __                 _
" | |/ /___ _   _    ___| |__   __ _ _ __   __ _  ___  ___
" | ' // _ \ | | |  / __| '_ \ / _` | '_ \ / _` |/ _ \/ __|
" | . \  __/ |_| | | (__| | | | (_| | | | | (_| |  __/\__ \
" |_|\_\___|\__, |  \___|_| |_|\__,_|_| |_|\__, |\___||___/
"           |___/                          |___/

" Try to be smart: if accidentally you press 'jj' or 'kk' in insert mode, you
" will be brought back to normal mode. Is also easier to press than <ESC>.
inoremap jj <ESC>
inoremap kk <ESC>
" Be more carful with this, because 'll' and 'hh' are somewhat used in practice
" inoremap lll <ESC>
" inoremap hhh <ESC>

" Shortcut in insert mode to add a comma, colon, semicolon or dot at the end.
inoremap ,, <C-O>A,
inoremap ,: <C-O>A:
inoremap ,, <C-O>A,
inoremap ,. <C-O>A.

" Make some keys add an undo break, which allows one to undo a long piece of
" inserted text piecewise, not all at once. Since some keys are already mapped
" by some plugins (smartinput for example), the tweak has to be done there.
" inoremap <CR> <C-G>u<CR>
" inoremap <BS> <C-G>u<BS>

" Map the return and backspace keys to a function that edits in normal mode.
nnoremap <silent> <CR> :<C-u>call NormalModeEdit('cr')<CR>
nnoremap <silent> <BS> :<C-u>call NormalModeEdit('bs')<CR>
" The function is still rough, some edge cases might need polish. See the
" insertlessly plugin as an alternative.
function! NormalModeEdit(key)
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

" Map C-L (for 'label') as a synonym for for the 'tag' shortcut.
map <C-L> <C-]>

" Map the CTRL-F (almost unused in insert mode) to the omnicompletion one
"imap <C-f> <C-x><C-o>

" Mappings for the command-line.
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-J> <C-F>

" Change the 'leader' key to something more easy to press
let mapleader = ","

" Make window management a little bit more easy: map all the C-W <foobar> to
" <leader>w<foobar>
nmap <leader>w <C-w>
xmap <leader>w <C-w>

" Convenient shortcut for closing a buffer without closing a window. First
" change to another buffer (depending on if the alternate buffer is listed or
" not), and then close the initial one.
nmap <silent> <leader>q :if buflisted(expand('#'))<BAR>b #<BAR>
	\ else<BAR>bnext<BAR>endif<CR>:bdelete #<CR>

" Clear and redraw the screen. Usually is C-L, but is mapped to something else.
nmap <leader>r :redraw!<CR>

" Easily toggle invisible characters (listchars). This is very important for:
" - Copying with the mouse to another application (if you don't disable them,
"   will be added to the clipboard, which doesn't make sense).
" - Making linebreak work, because is a documented limitation that doesn't
"   work with :set list. :-(
nmap <leader>l :set list!<CR>:set list?<CR>

" Easily hide the highlighting of the search
nmap <leader>h :nohlsearch<CR>

" Toggle paste on/off when you want to copy in insert mode (e.g. from other app)
nmap <leader>p :set invpaste<CR>

" Toggle the use of cursor column and cursor line
nmap <silent> <leader><leader>cc :set cursorcolumn!<CR>
nmap <silent> <leader><leader>cl :set cursorline!<CR>

" Switch to the previous buffer
nmap <leader>bb :b #<CR>

" Helper trick to switch buffers comfortably.
nmap <leader>b<space> :ls<CR>:b<space>
nmap <leader>B<space> :ls!<CR>:b<space>

" Switch on and off spellchecking
nmap <leader>s :set spell!<CR>:set spell?<CR>

" Activate diff mode and update the diff highlighting.
nmap <leader>dt :diffthis<CR>
nmap <leader>du :diffupdate<CR>

" Substitute what's under the cursor, or current selection.
nnoremap <leader>S yiw:%s/<C-R>"/
xnoremap <leader>S y:%s/<C-R>"/

" Select what was recently 'modified' (changed, yanked or pasted).
nnoremap <expr> <leader>m "`[" . strpart(getregtype(), 0, 1) . "`]"

" Experiment
imap <M-.> <C-X>/
imap <C-F> <Right>
imap <C-B> <Left>
" Craptastic
" imap <M-H> <Left>
" imap <M-J> <Down>
" imap <M-K> <Up>
" imap <M-L> <Right>
" inoremap <M-A> <C-O>^ "Shit, this is equivalent to 'á'. :-(
" inoremap <M-E> <C-O>$

" Toggle the 'a' option (automatic formatting) in formatoptions.
nnoremap <silent> <leader>fa :call ToggleAutoFormatting()<CR>
function! ToggleAutoFormatting()
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

" Function and command for removing (with confirmation) trailing whitespace.
command! RemoveTrailingWhiteSpace call RemoveTrailingWhiteSpace()
function! RemoveTrailingWhiteSpace()
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

" Complete longest common string, then each full match
set wildmode=list:longest,full

" Behaviour of completion 'popup'
set completeopt=menuone,longest,preview

" suffixes: Patterns with a lower priority in completion.
set su+=.asc,.cfg

" wildignore: Patterns to completely ignore when completing.
set wig+=*.pdf,*.png,*.jpg,*.jpeg

" function! CleverTab()
" 	" Check if the cursor is at the beginning of line or after whitespace
" 	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
" 	   return "\<Tab>"
" 	else
" 		" Use omnifunc if available
" 		if &omnifunc != ''
" 			return "\<C-X>\<C-O>"
" 		" Otherwise use the dictionary completion
" 		elseif &dictionary != ''
" 			return "\<C-K>"
" 		else
" 			return "\<C-P>"
" 		endif
" 	endif
" endfunction
" inoremap <Tab> <C-R>=CleverTab()<CR>


