"  ____  _             _         _       _ _
" |  _ \| |_   _  __ _(_)_ __   (_)_ __ (_) |_
" | |_) | | | | |/ _` | | '_ \  | | '_ \| | __|
" |  __/| | |_| | (_| | | | | | | | | | | | |_
" |_|   |_|\__,_|\__, |_|_| |_| |_|_| |_|_|\__|
"                |___/
" {{{

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
		\ 'supertab',
		\ 'vim-powerline',
		\ 'space']

" Disable css-color in the console, because it slows down too much.
if !has('gui_running')
	call add(g:pathogen_disabled, 'css-color')
endif

" Initialize all the plugins by calling pathogen, but only if it exists, since
" I might be using this vimrc but without all the runtime files on '~/.vim'.
if exists('*pathogen#infect')
	execute pathogen#infect()
	" Equivalent to :Helptags (which generates the help tags for all plugins),
	" but better not to run it at startup/reload, since it is too slow.
	" call pathogen#helptags()
endif

" Load early vim-sensible, so it can be overriden if needed.
runtime! plugin/sensible.vim

" }}}


"  ____  _             _                  _
" |  _ \| |_   _  __ _(_)_ __    ___  ___| |_ _   _ _ __
" | |_) | | | | |/ _` | | '_ \  / __|/ _ \ __| | | | '_ \
" |  __/| | |_| | (_| | | | | | \__ \  __/ |_| |_| | |_) |
" |_|   |_|\__,_|\__, |_|_| |_| |___/\___|\__|\__,_| .__/
"                |___/                             |_|
" {{{

" Set the map leader early, so we can use it with plugin mappings.
let mapleader = ","

" Unite. "{{{
" Unite preferences. "{{{
let g:unite_source_file_mru_time_format=''
let g:unite_source_file_mru_filename_format = ''
let g:unite_enable_start_insert=1
let g:unite_enable_short_source_names=1
let g:unite_force_overwrite_statusline=0
let g:unite_source_history_yank_enable=1
let g:unite_data_directory=expand('~/.local/share/vim/unite')
"}}}

" Invocation trick. Use: [count]<leader>u
nmap <silent> <leader>u  :<C-u>execute get([
	\ "Unite -no-split -buffer-name=files buffer file_rec/async file_mru file/new",
	\ "Unite -no-split -buffer-name=files buffer",
	\ "Unite -no-split -buffer-name=files file_mru",
	\ "Unite outline",
	\ "Unite output:message",
	\ ], v:count)<Return>

" Customize default sources.
call unite#custom_default_action('buffer', 'goto')
" call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom_source('file,file_mru,buffer,file_rec,file_rec/async',
		\ 'matchers', 'matcher_fuzzy')
call unite#custom_source('buffer,file,file_mru,file_rec,file_rec/async',
		\ 'sorters', 'sorter_rank')
call unite#custom_source('file_rec/async,file_rec', 'max_candidates', 0)

" Unite menu definitions. "{{{

" See: http://d.hatena.ne.jp/osyo-manga/20130225/1361794133 (useful map)
" And this for several instructions at the same time:
" http://akakyouryuu.com/blog/unite%E3%81%8B%E3%82%89vimrepress%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E3%81%BF%E3%81%9F/
if !exists("g:unite_source_menu_menus")
    let g:unite_source_menu_menus = {}
endif
" Favourite Unite commands
let g:unite_source_menu_menus.unite = {'description' : 'Unite invocations'}
let g:unite_source_menu_menus.unite.candidates = {
			\ 'mixed': 'Unite -no-split -buffer-name=files' .
				\ ' buffer file_rec/async file_mru file/new',
			\ 'commands': 'Unite history/command',
			\ 'process list': 'Unite process',
			\ 'variable': 'Unite variable',
			\ 'run': 'Unite launcher',
			\ 'yank': 'Unite history/yank',
			\ 'messages': 'Unite -log output:messages',
			\ 'jump list': 'Unite jump',
			\ 'change list': 'Unite change',
			\ 'register': 'Unite register',
			\ }
function g:unite_source_menu_menus.unite.map(key, value)
	return {
				\ 'word': a:key . ' - [' . a:value . ']',
				\ 'kind': 'command',
				\ 'action__command': a:value,
				\ 'description': a:value,
				\ } " TODO: description does nothing... fill a wish?
endfunction

let g:unite_source_menu_menus.git = {'description': 'Git commands'}
let g:unite_source_menu_menus.git.command_candidates = [
			\ ['git status', 'Gstatus'],
			\ ['git show', 'Git! show'],
			\ ['master..trunk', 'Glog master..trunk --'],
			\ ['gitk', 'Gitv'],
			\ ]
"}}}
"}}}

" JunkFile configuration. "{{{
if $USER == 'modpow'
	let g:junkfile#directory='/var/tmp/misc/misc'
else
	let g:junkfile#directory=expand('~/personal/misc')
endif
" Ideas: remove the default command, and put one/some of my own. Submit a pull
" request to improve the docs and made it more customizable. For example,
" JunkfileOpen lets you choose the name of the file, but is always put in %Y/%m
" directory. Another possibility is using plain Unite to do it, since the
" sources provided are just fine.
"}}}

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
" if isdirectory($HOME . "/.fonts/ttf-dejavu-powerline")
" 	let g:Powerline_symbols="fancy"
" else
" 	let g:Powerline_symbols="unicode"
" endif
" let g:Powerline_stl_path_style="short"
" let g:Powerline_theme="skwp"
" let g:Powerline_colorscheme = 'skwp'
" runtime autoload/Pl/Theme.vim
" if exists('*Pl#Theme#RemoveSegment')
" 	call Pl#Theme#RemoveSegment('fileformat')
" 	call Pl#Theme#RemoveSegment('fileencoding')
" 	call Pl#Theme#InsertSegment('lastnextprevious:static_str', 'after', 'filetype')
" endif

" Submode. "{{{
" Raise the timeout length in submodes a little bit (default is timeoutlen).
let g:submode_timeoutlen=3000

" Configuration for the submode plugin.
runtime autoload/submode.vim
if exists('*submode#map') && version > 702
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

" Smartinput. "{{{
" Smartinput customization. Rules have to be added with define_rule. But for
" rules to be triggered a mapping is needed. Since the default rules already map
" some keys to the generic function that looks for a match, one doesn't need to
" create that map. The exception is if you want to change the default behaviour
" of a key, like how is done here, where <Space>, if it doesn't expand anything
" returns a <Space> but preceded with an undo break.
runtime autoload/smartinput.vim
if exists('*smartinput#define_rule')
call smartinput#define_rule({
\	'at':       '/\%#',
\	'char':     '*',
\	'input':    '**/<Left><Left>',
\	'filetype': ['css', 'c']
\})
call smartinput#define_rule({
\	'at':       '/\*\%#\*/',
\	'char':     '<Space>',
\	'input':    '<Space><Space><Left>',
\	'filetype': ['css', 'c']
\})
call smartinput#define_rule({
\	'at':       '/\* \%# \*/',
\	'char':     '<BS>',
\	'input':    '<Del><BS>',
\	'filetype': ['css', 'c']
\})
call smartinput#define_rule({
\	'at':       '/\*\%#\*/',
\	'char':     '<BS>',
\	'input':    '<Del><Del><BS><BS>',
\	'filetype': ['css', 'c']
\})
call smartinput#map_to_trigger('i', '*', '*', '*')
call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<C-G>u<Space>')
call smartinput#map_to_trigger('i', '<Return>', '<Return>', '<C-G>u<Return>')

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
" Fix some defaults
call smartinput#define_rule({
\	'at':       '\s\%#\S',
\	'char':     '[',
\	'input':    '[',
\})
call smartinput#define_rule({
\	'at':       '\s\%#\S',
\	'char':     '(',
\	'input':    '(',
\})
endif
"}}}

" The operator-replace plugin isn't mapped to any key, and I almost don't use R.
map R <Plug>(operator-replace)

" Use a Creator-like shortcut for CtrlP plugin.
let g:ctrlp_map = '<C-k>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_user_command = {
\	'types': {
\		1: ['.git', 'cd %s && git ls-files'],
\		2: ['.hg', 'hg --cwd %s locate -I .'],
\	},
\	'fallback': 'find %s -type f'
\}
let g:ctrlp_extensions = ['mixed', 'quickfix', 'line', 'commandline', 'unicode']
let g:ctrlp_max_height = 20
let g:ctrlp_mruf_exclude = '/tmp.*\|/usr/share.*\|.*bundle.*\|.*\.git'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_by_filename = 0

" Setup for clang_complete and neocomplcache. Still much to do.
let g:clang_snippets=1
let g:clang_snippets_engine="ultisnips"
let g:clang_close_preview=1

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length=4
let g:neocomplcache_enable_smart_case = 1
" Note: possibly slow.
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1

if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplcache_force_omni_patterns.cpp =
	  \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:clang_complete_auto = 0
let g:clang_auto_select = 0

" Check C++ headers too.
let g:syntastic_cpp_check_header = 1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_wq=0
let g:syntastic_mode_map = { 'mode': 'active',
						   \ 'active_filetypes': ['cpp'],
						   \ 'passive_filetypes': ['xml'] }

" Setup for the lastnextprevious plugin.
nmap <silent> + <Plug>lastnextprevious_forward
nmap <silent> - <Plug>lastnextprevious_backward
let g:lastnextprevious#last = 'changelist'
call extend(g:lastnextprevious#table,
\ { 'tabcycle': {'b': 'gT', 'f': 'gt'} ,
\   'quickfix': {'b': '[q', 'f': ']q'} }
\)
" FIXME: gives an error when resourcing vimrc (wihout using silent). Think about
" an API maybe? There is also the problem of the mappings not being removed.
" Is important that I use it, since otherwise the feature might not work and I
" might not notice it.
silent! call remove(g:lastnextprevious#table, 'undolist')

" Local configuration file (from the localrc plugin).
let g:localrc_filename=".localrc.vim"

" }}}



"  _____                          _   _   _
" |  ___|__  _ __ _ __ ___   __ _| |_| |_(_)_ __   __ _
" | |_ / _ \| '__| '_ ` _ \ / _` | __| __| | '_ \ / _` |
" |  _| (_) | |  | | | | | | (_| | |_| |_| | | | | (_| |
" |_|  \___/|_|  |_| |_| |_|\__,_|\__|\__|_|_| |_|\__, |
"                                                 |___/
" {{{

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

" Add 'j' (remove commentstring when joining) to format options.
if v:version >= 703 && has('patch550') | set fo+=j | endif

" }}}


"  _____     _
" |_   _|_ _| |__  ___
"   | |/ _` | '_ \/ __|
"   | | (_| | |_) \__ \
"   |_|\__,_|_.__/|___/
"
" {{{

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

" TODO: autoindent, smartindent, cindent...
" }}}


"  __  __ _
" |  \/  (_)___  ___
" | |\/| | / __|/ __|
" | |  | | \__ \ (__
" |_|  |_|_|___/\___|
"
" {{{

if has("autocmd")
	augroup vimrc
		" Clear all autocommands in the group to avoid defining them multiple
		" times each time vimrc is reloaded. It has to be only once and at the
		" beginning of each augroup.
		autocmd!

		" Jump to the last position when reopening a file.
		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
		  \ | exe "normal! g`\"" | endif

		" Automatically resize window splits when the application is resized.
		autocmd VimResized * exe "normal! \<c-w>="

		" Source .vimrc automatically when it is saved.
		autocmd BufWritePost *vimrc source $MYVIMRC
		" Work around to fix Powerline colors (something clears highlighting).
		" https://github.com/Lokaltog/vim-powerline/issues/28#issuecomment-3492408
		" autocmd BufWritePost *vimrc call Pl#Load()

		" Set nopaste once insert mode is left, just in case.
		autocmd InsertLeave * set nopaste
	augroup END
endif

" Disable autoselection of the visual region to the clipboard.
set guioptions-=a
set clipboard-=autoselect

" Don't leave two spaces between two sentences (foo.  Bar) when joining lines
set nojoinspaces

" Enable modelines
set modeline

" Show commands as you type them
" set showcmd

" Use specific plugins and indentation of the filetype
filetype plugin indent on

" Use visualbell instead of the system beep
set visualbell

" Allow hidden buffers without that many prompts, but caution when using ':q!'
set hidden

" scrolloff: Make the text scroll some lines before the cursor reaches the border
set so=3

" Allow the backspace to do useful things (is not the default everywhere)
" set backspace=indent,eol,start

" Set encoding to utf-8 for systems that don't have it by default
set encoding=utf-8

" Allow more time between keystrokes for some key shortcuts
set timeoutlen=1600

" Create directories on $HOME to avoid littering stuff in the source tree.
if exists("*mkdir")
	if !isdirectory($HOME . "/.local/share/vim/undo")
		call mkdir($HOME . "/.local/share/vim/undo", "p")
	endif
	if !isdirectory($HOME . "/.local/share/vim/swap")
		call mkdir($HOME . "/.local/share/vim/swap", "p")
	endif
endif

" Save the undo history in a persistent file, not just while Vim is running.
if has('persistent_undo')
	set undofile undodir=$HOME/.local/share/vim/undo,.,/var/tmp,/tmp
endif

" Save the swap files on a different directory.
set directory=$HOME/.local/share/vim/swap,.,/var/tmp,/tmp

" Save a lot more history
set history=200

" Better to be noisy than find something unexpected.
set noautoread
set noautowrite

" Set Blowfish for encryption method, but only on Vim >=7.3.
if has('cryptv') && v:version >= 703 | set cryptmethod=blowfish | endif


"  _   _ _       _     _ _       _     _   _
" | | | (_) __ _| |__ | (_) __ _| |__ | |_(_)_ __   __ _
" | |_| | |/ _` | '_ \| | |/ _` | '_ \| __| | '_ \ / _` |
" |  _  | | (_| | | | | | | (_| | | | | |_| | | | | (_| |
" |_| |_|_|\__, |_| |_|_|_|\__, |_| |_|\__|_|_| |_|\__, |
"          |___/           |___/                   |___/

" Activates syntax highlighting
syntax on

" Highlight the opening bracket/parentheses when the closing one is written
" set showmatch

" Use the Error colors for trailing whitespace.
" match Error /\v\s+$/


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

" See the cursor line.
set relativenumber

" cul: Highlight the line in which the cursor is in. Caution, can be very slow.
" Also, disable it in the console since it seems problematic with screen or the
" colorscheme, or whatever.
if has("gui_running")
set cursorline
endif

" Show some chars to denote clearly where there is a tab or trailing space
set list
" set listchars=tab:⇥\ ,trail:·,extends:❬,precedes:❬

" colorcolumn: Use a colored column to mark the textwidh+1 column (Vim >=7.3).
if v:version >= 703
	set cc=+1
endif

" fen: enable folds by default. Can be swiftly disabled with 'zi'.
set foldenable

" fdm: sets the default folding behaviour.
set foldmethod=syntax

" fdls: the level of nested folds that will be closed initially.
set foldlevelstart=4

" foldcolumn: Use a 4 characters wide column to display folding information.
set fdc=4

" laststatus: Show the statusbar always, not only on last window
" set ls=2

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

" Only use the default statusline setting if Powerline is not present.
" if !exists('*Pl#Theme#RemoveSegment')
if 0
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
	" Syntastic information
	"set statusline+=\ %{SyntasticStatuslineFlag()}
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

" Some configuration options for solarized that have to be applied previously
let g:solarized_termcolors='256'
let g:solarized_italic='1'
let g:solarized_contrast='normal'
" Don't highlight the listchars too much...
let g:solarized_visibility='low'
" ...except the trailing whitespace
let g:solarized_hitrail='1'

" Set some things depending on the OS and the presence of a GUI
if has("gui_running")
	" At work there is a larger screen.
	if $USER == 'modpow'
		" if isdirectory($HOME . "/.fonts/ttf-dejavu-powerline")
		" 	set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
		" else
			set guifont=DejaVu\ Sans\ Mono\ 9
		" endif
	else
		" if isdirectory($HOME . "/.fonts/ttf-dejavu-powerline")
		" 	set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
		" else
			set guifont=DejaVu\ Sans\ Mono\ 10
		" endif
	endif
	set guioptions-=T " Get rid of the toolbar and the menu.
	set guioptions-=m
	set guioptions+=LlRrb " Get rid of scrollbars...
	set guioptions-=LlRrb " ... for some reason requires 2 lines (???)
	set background=dark
	runtime autoload/togglebg.vim
	if exists('*togglebg#map')
		colorscheme solarized
		" Some solarized changes: listchars and matched parents.
		highlight SpecialKey guifg=#094757
		highlight MatchParen gui=reverse guibg=NONE
	endif
else
	try
		colorscheme molokai
		" Make the listchars darker
		hi SpecialKey ctermfg=240
	catch
		colorscheme elflord
	endtry
endif

" Extra space (in pixels) between two lines (GUI only).
set linespace=2


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


" Don't do dangerous things.
nnoremap ZQ <Nop>
nnoremap ZZ <Nop>

" Make do/dp repeatable.
nnoremap <silent> dp dp:silent! call repeat#set('dp', 1)<Enter>
nnoremap <silent> do do:silent! call repeat#set('do', 1)<Enter>

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

" Map C-L (for 'label') as a synonym for for the 'tag' shortcut.
map <C-L> <C-]>

" Map the CTRL-F (almost unused in insert mode) to the omnicompletion one
"imap <C-f> <C-x><C-o>

" Mappings for the command-line.
" cnoremap <C-A> <Home>
" cnoremap <C-F> <Right>
" cnoremap <C-B> <Left>
cnoremap <C-J> <C-F>

" Quickly open the command-line CtrlP plugin.
nmap <C-q> :call ctrlp#init(ctrlp#commandline#id())<Return>

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
nmap <leader>p :set paste<CR>"+p:set nopaste<Return>

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

" Text objects for 'rectangular' and 'angular' brackets (surround plugin-style).
onoremap ir i[
onoremap ar a]
" onoremap ia i<
" onoremap aa i>

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

" Complete longest common string, then each full match
set wildmode=list:longest,list:full

" Behaviour of completion 'popup'
set completeopt=menuone,longest

" suffixes: Patterns with a lower priority in completion.
set su+=.asc,.cfg

" wildignore: Patterns to completely ignore when completing.
set wig+=*.pdf,*.png,*.jpg,*.jpeg,*.ttf,*.otf,*.qpf2,*.wav,*.mp3,*.ogg

" Ignore case in the command line.
if version > 702 | set wildignorecase | endif

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
inoremap <Tab> <C-R>=<SID>CleverTab()<CR>
inoremap <S-Tab> <C-p>

" vim: set foldmethod=marker:
