--------------------------------------------------------------------------------
--  _____                          _   _   _
-- |  ___|__  _ __ _ __ ___   __ _| |_| |_(_)_ __   __ _
-- | |_ / _ \| '__| '_ ` _ \ / _` | __| __| | '_ \ / _` |
-- |  _| (_) | |  | | | | | | (_| | |_| |_| | | | | (_| |
-- |_|  \___/|_|  |_| |_| |_|\__,_|\__|\__|_|_| |_|\__, |
--                                                 |___/
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
--  _____     _
-- |_   _|_ _| |__  ___
--   | |/ _` | '_ \/ __|
--   | | (_| | |_) \__ \
--   |_|\__,_|_.__/|___/
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
--  ____                      _     _
-- / ___|  ___  __ _ _ __ ___| |__ (_)_ __   __ _
-- \___ \ / _ \/ _` | '__/ __| '_ \| | '_ \ / _` |
--  ___) |  __/ (_| | | | (__| | | | | | | | (_| |
-- |____/ \___|\__,_|_|  \___|_| |_|_|_| |_|\__, |
--                                          |___/
------------------------------------------------------------------- Searching --

-- Ignore case in searches unless you specify it explicitly (like /PaTTern).
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Start the search, and apparently move the cursor as you type.
vim.opt.incsearch = true
-- Highlight search results, but not on startup, or config reloads.
vim.opt.hlsearch = true
vim.cmd.nohlsearch()
-- Use global matching in regexes (override adding `/g` back to the search).
vim.opt.gdefault = true
-- Don't open folds when searching for a match.
vim.opt.foldopen:remove('search')


