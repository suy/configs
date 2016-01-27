"  ____  _             _         _       _ _
" |  _ \| |_   _  __ _(_)_ __   (_)_ __ (_) |_
" | |_) | | | | |/ _` | | '_ \  | | '_ \| | __|
" |  __/| | |_| | (_| | | | | | | | | | | | |_
" |_|   |_|\__,_|\__, |_|_| |_| |_|_| |_|_|\__|
"                |___/
" {{{

" Safety net, since sometimes I screwed locale configuration and this file
" contains some characters outside of ASCII. Also, for whatever reason latin1 is
" the default unless overriden by LANG (but not on Windows). Go figure.
set encoding=utf-8

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

" Kept as a submodule to track them, but not used in the configuration.
let g:pathogen_blacklist = ['space', 'gist', 'vital', 'marching', 'reunions']

" Additionally, disable the plugin code of endwise, since I want it available
" in the runtimepath, but not loading any code. This way I can check the source
" and the documentation with :Vedit, etc.
let g:loaded_endwise=1

" Disable css-color in the console, because it slows down too much.
if !has('gui_running')
	call s:disable('css-color')
endif

" TODO: This is just an ugly workaround because I don't want to dig more in what
" the terminal apps on OS X do differently to suck.
if !has('gui_running') && has('mac')
	call s:disable('indent-line', 'airline')
endif

" Disable UltiSnips if needed to avoid the startup warning.
if !has('python') && !has('python3') && !has('python/dyn') && !has('python3/dyn')
	\ && v:version < 704
	call s:disable('ultisnips')
endif

" Neocomplete requires some features.
if v:version < 703 || (v:version == 703 && !has('patch885')) || !has('lua')
	call s:disable('neocomplete')
endif

" Temporary tweaks. Just use neocomplete and clang_complete, disable others.
if has('win32')
	call s:disable('clang_complete')
endif


" Initialize all the plugins by calling pathogen, but only if it exists, since
" I might be using this vimrc but without all the runtime files on '~/.vim'.
if exists('*pathogen#infect')
	execute pathogen#infect()
	" Equivalent to :Helptags (which generates the help tags for all plugins),
	" but better not to run it at startup/reload, since it is too slow.
	" call pathogen#helptags()
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

" Set the map leader early, so we can use it with plugin mappings.
let mapleader = ","

" All all at once some binary paths on Windows, like git.exe, gcc.exe, etc. For
" simpler plugin configuration like fugitive, signify, etc.
if has('win32')
	let $PATH .= ';' . 'C:/Program Files (x86)/Git/bin'
	let $PATH .= ';' . 'C:/Qt/Tools/mingw491_32/bin'
endif

" Enable syntax folding for QML filetype.
let g:qml_fold = 1

" The most important signify option and I overlooked it for ages. *sigh*
let g:signify_vcs_list = ['git']

" Several small variable settings for plugins that don't require much. " {{{
" Vimfiler.
let g:loaded_netrwPlugin = 1
let g:vimfiler_as_default_explorer = 1
autocmd FileType vimfiler nnoremap <buffer> <space> :

" Echodoc.
let g:echodoc_enable_at_startup = 1

" The operator-replace plugin doesn't map any key, and I only use gR for replace.
map R <Plug>(operator-replace)

" Enable markdown folding.
let g:markdown_folding=1

" vim-grepper
nmap <leader>g <plug>(Grepper)
xmap <leader>g <plug>(Grepper)
cmap <leader>g <plug>(GrepperNext)
nmap gs        <plug>(GrepperMotion)
xmap gs        <plug>(GrepperMotion)

" Startify features, and arrangement of sections.
let g:startify_list_order = ['bookmarks', 'dir', 'files']
let g:startify_list_order = ['bookmarks', 'repositories', 'dir', 'files']
let g:startify_change_to_vcs_root = 1
let g:startify_skiplist = [
	\ 'COMMIT_EDITMSG',
	\ '.git/index',
	\ '^/tmp',
	\ 'bundle/.*/doc',
	\ ]
let g:startify_custom_indices = map(range(5,100), 'string(v:val)')
if executable('fortune')
	let g:startify_custom_header =
	\ map(split(system('fortune'), '\n'), '"   ". v:val') + ['','']
endif
let g:startify_repositories = [ '~/personal/configs']
autocmd User Startified nnoremap <silent> <buffer> r :<C-u>Startify<Return>

" Indent line.
let g:indentLine_char = '│'
let g:indentLine_char = '┃'
let g:indentLine_char = '┊'
let g:indentLine_char = '⎸'
let g:indentLine_first_char = '┃'
let g:indentLine_fileTypeExclude = ['help']

" Gist.vim
let g:gist_detect_filetype = 1   " Detect from file name.
let g:gist_show_privates = 1     " Show secret gists on listsing.
let g:gist_post_private = 1      " Post secretly by default.
let g:gist_get_multiplefile = 1

" Gista.
let g:gista#directory = s:data_dir . '/gista/'

" }}}

" UltiSnips. "{{{
" Use <C-S>/<C-Q> (unused in insert mode, and in the GUI only) for snippet
" shortcuts. This way <tab> is a bit more free for fine grained actions.
if has("gui_running")
	let g:UltiSnipsExpandTrigger="<C-S>"
	let g:UltiSnipsListSnippets="<C-Q>"
else
	let g:UltiSnipsExpandTrigger=",s"
	let g:UltiSnipsListSnippets=",q"
endif
" These other two are the defaults. Left here as a reminder.
" let g:UltiSnipsJumpForwardTrigger="<C-J>"
" let g:UltiSnipsJumpBackwardTrigger="<C-K>"
" For the snippets themselves to work.
let g:UltiSnipsSnippetDirectories=["ultisnippets"]
" The user snippet definition directory, for the :UltiSnipsEdit command.
if exists('*pathogen#infect')
	let g:UltiSnipsSnippetsDir=pathogen#split(&rtp)[0] . "/ultisnippets"
endif
" }}}



" Unite. "{{{
" Unite preferences. "{{{
let g:unite_source_file_mru_time_format=''
let g:unite_source_file_mru_filename_format = ''
let g:unite_enable_start_insert=1
let g:unite_enable_short_source_names=1
let g:unite_force_overwrite_statusline=0
let g:unite_source_history_yank_enable=1
let g:unite_data_directory=expand('~/.local/share/vim/unite')
let g:unite_quick_match_table={
			\ 'a': 0,  'b': 1,  'c': 2,  'd': 3,  'e': 4,  'f': 5,  'g': 6,
			\ 'h': 7,  'i': 8,  'j': 9,  'k': 10, 'l': 11, 'm': 12,
			\ 'n': 13, 'o': 14, 'p': 15, 'q': 16, 'r': 17,
			\}
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts =
	\ '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
	\  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
	let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
	let g:unite_source_grep_command='ack-grep'
	let g:unite_source_grep_default_opts='--no-heading --no-color -a -H'
	let g:unite_source_grep_recursive_opt=''
endif

"}}}

" Invocation trick. Use: [count]<leader>u
nmap <silent> <leader>u  :<C-u>execute get([
	\ "Unite -no-split -buffer-name=files buffer file_rec/async:! file/new",
	\ "Unite menu:unite",
	\ "Unite -no-split -buffer-name=files buffer",
	\ "Unite -no-split -buffer-name=files file_mru",
	\ "Unite history/command",
	\ "Unite outline",
	\ "Unite output:message",
	\ "Unite grep -keep-focus -no-quit",
	\ ], v:count)<Return>

" Experiment. :-)
nmap <silent> cd :<C-u>Unite -buffer-name=browse -no-split directory<Return>

" Customize default sources (but check if Unite is there).
if exists(':Unite')
	call unite#custom_default_action('buffer', 'goto')
	call unite#custom_default_action('directory', 'cd')
	" call unite#filters#matcher_default#use(['matcher_fuzzy'])
	call unite#custom_source('file,file_mru,buffer,file_rec,file_rec/async',
			\ 'matchers', 'matcher_fuzzy')
	call unite#custom_source('buffer,file,file_mru,file_rec,file_rec/async',
			\ 'sorters', 'sorter_rank')
	call unite#custom_source('file_rec/async,file_rec', 'max_candidates', 0)
	autocmd FileType unite call s:unite_my_settings()
	function! s:unite_my_settings() "{{{
		imap <buffer> <C-y>     <Plug>(unite_narrowing_path)
		nmap <buffer> <C-y>     <Plug>(unite_narrowing_path)
	endfunction "}}}
endif

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
			\ 'grep': 'Unite grep -keep-focus -no-quit',
			\ 'mapping': 'Unite mapping',
			\ 'runtimepath': 'Unite runtimepath',
			\ 'outline': 'Unite outline',
			\ 'git': 'Unite menu:git',
			\ 'shell-like': 'Unite menu:shell',
			\ }
function g:unite_source_menu_menus.unite.map(key, value) dict
	let l:max = max(map(keys(self.candidates), 'len(v:val)'))
	return {
				\ 'abbr': unite#util#truncate(a:key, l:max) .'   -- '. a:value,
				\ 'word': a:key,
				\ 'action__command': a:value,
				\ 'kind': 'command',
				\ }
endfunction

let g:unite_source_menu_menus.shell = {'description': 'Shell-like'}
let g:unite_source_menu_menus.shell.command_candidates = [
			\   ['ruby', 'VimShellInteractive ruby'],
			\   ['irb', 'VimShellInteractive irb'],
			\   ['re.pl', 'VimShellInteractive re.pl'],
			\   ['python', 'VimShellInteractive python'],
			\ ]

let g:unite_source_menu_menus.git = {'description': 'Git commands'}
let g:unite_source_menu_menus.git.command_candidates = [
			\ ['git diff', 'Git! diff'],
			\ ['git status', 'Gstatus'],
			\ ['git show', 'Git! show'],
			\ ['master..trunk', 'Glog master..trunk --'],
			\ ['gitk', 'Gitv'],
			\ ]
"}}}
"}}}

" JunkFile "{{{
let g:junkfile#directory=expand('~/personal/misc')
" Ideas: remove the default command, and put one/some of my own. Submit a pull
" request to improve the docs and made it more customizable. For example,
" JunkfileOpen lets you choose the name of the file, but is always put in %Y/%m
" directory. Another possibility is using plain Unite to do it, since the
" sources provided are just fine.
"}}}

" Airline " {{{
" TODO: Detect if powerline symbols are available at runtime.
" Depends on the fonts-powerline package, so Linux only (and disabled for now).
if !has('win32') && !has('mac') && 0
	let g:airline_powerline_fonts=1
else
	let g:airline_left_sep = '▶'
	let g:airline_right_sep = '◀'
	let g:airline_symbols = {}
	let g:airline_symbols.linenr = '¶ '
endif
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='understated'
" }}}

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

runtime autoload/smartinput_endwise.vim
if exists('*smartinput_endwise#define_default_rules')
	call smartinput_endwise#define_default_rules()
endif
"}}}

" CtrlP. " {{{
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
" }}}

" neocomplete and clang_complete {{{
let g:clang_snippets=1
let g:clang_snippets_engine="ultisnips"
let g:clang_close_preview=1
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
" TODO: this freaking sucks.
" For backported libclang
if filereadable('/usr/lib/libclang.so')
	let g:clang_library_path='/usr/lib/'
elseif isdirectory('/usr/lib/llvm-3.4/lib')
	let g:clang_library_path='/usr/lib/llvm-3.4/lib'
elseif isdirectory('/usr/lib/llvm-3.6/lib')
	let g:clang_library_path='/usr/lib/x86_64-linux-gnu/libclang-3.6.so.1'
elseif isdirectory('/Applications/Xcode.app/')
	let g:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libclang.dylib'
endif
let g:clang_make_default_keymappings=0
autocmd FileType cpp nnoremap <buffer> <silent> <C-l> :call g:ClangGotoDeclaration()<CR><Esc>

" For snowdrop, use the same path.
let g:snowdrop#libclang_directory ='/usr/lib/x86_64-linux-gnu'
let g:snowdrop#libclang_file='libclang-3.4.so.1'
let g:snowdrop#debug#enable=1

let g:neocomplete#enable_auto_select = 0

let g:neocomplete#auto_completion_start_length=4
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
" Seems to be a pattern of buffer names that should be ignored.
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionaries for filetypes.
" let g:neocomplete#sources#dictionary#dictionaries = {
" 			\ 'default' : '',
" 			TODO: change vimshell 'home dir'
" 			\ 'vimshell' : $HOME.'/.vimshell_hist',
" 			\ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
" inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
"   return neocomplete#smart_close_popup() . "\<CR>"
"   " For no inserting <CR> key.
"   "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
" endfunction
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y>  neocomplete#close_popup()
" inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"


" Enable omni completion.
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.

" Patterns for omnicompletion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'

" *force* patterns for omnicompletion.
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.c =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.cpp =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" For rubycomplete.
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplete#force_omni_input_patterns.ruby =
\ '[^. *\t]\.\w*\|\h\w*::'

" " TODO: This were available on neocomplcache, but are needed?
" let g:neocomplcache_enable_camel_case_completion = 1
" let g:neocomplcache_enable_underbar_completion = 1

"}}}

" Check C++ headers too.
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_config_file = '.clang_complete'
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_wq=0
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_less_checkers = ['lessc']
let g:syntastic_mode_map =	{ 'mode': 'active',
							\ 'passive_filetypes': ['xml'] }
let g:syntastic_quiet_messages = {
			\ "regex": 'pragma once in main file' }
if executable('asciidoctor')
	let g:syntastic_asciidoc_asciidoc_exec='asciidoctor'
elseif isdirectory($HOME . '/local/gems')
	let g:syntastic_asciidoc_asciidoc_exec=$HOME . '/local/gems/bin/asciidoctor'
endif

" Setup for the lastnextprevious plugin.
" FIXME: Something is wrong here in Vim 7.2.
nmap <silent> + <Plug>lastnextprevious_forward
nmap <silent> - <Plug>lastnextprevious_backward
if stridx(&runtimepath, "lastnextprevious") != -1
	let g:lastnextprevious#last = 'changelist'
	call extend(g:lastnextprevious#table,
	\ { 'tabcycle': {'b': 'gT', 'f': 'gt'} ,
	\   'quickfix': {'b': '[q', 'f': ']q'} ,
	\   'loclist':  {'b': '[l', 'f': ']l'} }
	\)
endif
" FIXME: gives an error when resourcing vimrc (wihout using silent). Think about
" an API maybe? There is also the problem of the mappings not being removed.
" Is important that I use it, since otherwise the feature might not work and I
" might not notice it.
silent! call remove(g:lastnextprevious#table, 'undolist')

" Local configuration file (from the localrc plugin).
let g:localrc_filename=".localrc.vim"

" Word in word text object.
let g:textobj_wiw_default_key_mappings_prefix='\'

" Choosewin
let g:choosewin_overlay_enable = 1
nmap <leader>W <Plug>(choosewin)
nmap <leader><C-w> <Plug>(choosewin-swap)

" Experiment: swap the contents of the default register and the clipboard.
nnoremap <silent> <Leader>k :let temp=@+ <BAR> let @+=@" <BAR> let @"=temp <BAR> unlet temp<Return>
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
" Display long lines by showing them in multiple visual lines, not by scrolling.
" Only affects how the lines look. See 'showbreak' for the visual hint.
set wrap

" linebreak: break wrapped lines at specific characters (like spaces) to make
" text more readable, not simply at the last one that fits. Only makes sense
" when 'wrap' is active, and unfortunately is disabled if 'list' is set, which
" is a Vim limitation. See 'unimpaired' for a map for toggling 'list'.
set lbr

" breakat: fine tune which character can cause a soft break (the one caused by
" linebreak). Vim defaults are appropriate in general.
" set brk

" showbreak: show this string at the beginning of a line that is soft broken.
if $USER != 'root'
	set sbr=➥➥➥
	" If breakindent is available, enable it, but align the first real character
	" of the wrapped line at the level of the previous line by the length of the
	" cosmetic characters of 'shobreak'. It sucks compared to Kate, which does
	" this easily and does it right, but is the best that we've got...
	if exists("+breakindent")
		set breakindent
		let &breakindentopt= 'shift:-' . strdisplaywidth(&sbr)
	endif
endif

" Add 'j' (remove commentstring when joining) to format options.
if (v:version == 703 && has('patch550')) || v:version > 703 | set fo+=j | endif

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

" Changes tabs with spaces. Problematic with, e.g. Makefiles, so overriden there
" through ftplugin/makefile.vim. Or use vim-sleuth.
set expandtab

" Make <Tab> and <BS> behave according to 'shiftwidth'.
set smarttab

" If you ask vimgor on #vim about smartindent, you get this:
"   'smartindent' is an obsolete option for C-like syntax. It has been replaced
"   with 'cindent', and setting 'cindent' also overrides 'smartindent'. Vim has
"   indentation support for many languages out-of-the-box, and setting
"   'smartindent' (or 'cindent', for that matter) in your .vimrc might interfere
"   with this. Use 'filetype plugin indent on' and be happy.
" That said, 'autoindent' is always safe to set.
set autoindent

" Use multiples of 'shiftwidth' when using the operators '>' and '<'.
set shiftround

" }}}


"  __  __ _
" |  \/  (_)___  ___
" | |\/| | / __|/ __|
" | |  | | \__ \ (__
" |_|  |_|_|___/\___|
"
" {{{

" Add 'mac' fileformat, because there are still people as silly as v2msoft.com.
set fileformats+=mac

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
		" autocmd BufWritePost *vimrc source $MYVIMRC

		" Set nopaste once insert mode is left, just in case.
		autocmd InsertLeave * set nopaste
	augroup END
endif

" For echodoc.
set cmdheight=2

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

" Set encoding to utf-8 for systems that don't have it by default
set encoding=utf-8

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
	let &undodir = s:data_dir . '/undo,.,/var/tmp,/tmp'
endif

" Double the number of undo levels.
set undolevels=2000

" TODO: Consider something to avoid undofiles for useless stuff.
" au BufWritePre /tmp/* setlocal noundofile

" Save the swap files on a different directory.
let &directory = s:data_dir . '/swap,.,/var/tmp,/tmp'

" Save a lot more history
set history=200

" Better to be noisy than find something unexpected.
set noautoread
set noautowrite

" Set Blowfish for encryption method, but only on Vim >=7.3.
if has('cryptv') && v:version >= 703 | set cryptmethod=blowfish | endif

" Save and restore g:UPPERCASE variables in viminfo.
if !empty(&viminfo)
  set viminfo^=!
endif

" Some diff options.
set diffopt=filler,vertical


"  _   _ _       _     _ _       _     _   _
" | | | (_) __ _| |__ | (_) __ _| |__ | |_(_)_ __   __ _
" | |_| | |/ _` | '_ \| | |/ _` | '_ \| __| | '_ \ / _` |
" |  _  | | (_| | | | | | | (_| | | | | |_| | | | | (_| |
" |_| |_|_|\__, |_| |_|_|_|\__, |_| |_|\__|_|_| |_|\__, |
"          |___/           |___/                   |___/

" Activates syntax highlighting, but keeping current color settings. From the
" documentation: "If you want Vim to overrule your settings with the
" defaults, use ':syntax on'".
syntax enable

" Highlight the opening bracket/parentheses when the closing one is written
set showmatch

" Use the Error colors for trailing whitespace.
" match Error /\v\s+$/
" Alternative idea: highlight bogus whitespace mixtures.
match Error /\v\t+ +\t+/


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
" Also, disable it in the console since it seems problematic with screen or the
" colorscheme, or whatever.
if has("gui_running")
set cursorline
endif

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

" Only use the default statusline setting if Airline is not present.
if !exists('*airline#parts#define_function')
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
let g:solarized_visibility='normal'
" ...except the trailing whitespace
let g:solarized_hitrail='1'

" Set some things depending on the OS and the presence of a GUI
if has("gui_running")
	if !has('win32') && !has('mac')
		set guifont=DejaVu\ Sans\ Mono\ 9
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
	" Solarized thingies.
	if stridx(&runtimepath, "colorscheme-solarized") != -1
		colorscheme solarized
		" Some solarized changes: listchars and matched parents.
		highlight SpecialKey guifg=#094757
		highlight MatchParen gui=reverse guibg=NONE
		highlight SignColumn guifg=#839496 guibg=#002b36
	else
		colorscheme desert
	endif
else
	try
		colorscheme molokai
		let g:airline_theme='powerlineish'
		" Make the listchars darker
		hi SpecialKey ctermfg=240
		" Indent guides look terrible for now...
		let g:indent_guides_enable_on_vim_startup=0
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

" Start the search, and apparently move the cursor as you type.
set incsearch

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

" Note to self: possible key candidates to be remapped as handy operators,
" since I rarely use them: K, H, L, M, Q, ^Q, ^P, ^N.

" Make Y consistent with C and D.  See :help Y.
nnoremap Y y$

" Safe net with <C-u>: add an undo-break (see :help i_CTRL-G_u).
inoremap <C-u> <C-g>u<C-u>

" Like & (repeat last substitute), but repeating the same flags.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

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
	\ else<BAR>bnext<BAR>endif<BAR>
	\ bdelete #<CR>
	" \ if buflisted(expand('#'))<BAR>bdelete #<BAR>endif<CR>

" Clear and redraw the screen. Usually is C-L, but is mapped to something else.
nmap <leader>r :redraw!<CR>

" Easily toggle invisible characters (listchars). This is very important for:
" - Copying with the mouse to another application (if you don't disable them,
"   will be added to the clipboard, which doesn't make sense).
" - Making linebreak work, because is a documented limitation that doesn't
"   work with :set list. :-(
nmap <silent> <leader>l :<C-u>echoerr 'Use unimpaired: col'<Return>

" Easily hide the highlighting of the search
nmap <leader>h :nohlsearch<CR>

" Common paste operations.
nmap <leader>p "+p
nmap <leader>P "*p

" Unimpaired used to have `nnoremap <silent> yP :call <SID>setup_paste()<CR>i`
" and a longer family of mappings. Luckily, `<Plug>unimpairedPaste` exposes that
" otherwise private function.
nmap yp <Plug>unimpairedPastea
nmap yP <Plug>unimpairedPastei

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

" Neovim's terminal
if has('nvim')
	tnoremap <Esc> <C-\><C-n>
	tnoremap jj <C-\><C-n>
	tnoremap kk <C-\><C-n>
endif

" vim:foldmethod=marker:noet:ts=4:sw=4:
