-- Simple replacement for the old vim-choosewin. On invocation, it displays a
-- big number label on each window. Press the number to jump directly, or any
-- other key to perform a <C-w> window command (e.g. h/j/k/l to move).

-- From `figlet -f future`.
local label_letters = {
    '╺┓ ┏━┓┏━┓╻ ╻┏━╸┏━┓┏━┓┏━┓┏━┓',
    ' ┃ ┏━┛╺━┫┗━┫┗━┓┣━┓  ┃┣━┫┗━┫',
    '╺┻╸┗━╸┗━┛  ╹┗━┛┗━┛  ╹┗━┛┗━┛',
}
local choices = '123456789'

local function label_lines(index)
    local start = (index - 1) * 3
    return {
        vim.fn.strcharpart(label_letters[1], start, 3),
        vim.fn.strcharpart(label_letters[2], start, 3),
        vim.fn.strcharpart(label_letters[3], start, 3),
    }
end


local function window_chooser()
    -- Collect regular (non-floating) windows in the current tabpage.
    local windows = {}
    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(window).relative == '' then
            table.insert(windows, window)
        end
    end

    if #windows <= 1 then
        -- 23 == <C-w>. We need to send the keys this way, because something
        -- like `:normal` would expect a whole command, not part of it.
        vim.api.nvim_feedkeys('\23', 'n', false)
        return
    end

    -- Show a floating label centered in each window.
    local labels = {}
    local floats = {}
    for index, window in ipairs(windows) do
        local choice = choices:sub(index, index)
        if choice == '' then -- More windows than characters.
            -- TODO: show an error/warning.
            break
        end
        labels[choice] = window

        local art = label_lines(index)
        local buffer = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {
            '     ',
            ' ' .. art[1] .. ' ',
            ' ' .. art[2] .. ' ',
            ' ' .. art[3] .. ' ',
            '     ',
        })
        local position = vim.api.nvim_win_get_position(window)
        local width = vim.api.nvim_win_get_width(window)
        local height = vim.api.nvim_win_get_height(window)
        local float = vim.api.nvim_open_win(buffer, false, {
            relative = 'editor',
            row = position[1] + math.floor((height - 5) / 2),
            col = position[2] + math.floor((width - 5) / 2),
            width = 5,
            height = 5,
            style = 'minimal',
            border = 'rounded',
            focusable = false,
            noautocmd = true,
            zindex = 100,
        })
        vim.wo[float].winhighlight = 'Normal:Visual,FloatBorder:Visual'
        table.insert(floats, { window = float, buffer = buffer })
    end

    -- Block for input, then clean up regardless of the result.
    vim.api.nvim_echo({ { 'Choose window: ', 'Question' } }, false, {})
    vim.cmd.redraw()
    local ok, key = pcall(vim.fn.getcharstr)
    vim.api.nvim_echo({}, false, {}) -- Clear the command line.

    for _, float in ipairs(floats) do
        pcall(vim.api.nvim_win_close, float.window, true)
        pcall(vim.api.nvim_buf_delete, float.buffer, { force = true })
    end

    -- Only single printable ASCII characters are valid <C-w> sub-commands.
    -- Special keys (arrows, function keys) are multi-byte; Esc and other
    -- control characters are below the printable range.
    if ok and labels[key] then
        vim.api.nvim_set_current_win(labels[key])
    elseif ok and #key == 1 and key:byte() >= 33 then
        vim.cmd.wincmd(key)
    end
end

vim.keymap.set('n', '<leader>w', window_chooser, {
    silent = true,
    desc = 'Choose window',
})


