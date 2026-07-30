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

-- Autocommand group for things in my config.
Init.autocmd_group = vim.api.nvim_create_augroup('Init', { clear = true })

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
-- allows inserting blank lines between others in normal mode using <Return>.
vim.opt.virtualedit = 'onemore'
-- bs: Allow backspace to delete and be more useful.
-- vim.opt.backspace = 'indent,eol,start' -- Already the default.
-- sm: Briefly jump to the matching bracket when one is inserted.
vim.opt.showmatch = true
-- hid: Allow buffers to be hidden (e.g. keep modified buffers in background).
-- vim.opt.hidden = true -- Already the default.
-- ml: Enable reading modelines.
-- vim.opt.modeline = true -- Already the default (except root).


--------------------------------------------------------------------------------
-- ┏┳┓╻┏━┓┏━╸
-- ┃┃┃┃┗━┓┃
-- ╹ ╹╹┗━┛┗━╸
------------------------------------------------------------------------ Misc --

-- sps: Limit suggestions when spell checking with z=.
vim.opt.spellsuggest = 'best,15'
-- ut: Make swap file saves and CursorHold trigger faster (default is 4000).
vim.opt.updatetime = 1000
-- tm: Time between keystrokes for mapped key sequences (default is 1000).
vim.opt.timeoutlen = 1600


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
-- ┏━┓╺┳╸╻ ╻┏━╸┏━┓
-- ┃ ┃ ┃ ┣━┫┣╸ ┣┳┛
-- ┗━┛ ╹ ╹ ╹┗━╸╹┗╸
----------------------------------------------------------------------- Other --

-- Plugin loading goes in separate files for convenience and because then as
-- root the loading of them can be isolated. Minor security improvement.
if vim.fn.has('windows') == 1 or vim.uv.getuid() ~= 0 then
    require 'init-setup-plugins'
    require 'init-lsp'
end

-- Source legacy Vim Script from the old `vimrc`.
vim.cmd.source(vim.fn.stdpath('config') .. '/legacy.vim')
