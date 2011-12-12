"  ____  _             _
" |  _ \| |_   _  __ _(_)_ __  ___
" | |_) | | | | |/ _` | | '_ \/ __|
" |  __/| | |_| | (_| | | | | \__ \
" |_|   |_|\__,_|\__, |_|_| |_|___/
"                |___/

" Pathogen loads all sorts of plugins in subdirectories under ~/.vim/bundle/.
" You can disable a plugin by adding a trailing '~' to the bundle
" subdirectory, or conditionally adding its name to the disabling variable
" if exists('*pathogen#infect')
" let g:pathogen_disabled = ['foo', 'bar']
" if has('win32')
" 	call add(g:pathogen_disabled, 'baz')
" endif
let g:pathogen_disabled = []
if !has('gui_running')
	call add(g:pathogen_disabled, 'vim-css-color')
endif
call pathogen#infect()
call pathogen#helptags() " equivalent to :Helptags
" endif

" Use plugins that are included with Vim 7
runtime macros/matchit.vim
runtime macros/justify.vim

" Auto delete files created by fugitive
autocmd BufReadPost fugitive:* set bufhidden=delete


"  _____                          _   _   _
" |  ___|__  _ __ _ __ ___   __ _| |_| |_(_)_ __   __ _
" | |_ / _ \| '__| '_ ` _ \ / _` | __| __| | '_ \ / _` |
" |  _| (_) | |  | | | | | | (_| | |_| |_| | | | | (_| |
" |_|  \___/|_|  |_| |_| |_|\__,_|\__|\__|_|_| |_|\__, |
"                                                 |___/

" textwidth: break line when maximum line length is reached (use 0 to disable)
"set tw=80

" wrapmargin: breaks line when only n columns are left. Ignored if tw is set
"set wm=5

" linebreak: display long lines as if it were broken, but don't insert EOL
set lbr

" breakat: which caracter can cause a break
"set brk

" showbreak: show this string at the beggining of a broken line
set sbr=➥


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
set autochdir

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
augroup vimrc
	au!
	autocmd BufWinLeave *
		\   if expand('%') != '' && &buftype !~ 'nofile'
		\|      mkview!
		\|  endif
	autocmd BufWinEnter *
		\   if expand('%') != '' && &buftype !~ 'nofile'
		\|      silent loadview
		\|  endif
augroup END

" Save a lot more history
set history=200

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

" Show some chars to denote clearly where there is a tab or trailing space
set list
set listchars=tab:⇥\ ,trail:·,extends:❬,precedes:❬

" Set the characters for statusline (& non current stl), vsplit, fold & diff
set fillchars=stl:_,stlnc:\ ,vert:┃,fold:═,diff:·
set fillchars=stl:/,stlnc:\ ,vert:┃,fold:=,diff:·

" Get rid of the automatic folding in debian changelogs of vim 7
" set nofoldenable

" colorcolumn: Use a colored column to mark the textwidh+1 column
set cc=+1

" foldcolumn: Use 1 character wide column to display folding information
set fdc=1

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
	endif
	set guioptions-=T " Get rid of the toolbar
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

" Change the 'leader' key to something more easy to press
let mapleader = ","

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

" Make window management a little bit more easy:
" map all the C-W <foobar> to <leader>w<foobar>
map <leader>ws <C-w>s
map <leader>wv <C-w>v
map <leader>wn <C-w>n
map <leader>wq <C-w>q
map <leader>wo <C-w>o
map <leader>wp <C-w>p
map <leader>wj <C-w>j
map <leader>wk <C-w>k
map <leader>wl <C-w>l
map <leader>wh <C-w>h
map <leader>w= <C-w>=
map <leader>w_ <C-w>_
map <leader>w<bar> <C-w><bar>
map <leader>w+ <C-w>+
map <leader>w- <C-w>-
map <leader>w> <C-w>>
map <leader>w<lt> <C-w><lt>

" Convenient shortcut for closing a buffer without closing a window
nmap <leader>q :bprevious<CR>:bdelete #<CR>

" Make the tab do something a little bit more useful in normal mode
noremap <tab> %

" Press the space key (which is easier to press) to colon
nmap <space> :
vmap <space> :

" Change the single quote and the grave to be the opposite of each other
nnoremap ' `
nnoremap ` '

" Map the CTRL-F (almost unused in insert mode) to the omnicompletion one
imap <C-f> <C-x><C-o>

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

" Change the behaviour of spanish keys in normal/visual/etc. mode
set langmap=ñ[,+],ç},Ñ{

" Experimental: use spanish keys in normal mode
" map ` [
" map + ]
" map ´ {
" map ç }
" map ñ [
" map Ñ {


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

function! CleverTab()
	" Check if the cursor is at the beggining of line or after whitespace
	if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
	   return "\<Tab>"
	else
		" Use omnifunc if available
		if &omnifunc != ''
			return "\<C-X>\<C-O>"
		" Otherwise use the dictionary completion
		elseif &dictionary != ''
			return "\<C-K>"
		else
			return "\<C-P>"
		endif
	endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>


