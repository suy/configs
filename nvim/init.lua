--------------------------------------------------------------------------------
-- ┏━┓┏━┓┏━╸╻  ╻ ╻╺┳┓┏━╸
-- ┣━┛┣┳┛┣╸ ┃  ┃ ┃ ┃┃┣╸
-- ╹  ╹┗╸┗━╸┗━╸┗━┛╺┻┛┗━╸
--------------------------------------------------------------------- Prelude --

-- I call "prelude" anything that has to be done early in the configuration
-- because is a dependency of something that comes later.
--
-- An easy example are the leader keys: global variables that need to be defined
-- first to be the "prefix" of some mappings. If it gets changed later, the
-- mappings would have to be redone!
--
-- A more complex one is detecting if a certain tool is installed, so the editor
-- can enable some features conditionally. Likewise with detecting the OS,
-- external settings (keybard, monitor related), etc.

-- Start the random seed, just in case is not initialized properly natively.
math.randomseed(os.time())

-- Set the leader variables early, so they can be reliably used in mappings.
vim.g.mapleader = ','
vim.g.maplocalleader = '_'

-- TODO: The new loader caches compiled Lua modules for faster startup. Still
-- marked as unstable/experimental in the docs, so disabled for now.
-- vim.loader.enable()

-- A global variable reserved as a sort of convenience API for some of the
-- configuration, like when setting repeatable mappings in `init-mappings.lua`.
Init = {}

-- Whether to load plugins or not. Decide early to taking alternative paths.
Init.plugins = vim.fn.has('win32') == 1 or vim.loop.getuid() ~= 0

-- Autocommand group for things in my config.
Init.autocmd_group = vim.api.nvim_create_augroup('Init', { clear = true })

-- A simple helper for the simple cases of repeating something without a motion.
-- Note the `g@l`: the `l` is the hardcoded motion for the `g@` operator.
-- See: https://www.vikasraj.dev/blog/vim-dot-repeat
-- And: https://www.reddit.com/r/neovim/comments/wkqkzf/adding_dotrepeat_to_plugins/
-- The first link provides the full solution, the second the `g@l` trick.
Init.make_repeatable = function(from, function_name, function_body)
    Init[function_name] = function(motion)
        if motion == nil then
            vim.o.operatorfunc = 'v:lua.Init.' .. function_name
            return 'g@l'
        end
        function_body()
    end
    vim.keymap.set('n', from, Init[function_name], { expr = true })
end


--------------------------------------------------------------------------------
-- ┏━╸┏━┓┏━┓┏┳┓┏━┓╺┳╸╺┳╸╻┏┓╻┏━╸
-- ┣╸ ┃ ┃┣┳┛┃┃┃┣━┫ ┃  ┃ ┃┃┗┫┃╺┓
-- ╹  ┗━┛╹┗╸╹ ╹╹ ╹ ╹  ╹ ╹╹ ╹┗━┛
------------------------------------------------------------------ Formatting --

-- tw: Break lines (with new lines) when this maximum line length is reached.
vim.opt.textwidth = 80
-- Wrap long lines *visually* across multiple screen lines (no new lines added).
vim.opt.wrap = true
-- lbr: Break wrapped lines at specific characters (like spaces), not at
-- the last character that fits the window. See 'breakat' for which ones.
vim.opt.linebreak = true
-- sbr: String shown at the start of visually-wrapped lines.
vim.opt.showbreak = '➥'
-- bri, briopt: Indent visually-wrapped lines so they stand out a bit better.
vim.opt.breakindent = true
vim.opt.breakindentopt = 'sbr'
-- TODO: review another day if I want to fiddle with this more. This below is
-- what I used to have, and MiniMax has `list:-1`, which is intriguing.
--vim.opt.breakindentopt = 'shift:-' .. vim.fn.strdisplaywidth(vim.o.showbreak)
-- fo: Formatting options. Options are described in fo-table. The 'a' option is
-- for automatic formatting, and while it seemed interesting when I first tried
-- it, I've found it's plain wrong for all files. Try to think which filetypes
-- should use it by default (if any), and add the option conditionally. Also,
-- review the mapping that I used to use more often for toggling the 'a' option.
--vim.opt.formatoptions:append('a')
-- The 'j' in 'fo' causes removal of comment leader when joining lines.
-- TODO: review what MiniMax has, to see if there is some new option to test.
-- TODO: review 'formatlistpat' as well.
-- fo: Format options. See 'fo-table' for the details of what this affects.
vim.opt.formatoptions:append('j')
-- js: Don't leave two spaces between sentences (foo.  Bar) when joining lines.
-- vim.opt.joinspaces = false -- Already the default.

-----
-- Clarifications. Options which can be confusing, and I'm actively avoiding.
-----
-- co: this will set the amount of columns that are considered to exist in the
-- console. You normally don't set this, it comes from the width of the
-- terminal where the editor is working on.
-- This is just a note to self, a reminder, of which option is the one to use
-- when opening a text, written by others, with huge lines, in an editor at full
-- console width.
--vim.opt.columns=90
-- wm: break lines when only 'wrapmargin' columns are left. Ignored if tw is set,
-- which is the proper one to use, since 'wm' would make line formatting
-- dependent on the size of the window.
--vim.opt.wrapmargin = 5


--------------------------------------------------------------------------------
-- ╺┳╸┏━┓┏┓ ┏━┓
--  ┃ ┣━┫┣┻┓┗━┓
--  ╹ ╹ ╹┗━┛┗━┛
------------------------------------------------------------------------ Tabs --

-- ts: Set how many spaces _looks_ a tab.
vim.opt.tabstop = 4
-- sw: Number of spaces to use for each step of (auto)indent.
-- Usually you set it to the tabstop, unless you want to mix spaces and tabs.
vim.opt.shiftwidth = 4
-- sts: Makes the backspace more consistent with the tab in insert mode
-- if you set the shiftwidth and the softtabstop the same value
vim.opt.softtabstop = 4
-- et: Changes tabs with spaces. Problematic with, e.g. Makefiles, so overriden
-- there through ftplugin/makefile.vim. Or use vim-sleuth.
vim.opt.expandtab = true
-- sta: Make <Tab> and <BS> behave according to 'shiftwidth'.
-- TODO: Review the whole settings, and take into account this from the docs:
--     In leading whitespace, this has the same effect as setting
--     'softtabstop' to the value of 'shiftwidth'.
--     NOTE: in most cases, using 'softtabstop' is a better option.  Have a
--     look at section |30.5| of the user guide for detailed
--     explanations on how Vim works with tabs and spaces.
vim.opt.smarttab = true
-- When you asked vimgor on #vim (old IRC) about smartindent, you got this:
--     'smartindent' is an obsolete option for C-like syntax. It has been
--     replaced with 'cindent', and setting 'cindent' also overrides
--     'smartindent'. Vim has indentation support for many languages
--     out-of-the-box, and setting 'smartindent' (or 'cindent', for that matter)
--     in your .vimrc might interfere with this. Use 'filetype plugin indent on'
--     and be happy.
-- That said, 'autoindent' is always safe to set.
-- TODO: Review this. All of the above makes me want to reconsider it all again.
vim.opt.autoindent = true
-- sr: Use multiples of 'shiftwidth' when using the operators '>' and '<'.
vim.opt.shiftround = true


--------------------------------------------------------------------------------
-- ┏━┓┏━╸┏━┓┏━┓┏━╸╻ ╻╻┏┓╻┏━╸
-- ┗━┓┣╸ ┣━┫┣┳┛┃  ┣━┫┃┃┗┫┃╺┓
-- ┗━┛┗━╸╹ ╹╹┗╸┗━╸╹ ╹╹╹ ╹┗━┛
------------------------------------------------------------------- Searching --

-- ic, scs: Ignores the case, unless search contains mixed case, like `/fooBar`.
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- is: Start the search, and preview where the cursor would move as you type.
vim.opt.incsearch = true
-- hls: Highlight search results, but not on startup, or config reloads.
vim.opt.hlsearch = true
vim.cmd.nohlsearch()
-- gd: Use global matching in regexes (override adding `/g` back to the search).
vim.opt.gdefault = true
-- fdo: Don't open folds when searching for a match.
vim.opt.foldopen:remove('search')


--------------------------------------------------------------------------------
-- ┏━╸╺┳┓╻╺┳╸╻┏┓╻┏━╸
-- ┣╸  ┃┃┃ ┃ ┃┃┗┫┃╺┓
-- ┗━╸╺┻┛╹ ╹ ╹╹ ╹┗━┛
--------------------------------------------------------------------- Editing --

-- ve: Allow the cursor to move one character past the end of the line. This
-- allows inserting blank lines between others in normal mode using <CR>.
vim.opt.virtualedit = {'onemore', 'block'}
-- bs: Allow backspace to delete and be more useful.
-- vim.opt.backspace = 'indent,eol,start' -- Already the default.
-- sm: Briefly jump to the matching bracket when one is inserted.
vim.opt.showmatch = true
-- hid: Allow buffers to be hidden (e.g. keep modified buffers in background).
-- vim.opt.hidden = true -- Already the default.
-- ml: Enable reading modelines.
-- vim.opt.modeline = true -- Already the default (except root).


--------------------------------------------------------------------------------
-- ┏━╸┏━┓┏┳┓┏━┓╻  ┏━╸╺┳╸╻┏━┓┏┓╻
-- ┃  ┃ ┃┃┃┃┣━┛┃  ┣╸  ┃ ┃┃ ┃┃┗┫
-- ┗━╸┗━┛╹ ╹╹  ┗━╸┗━╸ ╹ ╹┗━┛╹ ╹
------------------------------------------------------------------ Completion --

-- ph: The maximum number of entries in the to show in the pop up menu.
vim.opt.pumheight = 15
-- wmnu: Activate completion in the command line, via 'wildchar' (`<Tab>`).
-- vim.opt.wildmenu = true -- Already the default.

-- Only change the command line options if no plugins are loaded, as
-- mini.cmdline will change the defaults to what's best for its usage.
-- Complete longest common string, then each full match. Always displays a list.
if not Init.plugins then
    vim.opt.wildmode = {'list:longest', 'list:full'}
end

-- TODO: figure out a solution/workaround. Why not case-insensitive always?
-- wic: Ignore case in the command line (files and directories only).
vim.opt.wildignorecase = true

-- wig: Patterns to completely ignore in file name completion.
vim.opt.wildignore:append({
    '*.pdf', '*.png', '*.jpg', '*.jpeg', '*.ttf', '*.otf', '*.wav', '*.mp3', '*.ogg'
})

-- su: Patterns with a lower priority in completion.
vim.opt.suffixes:append({'.asc', '.cfg'})

-- Behaviour of completion in insert mode (`:h ins-completion`).
vim.opt.completeopt = {'menuone', 'longest'}


--------------------------------------------------------------------------------
-- ┏━┓┏━┓┏━┓┏━╸┏━┓┏━┓┏━┓┏┓╻┏━╸┏━╸
-- ┣━┫┣━┛┣━┛┣╸ ┣━┫┣┳┛┣━┫┃┗┫┃  ┣╸
-- ╹ ╹╹  ╹  ┗━╸╹ ╹╹┗╸╹ ╹╹ ╹┗━╸┗━╸
------------------------------------------------------------------ Appearance --

-- nu: Show the line number of the cursor line.
vim.opt.number = true
-- rnu: Show line numbers relative to the cursor line.
vim.opt.relativenumber = true
-- cul: Highlight the line where the cursor is.
vim.opt.cursorline = true
-- cc: Use a colored column to mark the textwidh+1 column.
vim.opt.colorcolumn = { '+1' } -- Accepts a list (+1, +21, etc.).
-- list: Display special characters in special ways, to make them more obvious.
vim.opt.list = true
vim.opt.listchars = {
    tab = '⇥ ', trail = '␣',
    -- multispace = '1234567890', -- TODO: I need to play with this... So fun.
    multispace = '␣',
    lead = ' ', -- Overrides multispace so indentation doesn't look silly.
    precedes = '❬', extends = '❭',
    nbsp = '⨝',
}
-- Characters used as a filler for some UI elements, like folds, splits, etc.
-- TODO: review. I don't think I see them properly.
vim.opt.fillchars = {
    vert = '┃',
    fold = '═',
    diff = '╱', -- Deleted lines in diff mode.
    -- Only used with `foldcolumn > 0`.
    foldopen = '▾',
    foldclose = '▸',
    foldsep = '│',
}
-- The default border of floating windows. Anything is much better than empty.
vim.opt.winborder = 'rounded'
-- so: Keep at least this many screen lines above/below the cursor.
vim.opt.scrolloff = 3
-- vb: Use a visual indication for the "bell" instead of the system beep.
vim.opt.visualbell = true
-- TODO: I used to have this enabled for GVim, as it improved the redraw there,
-- and made possible having `cursorline` enabled at sane speed.
-- vim.opt.lazyredraw = true
-- fen: Enable folds by default. Can be swiftly toggled with `zi` ("invert").
-- vim.opt.foldenable = true -- Already the default.
-- fdm: Sets the default folding behaviour. Overridden to `expr` per window
-- based on file type, e.g. to switch to tree-sitter when possible.
vim.opt.foldmethod = 'syntax'
-- fdls: Folds with a higher level than this start closed when opening a buffer.
vim.opt.foldlevelstart = 4
-- fdc: Width of the column that displays folding information. It's perhaps more
-- useful for debugging than for regular use, so disabled by default.
-- vim.opt.foldcolumn = 0 -- Already the default.


--------------------------------------------------------------------------------
-- ┏┳┓╻┏━┓┏━╸
-- ┃┃┃┃┗━┓┃
-- ╹ ╹╹┗━┛┗━╸
------------------------------------------------------------------------ Misc --

-- Allow loading configuration files in the current directory. I've read the
-- help, and this seems worth the risk/power tradeoff, as files need to be
-- trusted first, and I only expect to ever run simple files from myself.
vim.opt.exrc = true
-- sps: Limit suggestions when spell checking with z=.
vim.opt.spellsuggest = 'best,15'
-- smc: Reduce syntax highlight to a reasonable column, for performance.
vim.opt.synmaxcol=250
-- ut: Make swap file saves and CursorHold trigger faster (default is 4000).
vim.opt.updatetime = 1000
-- tm: Time between keystrokes for mapped key sequences (default is 1000).
vim.opt.timeoutlen = 1600
-- ar: Don't auto-open files changed outside, even in unchanged buffers. Better
-- the editor nagging you and being in control than some unfortunate mistake.
vim.opt.autoread = false
-- udf: Save the undo history in a file, so that it persists across restarts.
vim.opt.undofile = true
-- ul. Double the number of undo levels.
vim.opt.undolevels = 2000
-- Change diff options. Careful don't overwrite the defaults, which include
-- `internal`, which is essential in Windows, as there is no `diff.exe` anymore.
vim.opt.diffopt:append('vertical')

-- Sync the unnamed register with the selection register (`:h clipboard-x11`).
-- However, do so only on Linux, where there is a different concept of clipboard
-- and selection. Clobbering the selection seems fine to me, but doing so with
-- the clipboard is too much. Additionally, skip setting the clipboard option on
-- remote sessions, as it would slow things down.
if vim.fn.has('linux') == 1 and vim.env.SSH_TTY == nil then
    vim.opt.clipboard = 'unnamed'
end

-- Jump to the last cursor position when reopening a file.
vim.api.nvim_create_autocmd('BufReadPost', {
    group = Init.autocmd_group,
    callback = function()
        local mark = vim.fn.line([['"]])
        if mark > 1 and mark <= vim.fn.line('$') then
            vim.cmd([[normal! g`"]])
        end
    end,
})

-- For bash's `fc` (fix command): disable text wrapping in the temporary file.
vim.api.nvim_create_autocmd('BufEnter', {
    group = Init.autocmd_group,
    pattern = '/tmp/bash-fc.*',
    callback = function()
        if vim.bo.filetype == 'sh' then
            vim.opt_local.textwidth = 0
        end
    end,
})

-- Detect external file changes when the window gains focus.
vim.api.nvim_create_autocmd('FocusGained', {
    group = Init.autocmd_group,
    command = 'checktime',
})

-- Briefly highlight yanked text. See `:h vim.highlight.on_yank` for more.
vim.api.nvim_create_autocmd('TextYankPost', {
    group = Init.autocmd_group,
    callback = function() vim.hl.on_yank({ timeout = 350 }) end,
})

-- Change some options in order to make inactive windows less noticeable
-- compared to the active ones. Note that this is not "perfect" in that if some
-- options were manually disabled from their defaults, might be enabled back
-- when re-entering the window. I don't care about this myself.
local function dim_window(inactive, window)
    window = window or 0
    vim.wo[window].cursorline = not inactive
    vim.wo[window].winhighlight = inactive and 'LineNr:LineNrInactive' or ''
    -- Get the buffer number now, but refresh later. Otherwise the window might
    -- not be in sync with what we want, due to how `WinLeave` works.
    local buffer = vim.api.nvim_win_get_buf(window)
    vim.schedule(function()
        require('ibl').refresh(buffer)
    end)
end
vim.api.nvim_create_autocmd({'WinEnter', 'BufEnter'}, {
    group = Init.autocmd_group,
    callback = function() dim_window(false) end,
})
vim.api.nvim_create_autocmd('WinLeave', {
    group = Init.autocmd_group,
    callback = function() dim_window(true) end,
})
vim.api.nvim_create_autocmd('VimEnter', {
    group = Init.autocmd_group,
    callback = function()
        local current = vim.api.nvim_get_current_win()
        for _, window in ipairs(vim.api.nvim_list_wins()) do
            if window ~= current then
                dim_window(true, window)
            end
        end
    end,
})


--------------------------------------------------------------------------------
-- ╺┳╸┏━┓┏━╸┏━╸┏━┓╻╺┳╸╺┳╸┏━╸┏━┓
--  ┃ ┣┳┛┣╸ ┣╸ ┗━┓┃ ┃  ┃ ┣╸ ┣┳┛
--  ╹ ╹┗╸┗━╸┗━╸┗━┛╹ ╹  ╹ ┗━╸╹┗╸
------------------------------------------------------------------ Treesitter --

-- This is more documentation for the future that actual configuration.
-- Activating Treesitter is already done automatically in Neovim in some file
-- types. But, if I add more TS plugins, I might need to activate them if they
-- don't do the same. Also, this documents the workaround for some file types
-- that still require the legacy syntax for some features. See:
-- https://github.com/neovim/neovim/pull/32965
vim.api.nvim_create_autocmd('FileType', {
    group = Init.autocmd_group,
    callback = function(options)
        -- See |FileType| and |nvim_create_autocmd|: the new `filetype` is
        -- `<amatch>`, which in the callback is passed as `match`.
        local ok = pcall(vim.treesitter.start, options.buf)
        if ok then
            -- Use Treesitter for folding only when fold queries exist for this
            -- language. Not all parsers ship a folds.scm query (e.g. vimdoc and
            -- markdown don't), so check before switching from the default
            -- 'syntax' foldmethod.
            local parser = vim.treesitter.get_parser(options.buf)
            if parser then
                if vim.treesitter.query.get(parser:lang(), 'folds') then
                    local winid = vim.fn.bufwinid(options.buf)
                    if winid ~= -1 then
                        vim.wo[winid].foldmethod = 'expr'
                        vim.wo[winid].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    end
                end
            end
        end
        -- If a plugin relies on regex syntax highlighting (e.g. vimtex, some
        -- markdown plugins), re-enable it for that specific filetype only.
        local filetype = options.match
        if filetype == 'latex' then
            vim.bo[options.buf].syntax = 'ON'
        end
    end,
})


--------------------------------------------------------------------------------
-- ┏┳┓┏━┓┏━┓┏━┓╻┏┓╻┏━╸┏━┓
-- ┃┃┃┣━┫┣━┛┣━┛┃┃┗┫┃╺┓┗━┓
-- ╹ ╹╹ ╹╹  ╹  ╹╹ ╹┗━┛┗━┛
-------------------------------------------------------------------- Mappings --

-- Note to self: possible key candidates to be remapped as handy operators,
-- since I rarely use them: M, Q, ^Q, ^P, ^N.

-- Close fugitive windows with 'q'. Recursive so it triggers fugitive's 'gq'.
vim.api.nvim_create_autocmd('FileType', {
    group = Init.autocmd_group,
    pattern = { 'fugitive', 'fugitiveblame', 'git' },
    callback = function(args)
        vim.keymap.set('n', 'q', 'gq', { buffer = args.buf, remap = true })
    end,
})

Init.make_repeatable('dp', 'diff_put', function()
    -- The `pcall` is a workaround for some issues with the change tracking with
    -- LSP. I think it has to do with the fact that I disable LSP for fugitive
    -- buffers. See the issues/PR (and perhaps others):
    -- https://github.com/neovim/neovim/issues/36452
    -- https://github.com/neovim/neovim/issues/37814
    -- https://github.com/neovim/neovim/pull/40285
    -- TODO: try at a later time if the refactors recently done land in a stable
    -- version that I use, and remove the workaround.
    pcall(vim.cmd, 'normal! dp')
end)

Init.make_repeatable('do', 'diff_obtain', function()
    vim.cmd('normal! do')
end)

-- NOTE: Making window resizing repeatable is... a stretch. It helps me
-- compensate the modes I lost when vim-submode stopped working, but it's an
-- experiment so far. I should look how to do this with Mini.
--[[
-- NOTE (2nd): kept this for now, for reference, but I'm gonna try to use
-- last-next-previous for this.
Init.make_repeatable('<C-w><', 'win_left', function()
    vim.cmd.wincmd '<'
end)

Init.make_repeatable('<C-w>>', 'win_right', function()
    vim.cmd.wincmd '>'
end)

Init.make_repeatable('<C-w>-', 'win_down', function()
    vim.cmd.wincmd '-'
end)

Init.make_repeatable('<C-w>+', 'win_up', function()
    vim.cmd.wincmd '+'
end)
--]]

vim.keymap.set({'n', 'x'}, 'gy', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n',        'gp', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set('n',        'gP', '"+P', { desc = 'Paste from system clipboard' })


-- Like & (repeat last substitute), but repeating the same flags.
vim.keymap.set({'n', 'x'}, '&', ':&&<CR>', { remap = false })

-- Don't do dangerous things.
vim.keymap.set('n', 'ZQ', '<Nop>', { remap = false })
vim.keymap.set('n', 'ZZ', '<Nop>', { remap = false })

-- Swap ' and ` so the useful jump-to-row+column mark is on the easier key.
vim.keymap.set('n', "'", '`', { remap = false })
vim.keymap.set('n', '`', "'", { remap = false })

-- Dot command in visual mode (good suggestion, nelstrom).
vim.keymap.set('x', '.', ':normal .<CR>', { remap = false })

-- <Space> enters command-line mode (easier to press than ':').
vim.keymap.set({'n', 'x'}, '<Space>', ':', { remap = true })

-- A little trick for opening "local" folds. First close all folds in the
-- context, then open them recursively. The net result is opening folds not in
-- the cursor, but in the same context (e.g., a function).
vim.keymap.set('n', 'z<Space>', 'zczO', { remap = true })

-- Command-line: <C-J> opens the command-line window (like <C-F>).
vim.keymap.set('c', '<C-J>', '<C-F>', { remap = false })

-- Allow Return to do something useful in Normal mode. Check for `buftype`, and
-- don't try to insert in any buffer that has it set, as those are special.
vim.keymap.set('n', '<CR>',
    function()
        if vim.bo.buftype == '' then -- Normal buffer. See `:h 'buftype'`.
            vim.cmd('execute "normal! i\\<CR>"')
        else
            vim.cmd('execute "normal! \\<CR>"')
        end
    end,
    { silent = true }
)

-- Allow easy deletion in normal mode with Backspace.
vim.keymap.set('n', '<Backspace>',
    function()
        if vim.fn.col('.') == 1 then
            vim.cmd('normal! kJl')
        else
            vim.cmd('normal! X')
        end
    end,
    { silent = true }
)

-- TODO: <Tab> in normal mode doesn't do anything (it can be distinguished from
-- CTRL-I nowadays). What about using it for switching buffer, with <S-Tab> for
-- going back to the previous? Or navigating through windows? Note that `:h
-- <Tab>` points out at some limitations.


--
-- Leader mappings which can be roughly seen as "new functionality".
--

-- Switch to the previous (alternate) buffer.
vim.keymap.set('n', '<Leader>bb', ':b #<CR>', { remap = true })

-- List buffers, and immediately insert the buffer switching command.
vim.keymap.set('n', '<Leader>b<Space>', ':ls<CR>:b<Space>', { remap = true })
vim.keymap.set('n', '<Leader>B<Space>', ':ls!<CR>:b<Space>', { remap = true })

-- Update diff highlighting.
vim.keymap.set('n', '<Leader>du', ':diffupdate<CR>', { remap = true })

-- TODO: I have not been using this since long. Review if keeping it or drop it.
-- Toggle automatic formatting ('a' flag in formatoptions).
vim.keymap.set('n', '<Leader>fa',
    function()
        local fo = vim.bo.formatoptions
        if fo:match('a') then
            vim.bo.formatoptions = fo:gsub('a', '')
        else
            vim.bo.formatoptions = fo .. 'a'
        end
        print('Format options: ' .. vim.bo.formatoptions)
    end,
    { silent = true }
)

-- Swap the unnamed register (the default one) with the clipboard.
vim.keymap.set('n', '<Leader>k', function()
    local temp = vim.fn.getreg('+')
    vim.fn.setreg('+', vim.fn.getreg('"'))
    vim.fn.setreg('"', temp)
end, { desc = 'Swap unnamed register with the clipboard' })

-- <Leader>l (for 'label') as a synonym for the tag jump shortcut.
vim.keymap.set('n', '<Leader>l', '<C-]>', { remap = true })

-- <Leader>m: select recently modified text (changed, yanked, or pasted).
vim.keymap.set('n', '<Leader>m', function()
    return '`[' .. string.sub(vim.fn.getregtype(), 1, 1) .. '`]'
end, { expr = true, remap = false })

-- TODO: this perhaps should be deprecated entirely, or rethought how to combine
-- the best of the remapped `gp`, `gP`, etc. I need the selection register too.
vim.keymap.set('n', '<Leader>p', function()
    vim.notify('"+p == gp', vim.log.levels.INFO)
    vim.cmd('normal! "+p')
end)
vim.keymap.set('n', '<Leader>P', function()
    vim.cmd('normal! "*p')
end)

-- Convenient shortcut for closing a buffer without closing a window. Switch to
-- another buffer (the alternate one if listed, otherwise the next), then close.
vim.keymap.set('n', '<Leader>q', function()
    if vim.fn.buflisted(vim.fn.expand('#')) ~= 0 then
        vim.cmd('b #')
    else
        vim.cmd('bnext')
    end
    vim.cmd('bdelete #')
end, { silent = true })

-- Substitute word under the cursor (normal) or selection (visual).
-- FIXME: escape regex characters (e.g. selecting /foo/bar and the slashes are there).
vim.keymap.set('n', '<Leader>S', ':%s/\\<<C-R><C-w>\\>//c<Left><Left>', { remap = false })
vim.keymap.set('x', '<Leader>S', 'y:%s/<C-R>"//c<Left><Left>', { remap = false })

-- <Leader>w: window management prefix (synonym for <C-w>).
vim.keymap.set({'n', 'x'}, '<Leader>w', '<C-w>', { remap = true })

-- TODO: it's been ages since I gogle the cursor column. For the cursor line, I
-- should be using unimpaired, mini.bracketed or whatever.
-- <Leader><Leader>cc/cl: toggle cursor column/line.
vim.keymap.set('n', '<Leader><Leader>cc', ':set cursorcolumn!<CR>', { silent = true, remap = true })
vim.keymap.set('n', '<Leader><Leader>cl', ':set cursorline!<CR>', { silent = true, remap = true })


-- TODO: review this. Is it really needed? Very unlikely with mini.surround.
-- Text objects for square brackets: ir = inside [], ar = around ].
-- vim.keymap.set('o', 'ir', 'i[', { remap = false })
-- vim.keymap.set('o', 'ar', 'a]', { remap = false })

--
-- Insert mode.
--

-- Press 'jj' or 'kk' in insert mode to go back to normal mode.
vim.keymap.set('i', 'jj', '<Esc>', { remap = false })
vim.keymap.set('i', 'kk', '<Esc>', { remap = false })

-- Quickly append some punctuation symbols at the end of the line. Very common
-- when one ends up inside a function call that the typical completion or
-- auto-pairs has filled with lots of characters to the right, so first one
-- needs to jump to the end to type what was wanted. This is more comfortable.
for _, key in pairs({';', ':', ',', '.', '!', '?'}) do
    vim.keymap.set('i', ',' .. key, function()
        local prefix = vim.fn.pumvisible() == 1 and '<C-y>' or ''
        return prefix .. '<C-o>A' .. key
    end, { expr = true })
end

-- Ease typing [] and {} on a Spanish keyboard.
vim.keymap.set('i', '<C-x>r', '[]<Left>', { remap = false })
vim.keymap.set('i', '<C-x>b', '{}<Left>', { remap = false })
vim.keymap.set('i', '<C-x>m', '{{}}<Left><Left>', { remap = false })

-- Insert mode abbreviations for usual typos.
vim.cmd('iabbrev tODO TODO')
vim.cmd('iabbrev fIXME FIXME')
vim.cmd('iabbrev hte the')

--
-- Lang map and related.
--

-- This should change the behaviour of Spanish keys in normal/visual/etc. mode.
-- However, it has been buggy in my experience, as it only worked on native Vim
-- actions with brackets (e.g., [c or ]p), but not on sequences mapped by the
-- user, like the ones provided by unimpaired.vim.
-- http://groups.google.com/group/vim_use/browse_thread/thread/bda0c89bcdb330d1
-- Will try to research about it, because it might be a bug to report.
vim.opt.langmap = 'ñ[,ç],Ñ{,Ç}'

-- The langmap above doesn't work in all situations, but adding the next
-- mappings to the mix makes the Ñ/Ç keys do what I want, so keep both for now.
vim.keymap.set('', 'ñ', '[', { remap = true })
vim.keymap.set('', 'Ñ', '{', { remap = true })
vim.keymap.set('', 'ç', ']', { remap = true })
vim.keymap.set('', 'Ç', '}', { remap = true })

--
-- Terminal.
--

-- A bunch of alternatives for the terminal escaping, given that the default is
-- pretty difficult to type. Some are pure experiments, to see what sticks.
vim.keymap.set('t', ',,', '<C-\\><C-n>', { remap = false })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-v><Esc>', '<Esc>')
-- <C-q> sends XON, almost never needed in modern terminals.
vim.keymap.set('t', '<C-q>', '<C-\\><C-n>')


--------------------------------------------------------------------------------
-- ┏━╸┏━┓┏┳┓┏┳┓┏━┓┏┓╻╺┳┓┏━┓
-- ┃  ┃ ┃┃┃┃┃┃┃┣━┫┃┗┫ ┃┃┗━┓
-- ┗━╸┗━┛╹ ╹╹ ╹╹ ╹╹ ╹╺┻┛┗━┛
-------------------------------------------------------------------- Commands --

-- Diff the current buffer against the file on disk. Adapted from the help docs
-- (see `:h :DiffOrig`). To help recover file contents when a recovery is made.
vim.api.nvim_create_user_command('DiffOrig', function()
    vim.cmd('vertical new')
    vim.bo.buftype = 'nofile'
    vim.cmd('read ++edit #')
    vim.cmd('0d_')
    vim.cmd('diffthis')
    vim.cmd('wincmd p')
    vim.cmd('diffthis')
end, {})

-- Remove trailing whitespace (with confirmation), preserving cursor and search.
vim.api.nvim_create_user_command('RemoveTrailingWhiteSpace', function()
    local search = vim.fn.getreg('/')
    local line = vim.fn.line('.')
    local col = vim.fn.col('.')
    -- Match spaces, tabs and carriage return (Windows' new line in Unix files).
    vim.cmd([[%s/[ \t\r]\+$//ce]])
    vim.fn.setreg('/', search)
    vim.fn.cursor(line, col)
end, {})


--------------------------------------------------------------------------------
-- ┏━┓╺┳╸╻ ╻┏━╸┏━┓
-- ┃ ┃ ┃ ┣━┫┣╸ ┣┳┛
-- ┗━┛ ╹ ╹ ╹┗━╸╹┗╸
----------------------------------------------------------------------- Other --

-- Plugin loading goes in separate files for convenience and because then as
-- root the loading of them can be isolated. Minor security improvement.
if Init.plugins then
    require 'init-setup-plugins'
    require 'init-lsp'
else
    -- Fall back to a colorscheme which doesn't require a plugin and looks good.
    -- Try "unokai" first, or fall back to "desert", which is in older versions.
    if not pcall(vim.cmd.colorscheme, 'unokai') then
        vim.cmd.colorscheme('desert')
    end
end

