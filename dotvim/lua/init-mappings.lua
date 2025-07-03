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
    vim.cmd('normal! dp')
end)

make_repeatable('do', 'diff_obtain', function()
    vim.cmd('normal! do')
end)

-- NOTE: Making window resizing repeatable is... a stretch. It helps me
-- compensate the modes I lost when vim-submode stopped working, but it's an
-- experiment so far. I should look how to do this with Mini.
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

