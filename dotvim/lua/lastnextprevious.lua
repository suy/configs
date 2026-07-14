-- Last Next/Previous: repeat the *last* two letter movement or action with a
-- single key, either forwards (*next*) or backwards (*previous*).
-- Possible future names:
-- * repeatable pairs
-- * ?

local M = {}

-- It is not necessary to make this public, but it's nice for debugging, and/or
-- for showing it in the status line, or similar.
M.last_action = 'buffer'
local pending_prefix = ''

local sequences = {
    ['[a'] = 'argument',
    [']a'] = 'argument',
    ['[b'] = 'buffer',
    [']b'] = 'buffer',
    ['[q'] = 'quick',
    [']q'] = 'quick',
    ['[l'] = 'location',
    [']l'] = 'location',
    ['[c'] = 'diff',
    [']c'] = 'diff',
    ['[s'] = 'spell',
    [']s'] = 'spell',
    ['g;'] = 'changes',
    ['g,'] = 'changes',
    -- FIXME: ugly control characters. Replace with escape codes, if redable.
    ['-'] = 'window-v',
    ['+'] = 'window-v',
    ['<'] = 'window-h',
    ['>'] = 'window-h',
}

local commands = {
    -- FIXME: think if this could work without ex commands. And, in case it's
    -- not possible, check if we really need to treat ex commands as special
    -- cases. Why would `feedkeys` fail to work?
    argument      = { ':previous',  ':next' },
    buffer        = { ':bprevious', ':bnext' },
    quick         = { ':cprev',     ':cnext' },
    location      = { '[l',         ']l' },
    diff          = { '[c',         ']c' },
    spell         = { '[s',         ']s' },
    changes       = { 'g;',         'g,' },
    -- FIXME: ugly control characters. Replace with escape codes, if redable.
    ["window-v"]  = { '-',         '+' },
    ["window-h"]  = { '<',         '>' },
}


local prefixes = {}
for sequence in pairs(sequences) do
    prefixes[sequence:byte(1)] = true
end


--- Execute a movement command with an optional count.
--- @param command string Ex command (with ':' prefix) or normal-mode keys.
--- @param count integer v:count value (0 means no count).
local function execute(command, count)
    if command:match('^:') then
        local ex = command:sub(2)
        if count > 0 then
            ex = count .. ex
        end
        vim.cmd(ex)
    else
        local keys = vim.keycode(command)
        if count > 0 then
            keys = count .. keys
        end
        vim.api.nvim_feedkeys(keys, 'm', false)
    end
end

--- Repeat the last movement backward.
function M.backward()
    local command = commands[M.last_action]
    -- vim.notify('backward, command: ' .. command[1])
    if command then
        execute(command[1], vim.v.count)
    end
end

--- Repeat the last movement forward.
function M.forward()
    local command = commands[M.last_action]
    -- vim.notify('forward, command: ' .. command[2])
    if command then
        execute(command[2], vim.v.count)
    end
end

--- Set up keystroke tracking and <Plug> mappings.
function M.setup()
    -- Use the 'typed' argument (raw physical keystrokes before mappings)
    -- to detect which movement the user performed.
    vim.on_key(function(_, typed)
        if typed == '' or vim.fn.mode() ~= 'n' then
            pending_prefix = ''
            return
        end
        -- vim.notify('typed: ' .. typed, vim.log.levels.INFO)

        local action = sequences[pending_prefix .. typed]
        if action then
            if action ~= M.last_action then
                vim.notify('Last next/previous: ' .. action, vim.log.levels.INFO)
                M.last_action = action
            end
            pending_prefix = ''
        elseif #typed == 1 and prefixes[typed:byte(1)] then
            pending_prefix = typed
        else
            pending_prefix = ''
        end
    end)

    -- TODO: do I really need this? Wouldn't it be better to just use the
    -- `forward` and `backward` functions, which are already exposed?
    vim.keymap.set('n', '<Plug>(lastnextprevious-forward)', M.forward)
    vim.keymap.set('n', '<Plug>(lastnextprevious-backward)', M.backward)
end

return M
