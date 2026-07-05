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


