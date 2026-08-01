--------------------------------------------------------------------------------
-- ┏━┓┏━╸┏┳┓┏━┓┏━┓┏━┓
-- ┣┳┛┣╸ ┃┃┃┣━┫┣━┛┗━┓
-- ╹┗╸┗━╸╹ ╹╹ ╹╹  ┗━┛
---------------------------------------------------------------------- Remaps --

-- Close fugitive windows with 'q'. Recursive so it triggers fugitive's 'gq'.
vim.api.nvim_create_autocmd('FileType', {
    group = Init.autocmd_group,
    pattern = { 'fugitive', 'fugitiveblame' },
    callback = function(args)
        vim.keymap.set('n', 'q', 'gq', { buffer = args.buf, remap = true })
    end,
})

-- A simple helper for the simple cases of repeating something without a motion.
-- Note the `g@l`: the `l` is the hardcoded motion for the `g@` operator.
-- See: https://www.vikasraj.dev/blog/vim-dot-repeat
-- And: https://www.reddit.com/r/neovim/comments/wkqkzf/adding_dotrepeat_to_plugins/
-- The first link provides the full solution, the second the `g@l` trick.
local function make_repeatable(from, function_name, function_body)
    Init[function_name] = function(motion)
        if motion == nil then
            vim.o.operatorfunc = 'v:lua.Init.' .. function_name
            return 'g@l'
        end
        function_body()
    end
    vim.keymap.set('n', from, Init[function_name], { expr = true })
end

make_repeatable('dp', 'diff_put', function()
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

make_repeatable('do', 'diff_obtain', function()
    vim.cmd('normal! do')
end)

-- NOTE: Making window resizing repeatable is... a stretch. It helps me
-- compensate the modes I lost when vim-submode stopped working, but it's an
-- experiment so far. I should look how to do this with Mini.
--[[
-- NOTE (2nd): kept this for now, for reference, but I'm gonna try to use
-- last-next-previous for this.
make_repeatable('<C-w><', 'win_left', function()
    vim.cmd.wincmd '<'
end)

make_repeatable('<C-w>>', 'win_right', function()
    vim.cmd.wincmd '>'
end)

make_repeatable('<C-w>-', 'win_down', function()
    vim.cmd.wincmd '-'
end)

make_repeatable('<C-w>+', 'win_up', function()
    vim.cmd.wincmd '+'
end)
--]]

vim.keymap.set({'n', 'x'}, 'gy', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n',        'gp', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set('n',        'gP', '"+P', { desc = 'Paste from system clipboard' })


--------------------------------------------------------------------------------
-- ┏┳┓┏━┓┏━┓┏━┓
-- ┃┃┃┣━┫┣━┛┗━┓
-- ╹ ╹╹ ╹╹  ┗━┛
------------------------------------------------------------------------ Maps --

vim.keymap.set('n', '<leader>k', function()
    local temp = vim.fn.getreg('+')
    vim.fn.setreg('+', vim.fn.getreg('"'))
    vim.fn.setreg('"', temp)
end, { desc = 'Swap unnamed register with the clipboard' })


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

