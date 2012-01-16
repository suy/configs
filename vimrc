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
let g:pathogen_disabled = ['javascript-indentation', 'space', 'syntastic', 'web-indent', 'powerline']

" Disable css-color in the console, because it slows down too much.
if !has('gui_running')
	call add(g:pathogen_disabled, 'css-color')
endif

" Initialize all the plugins.
call pathogen#infect()
call pathogen#helptags() " equivalent to :Helptags
" TODO: check if the plugin is properly loaded (for some environments where I
" might copy the vimrc, but not the whole runtime). I need something like
" if exists('pathogen#infect')

" Use plugins that are included with Vim 7
runtime macros/matchit.vim
runtime macros/justify.vim

" Auto delete files created by fugitive
autocmd BufReadPost fugitive:* set bufhidden=delete

" Configuration for UltiSnips. Use CTRL+S (unused in insert mode) to invoke a
" snippet. This way, your <tab> can be free for other completion actions.
let g:UltiSnipsExpandTrigger="<C-S>"
let g:UltiSnipsListSnippets="<C-Q>"
" These other two are the defaults. Left here as a reminder.
" let g:UltiSnipsJumpForwardTrigger="<C-J>"
" let g:UltiSnipsJumpBackwardTrigger="<C-K>"
" Since I don't like the default snippets much, use my own directory only.
let g:UltiSnipsSnippetDirectories=["ultisnippets"]


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

" Clear other autocommands, to avoid defining them multiple times on reload
autocmd!

" Use the mouse for selection of text, and position the cursor
"set mouse=a

" Don't leave two spaces between two sentences (foo.  Bar) when joining lines
set nojoinspaces

" Enable modelines
set modeline

" Show commands as you type them
set showcmd

" Source .vimrc automatically when it changes
if has("autocmd")
	autocmd! bufwritepost *vimrc source $MYVIMRC
endif

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

" Atomatically create and load views of files in entering or exiting them
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

" Jump to the last position when reopening a file.
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
	\ | exe "normal! g'\"" | endif
endif


"  _   _ _       _     _ _       _     _   _
" | | | (_) __ _| |__ | (_) __ _| |__ | |_(_)_ __   __ _
" | |_| | |/ _` | '_ \| | |/ _` | '_ \| __| | '_ \ / _` |
" |  _  | | (_| | | | | | | (_| | | | | |_| | | | | (_| |
" |_| |_|_|\__, |_| |_|_|_|\__, |_| |_|\__|_|_| |_|\__, |
"          |___/           |___/                   |___/

" Activates sintax highlighting
syntax on

" Force a specific type of sintax highlighting
"set syntax=php

" Highlight the opening bracket/parentheses when the closing one is written
set showmatch

" How to aggresively hightlight trailing whitespace
"match Error /\v +$/


"
"    / \   _ __  _ __   ___  __ _ _ __ __ _ _ __   ___ ___
"   / _ \ | '_ \| '_ \ / _ \/ _` | '__/ _` | '_ \ / __/ _ \
"  / ___ \| |_) | |_) |  __/ (_| | | | (_| | | | | (_|  __/
" /_/   \_\ .__/| .__/ \___|\__,_|_|  \__,_|_| |_|\___\___|
"         |_|   |_|

" number: show line number
"set nu

" Set the characters for statusline (& non current stl), vsplit, fold & diff.
" set fillchars=stl:_,stlnc:\ ,vert:┃,fold:═,diff:·
" TODO: some characters don't work with some colorschemes because use bold, etc.
set fillchars=stl:/,stlnc:\ ,vert:┃,fold:=,diff:·

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

" Clear it first to start fresh each invocation
set statusline=
" Buffer name with 2 minimum width
set statusline+=%2.n
" Full path, but truncate the statusbar here if it's too long
set statusline+=\ %<%F
" a space, User1 color, modified flag, restore color
set statusline+=\ %1*%m%*
" Git information
set statusline+=\ %{fugitive#statusline()}
" Syntastic information
"set statusline+=\ %{SyntasticStatuslineFlag()}
" Push everything else to the right
set statusline+=\ %=
" Modified, RO, help, preview, quickfix
set statusline+=\ %R%H%W%q
" Filetype in User1 color
set statusline+=\ %1*%y%*
" Ruler
set statusline+=\ %(%l,%c%V%)
" Percentage
set statusline+=\ %P

" Some configuration options for solarized that have to be applied previously
let g:solarized_termcolors='256'
let g:solarized_italic='0'
let g:solarized_contrast='normal'
" Don't hightlight the listchars too much...
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
	set guioptions-=Tm " Get rid of the toolbar and the menu.
	set guioptions+=LlRrb " Get rid of scrollbars...
	set guioptions-=LlRrb " ... for some reason rerquires 2 lines (???)
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

" Ignore case in searches...
set ignorecase

" ...unless you specify it explicitly (like /PaTTern)
set smartcase

" Incremental search, while you type
"set incsearch

" Highlight search results
set hlsearch

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
inoremap lll <ESC>
inoremap hhh <ESC>

" Allow enter key in normal mode to insert lines
nnoremap <CR> i<CR><ESC>
" Unmap this shortcut for the command window (cmdwin)
autocmd CmdwinEnter * nunmap <CR>
autocmd CmdwinLeave * nnoremap <CR> i<CR><ESC>

" Allow the backspace to delete in normal mode too
nmap <BS> X

" Make backspace insert an 'undo break' before deleting.
"inoremap <BS> <C-G>u<BS>

" Make the tab do something a little bit more useful in normal mode
map <tab> %

" Press the space key (which is easier to press) to colon
nmap <space> :
vmap <space> :

" Change the single quote and the grave to be the opposite of each other
nnoremap ' `
nnoremap ` '

" Map the CTRL-F (almost unused in insert mode) to the omnicompletion one
imap <C-f> <C-x><C-o>

" Change the 'leader' key to something more easy to press
let mapleader = ","

" Make window management a little bit more easy: map all the C-W <foobar> to
" <leader>w<foobar>
map <leader>w <C-w>

" Convenient shortcut for closing a buffer without closing a window
nmap <leader>q :b #<CR>:bdelete #<CR>

" Easily toggle invisible characters (listchars). This is very important for:
" - Copying with the mouse to another application (if you don't disable them,
"   will be added to the clipboard, which doesn't make sense).
" - Making linebreak work, because is a documented limitation that doesn't
"   work with :set list. :-(
nmap <leader>l :set list!<CR>

" Easily hide the highlighting of the search
nmap <leader>h :nohlsearch<CR>

" Toggle paste on/off when you want to copy in insert mode (e.g. from other app)
map <leader>p :set invpaste<CR>

" Toggle the use of cursor column and cursor line
map <leader><leader>cc :set cursorcolumn!<CR>
map <leader><leader>cl :set cursorline!<CR>

" Switch to the previous buffer
map <leader>bb :b #<CR>

" Switch on and off spellchecking
map <leader>s :set spell!<CR>

" Activate diff mode and update the diff highlighting.
map <leader>dt :diffthis<CR>
map <leader>du :diffupdate<CR>

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

" This should change the behaviour of spanish keys in normal/visual/etc. mode.
" However, it has been buggy in my experience, as it only worked on native Vim
" actions with brackets (e.g., [c or ]p), but not on sequences mapped by the
" user, like the ones provided by unimpaired.vim.
" http://groups.google.com/group/vim_use/browse_thread/thread/bda0c89bcdb330d1
" Will try to research about it, because it might be a bug to report.
set langmap=ñ[,ç],Ñ{,Ç}

" Experimental: use spanish keys in normal mode with plain old mappings.
" nmap ` [
" nmap + ]
" map ´ {
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
" 	" Check if the cursor is at the beggining of line or after whitespace
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


