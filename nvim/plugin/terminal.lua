-- A single plugin to swiftly get in an out of a "default" terminal. Mimicking
-- the experience of pressing Ctrl-Z and getting back to the terminal where I
-- launched Neovim, but with all the expected advantages of Neovim and a
-- persistent shell that can be left running stuff.
-- Note that Ctrl-Z still restores back to the previosu buffer. Not sure if
-- that's worth keeping, TBH, because I already have a shortcut to get back to
-- the previous buffer, irrespective of it is a terminal or a file one.

local terminal_buffer = nil
local return_buffer = nil

-- A terminal buffer stays valid after its job exits, so the job must be checked
-- too. `jobwait()` with a zero timeout returns -1 only for running jobs. Jobs
-- killed by a signal return the negated signal number.
local function is_running()
    if terminal_buffer == nil or not vim.api.nvim_buf_is_valid(terminal_buffer) then
        return false
    end
    local job_id = vim.b[terminal_buffer].terminal_job_id
    return job_id ~= nil and vim.fn.jobwait({ job_id }, 0)[1] == -1
end

local function is_displayed()
    if terminal_buffer == nil or not vim.api.nvim_buf_is_valid(terminal_buffer) then
        return false
    end
    return #vim.fn.win_findbuf(terminal_buffer) > 0
end

local function hide()
    -- Restore the buffer that was displayed when the terminal was opened. It
    -- can be gone already (e.g. an unnamed buffer wiped when abandoned).
    local buffer = return_buffer
    if buffer == nil or not vim.api.nvim_buf_is_valid(buffer) then
        buffer = vim.api.nvim_create_buf(true, false)
    end
    -- The terminal is displayed when hiding (see `toggle()`), so never nil.
    ---@cast terminal_buffer -nil
    for _, window in ipairs(vim.fn.win_findbuf(terminal_buffer)) do
        vim.fn.win_execute(window, 'buffer ' .. buffer)
    end
end

local function show()
    return_buffer = vim.api.nvim_get_current_buf()
    if is_running() then
        -- A running job implies an existing terminal buffer.
        ---@cast terminal_buffer -nil
        vim.cmd('buffer ' .. terminal_buffer)
        -- Land on the last line, so that the prompt is visible and the output
        -- keeps scrolling (the previous view is restored otherwise).
        local last_line = vim.api.nvim_buf_line_count(terminal_buffer)
        vim.api.nvim_win_set_cursor(0, { last_line, 0 })
    else
        -- Delete the dead terminal buffer (e.g. after typing "exit"), so that
        -- they don't accumulate. It can not be displayed in this branch.
        if terminal_buffer ~= nil and vim.api.nvim_buf_is_valid(terminal_buffer) then
            vim.api.nvim_buf_delete(terminal_buffer, { force = true })
        end
        vim.cmd('terminal')
        terminal_buffer = vim.api.nvim_get_current_buf()
        -- Keep the terminal out of the buffer list, and the job alive when
        -- its buffer is hidden. To be reconsidered, however.
        vim.bo[terminal_buffer].buflisted = false
        vim.bo[terminal_buffer].bufhidden = 'hide'

        -- Get back with the same key. The <C-\> prefix is the "default" way of
        -- escaping terminal mode (like <C-\><C-n>). The trailing <C-z>
        -- resolves through the normal mode mapping below. A single <C-z> still
        -- reaches the shell, to suspend jobs inside the terminal. To be
        -- reconsidered as well. Because I think escaping to normal mode and
        -- then doing <C-z> again seems easier to press.
        vim.keymap.set('t', '<C-\\><C-z>', '<C-\\><C-n><C-z>', {
            buffer = terminal_buffer,
            remap = true,
        })
    end
    -- Do I always want this? Not sure. To revisit.
    vim.cmd('startinsert')
end

local function toggle()
    if is_displayed() then
        hide()
    else
        show()
    end
end

vim.keymap.set('n', '<C-z>', toggle)
