vim.bo.commentstring='// %s'
-- See `:h format-comments`. The option is a comma separated {flags}:{string},
-- where the flags are optional. We say that `//` is a comment, while the
-- others, which are the characters used for lists, have the `fb` flags. It's
-- weird, but `comments` is used to configure this kind of list formatting.
vim.bo.comments='://,fb:-,fb:*,fb:.'


-- Copied and adapted from runtime/lua/man.lua.
local function show_toc()
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local info = vim.fn.getloclist(0, { winid = 1 })
    if info ~= '' and vim.w[info.winid].qf_toc == bufname then
        vim.cmd.lopen()
        return
    end

    ---@type {bufnr:integer, lnum:integer, text:string}[]
    local toc = {}
    local line = 2 -- The first one will likely be the document title
    local last = vim.fn.line('$')

    while line > 0 and line <= last do
        local text = vim.fn.getline(line)
        -- The space after the equal signs skips blocks wrapped in `====`.
        local markers = text:match('^(===?=?) ')
        -- Alternative, if I change my mind and want to match the header
        -- separately, to disply only the header, or whatever.
        -- local markers, header = text:match('^(===?=?) (.*)')
        if markers then
            local padding = #tostring(last) - #tostring(line)
            toc[#toc + 1] = {
                bufnr = bufnr,
                lnum = line,
                text = string.rep('.', padding) .. text,
            }
        end
        line = vim.fn.nextnonblank(line + 1)
    end

    vim.fn.setloclist(0, toc, ' ')
    vim.fn.setloclist(0, {}, 'a', { title = 'Table of Contents' })
    vim.cmd.lopen()
    vim.w.qf_toc = bufname
end

vim.keymap.set('n', 'gO', show_toc)
