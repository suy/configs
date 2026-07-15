-- Micro-plugin that folds the first comment (typically, copyright header).

local function fold_top_comment()
    local position = vim.fn.getcurpos()
    vim.cmd('keepjumps normal! gg')
    local syn_id = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 0)
    if vim.fn.synIDtrans(syn_id) == vim.fn.hlID('Comment') then
        vim.cmd('silent! normal! zc')
    end
    vim.fn.setpos('.', position)
end

vim.api.nvim_create_autocmd('BufReadPost', {
    group = Init.autocmd_group,
    callback = fold_top_comment,
})
