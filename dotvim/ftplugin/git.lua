-- Micro plugin for reviewing the output of `git log`. I tend to pipe its output
-- to `nvim -R -` to quickly go through the log commit by commit, and stop to
-- look at specific comments as needed.

local function next_commit()
    vim.fn.search('^commit ', 'W')
end

local function previous_commit()
    vim.fn.search('^commit ', 'bW')
end

local function show_commit()
    local position = vim.fn.search('^commit ', 'bncW')
    local line = vim.fn.getline(position ~= 0 and position or '.')
    local hash = line:match('^commit%s+(%S+)')
    if hash then
        vim.cmd('Gtabedit ' .. hash)
    end
end

vim.keymap.set('n', '<C-n>', next_commit, { buffer = true, desc = 'Next commit' })
vim.keymap.set('n', '<C-p>', previous_commit, { buffer = true, desc = 'Previous commit' })
vim.keymap.set('n', '<CR>', show_commit, { buffer = true, desc = 'Open commit in new tab' })
