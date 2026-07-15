-- Close all fugitive windows in the current tab page.

local function gclose()
    local previous_buffer = vim.api.nvim_get_current_buf()
    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(window) then
            local buffer = vim.api.nvim_win_get_buf(window)
            if vim.b[buffer].fugitive_type then
                vim.api.nvim_win_close(window, false)
            end
        end
    end
    local windows = vim.fn.win_findbuf(previous_buffer)
    if #windows > 0 then
        vim.api.nvim_set_current_win(windows[1])
    end
end

vim.api.nvim_create_user_command('Gclose', gclose, {})
