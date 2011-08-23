"  __  __ _
" |  \/  (_)___  ___
" | |\/| | / __|/ __|
" | |  | | \__ \ (__
" |_|  |_|_|___/\___|
"

" Use the mouse for selection of text, and position the cursor
"set mouse=a

" Don't leave two spaces (foo.  Bar) when joining lines
set nojoinspaces

" Enable modelines
set modeline

" Show commands as you type them
set showcmd

" Source .vimrc automatically when it changes, but seems it is problematic
" if has("autocmd")
" 	autocmd bufwritepost .vimrc source $MYVIMRC
" endif

" Use specific plugins and indentation of the filetype
filetype plugin indent on


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

" Use better colors for a dark background console
set background=dark

" Highlight the opening bracket/parentheses when the closing one is written
set showmatch


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
set hls


"  _____                          _   _   _
" |  ___|__  _ __ _ __ ___   __ _| |_| |_(_)_ __   __ _
" | |_ / _ \| '__| '_ ` _ \ / _` | __| __| | '_ \ / _` |
" |  _| (_) | |  | | | | | | (_| | |_| |_| | | | | (_| |
" |_|  \___/|_|  |_| |_| |_|\__,_|\__|\__|_|_| |_|\__, |
"                                                 |___/

" textwidth: break line when maximum line length is reached (use 0 to disable)
"set tw=80

" wrapmargin: similar to textwidth, but based on the columns number
"set wm=80

" linebreak: display long lines as if it were broken, but don't insert EOL
"set lbr

" breakat: which caracter can cause a break
"set brk

" showbreak: show this string when displaying a broken line
"set sbr=--->

" columns
"set co=85


"  _____     _
" |_   _|_ _| |__  ___
"   | |/ _` | '_ \/ __|
"   | | (_| | |_) \__ \
"   |_|\__,_|_.__/|___/
"

" tabstop: change how many spaces _looks_ a tab
set ts=4

" shiftwidth: Number of spaces to use for each step of (auto)indent.
set sw=4

" Changes tabs with spaces (*beware* when you edit Makefiles)
"set expandtab

" noautoindent: don't autoindent text, cause it's annoying when pasting text
set smartindent


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
set listchars=tab:»-,trail:·,extends:>,precedes:<,

" Get rid of the automatic folding in debian changelogs of vim 7
set nofoldenable


"  _  __                 _
" | |/ /___ _   _    ___| |__   __ _ _ __   __ _  ___  ___
" | ' // _ \ | | |  / __| '_ \ / _` | '_ \ / _` |/ _ \/ __|
" | . \  __/ |_| | | (__| | | | (_| | | | | (_| |  __/\__ \
" |_|\_\___|\__, |  \___|_| |_|\__,_|_| |_|\__, |\___||___/
"           |___/                          |___/

" Press the space key (which is easier to press) to colon
nmap <space> :

" Map the backspace to delete, like in insert mode
"nmap <BS> x

" Map the CTRL-F (unused in insert mode) to the omnicompletion one
imap <C-f> <C-x><C-o>


"   ____                      _      _   _
"  / ___|___  _ __ ___  _ __ | | ___| |_(_) ___  _ __
" | |   / _ \| '_ ` _ \| '_ \| |/ _ \ __| |/ _ \| '_ \
" | |__| (_) | | | | | | |_) | |  __/ |_| | (_) | | | |
"  \____\___/|_| |_| |_| .__/|_|\___|\__|_|\___/|_| |_|
"                      |_|

" Complete longest common string, then each full match
set wildmode=longest,full

" Behaviour of completion 'popup'
set completeopt=menuone,longest,preview

"" Note: This should be unnecessary with the supertab plugin, but...
" Insert <Tab> or use omni completion if the cursor is after a keyword character
function MyTabOrComplete()
let col = col('.')-1
if !col || getline('.')[col-1] !~ '\k'
	return "\<tab>"
	else
		return "\<C-x>\<C-o>"
	endif
endfunction
" Map the <Tab> to the function that will activate the completion
inoremap <Tab> <C-R>=MyTabOrComplete()<CR>

" function! CleverTab()
" if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
"    return "\<Tab>"
" else
" return "\<C-N>"
" endif
" endfunction
" inoremap <Tab> <C-R>=CleverTab()<CR>


