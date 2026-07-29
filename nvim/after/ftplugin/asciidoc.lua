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


-- Custom sort function for mini.operators. Sorts list items spanning multiple
-- lines. Each item starts with an asterisk at the start of the line and may
-- span continuation lines. Falls back to default sort for charwise regions or
-- when no asterisks are found.
local function sort_list_items(content)
    if content.submode == 'v' then
        return MiniOperators.default_sort_func(content)
    end

    local list_pattern = '^%*+%s' -- constant
    local lines = content.lines

    -- Require the first line to be a list item.
    if not lines[1]:match(list_pattern) then
        vim.notify('Selection is not a list item, using default sort', vim.log.levels.INFO)
        return MiniOperators.default_sort_func(content)
    end

    -- Group consecutive lines into items, each starting with a bullet.
    local items = {}
    local current = nil

    for _, line in ipairs(lines) do
        if line:match(list_pattern) then
            current = { line }
            table.insert(items, current)
        else
            table.insert(current, line)
        end
    end

    -- Sort items by their first line.
    table.sort(items, function(one, two)
        return one[1] < two[1]
    end)

    -- Flatten sorted items: from arrays of lines into a single array of lines.
    local result = {}
    for _, item in ipairs(items) do
        vim.list_extend(result, item)
    end

    return result
end

vim.b.minioperators_config = {
    sort = { func = sort_list_items },
}
