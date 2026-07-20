--------------------------------------------------------------------------------
-- nvim.undotree (built-in since Neovim 0.12)
--------------------------------------------------------------------------------
if vim.version() >= vim.version.parse('0.12') then
    vim.cmd.packadd('nvim.undotree')
    vim.api.nvim_create_autocmd('FileType', {
        group = Init.autocmd_group,
        pattern = 'nvim-undotree',
        callback = function(args)
            vim.keymap.set('n', 'q', function()
                vim.api.nvim_win_close(0, false)
            end, { buffer = args.buf, silent = true, desc = 'Close undotree' })
        end,
    })
end



--------------------------------------------------------------------------------
-- ident-blankline, AKA 'ibl'
--------------------------------------------------------------------------------
require('ibl').setup({
    indent = { char = '▎' }, -- It's the default, but make it explicit.
})



--------------------------------------------------------------------------------
-- Mini.Extra
--------------------------------------------------------------------------------
-- Setup this first, as it's a dependency of other Mini plugins. Also set the
-- global explicitly, so the Lua LSP server doesn't complain about the global.
MiniExtra = require('mini.extra')
MiniExtra.setup()



--------------------------------------------------------------------------------
-- Mini.Ai
--------------------------------------------------------------------------------
require('mini.ai').setup({
    custom_textobjects = {
        e = MiniExtra.gen_ai_spec.buffer(), -- e="entire buffer", like kana's plugin
        -- D = gen_ai_spec.diagnostic(), -- TODO: consider.
        i = MiniExtra.gen_ai_spec.indent(),
        L = MiniExtra.gen_ai_spec.line(),
        N = MiniExtra.gen_ai_spec.number(),
    },
    -- mappings = {
    --     around_next = 'an',
    --     inside_next = 'in',
    --     around_last = 'al',
    --     inside_last = 'il',
    --
    --     goto_left = 'g[',
    --     goto_right = 'g]',
    -- },
})



------------------------------------------------------------------------------
-- MiniBracketed
------------------------------------------------------------------------------
-- TODO: A lot of overlap with unimpaired, so needs reviewing. Most seems the
-- same, but perhaps is worth considering some, like move to next diagnostic (if
-- the new core mapping is different). Also one to move to a next/prev
-- indentation, if it complements ai/indentscope.
-- NB: Unimpaired also provides mappings for toggling options which are *not* on
-- MiniBracketed, but which are on MiniBasics instead. So both need to be
-- reviewed at the same time, and check out for missing things.



------------------------------------------------------------------------------
-- MiniCursorword
------------------------------------------------------------------------------
require('mini.cursorword').setup()



--------------------------------------------------------------------------------
-- MiniDiff
--------------------------------------------------------------------------------
require('mini.diff').setup({
    view = {
        style = 'sign',
    },
    mappings = { -- Use an empty string to disable a mapping.
        -- Apply hunks inside a visual/operator region (default was `gh`).
        apply = '<leader>dp',
        -- Reset hunks inside a visual/operator region (default was `gH`)
        reset = '<leader>do',
        -- Hunk range textobject to be used as operator (e.g. `=gh`).
        textobject = '<leader>dh',
        -- Navigate through hunks like the native ones in diff mode.
        goto_first = '[C',
        goto_prev = '[c',
        goto_next = ']c',
        goto_last = ']C',
    },
})



------------------------------------------------------------------------------
-- MiniFiles
------------------------------------------------------------------------------
require('mini.files').setup()



------------------------------------------------------------------------------
-- MiniIcons
------------------------------------------------------------------------------
require('mini.icons').setup()



------------------------------------------------------------------------------
-- MiniIndentscope
------------------------------------------------------------------------------
-- Changed default character to something better aligned to the left.
require('mini.indentscope').setup({ symbol = '▎' })
vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.b.miniindentscope_disable = true
    end
})



------------------------------------------------------------------------------
-- MiniJump2d
------------------------------------------------------------------------------
require('mini.jump2d').setup({
    mappings = { start_jumping = '' },
    -- labels = 'asdfjkl;ghqwertyuiopzxcvbnm,',
    labels = 'fjdksla;ghrueiwoqpvncmx.z/',
    allowed_windows = { current = true, not_current = false, },
})
vim.keymap.set({'n', 'x', 'o'}, '<Leader>j', function()
    MiniJump2d.start(MiniJump2d.builtin_opts.single_character)
end)

-- Alternative, for reference. Requires a bit of a patch to mini.jump2d. See:
-- https://github.com/nvim-mini/mini.nvim/discussions/2359
-- MiniJump2d.setup(vim.tbl_deep_extend('force',
--     MiniJump2d.builtin_opts.single_character,
--     {
--         mappings = { start_jumping = '<Leader>j' },
--         labels = 'asdfjkl;ghqwertyuiopzxcvbnm,',
--         allowed_windows = { current = true, not_current = false, },
--     }
-- ))



------------------------------------------------------------------------------
-- MiniNotify
------------------------------------------------------------------------------
require('mini.notify').setup()
-- TODO: `:Messages` from Scriptease.vim shows the list of messages. MiniNotify
-- has `lua MiniNotify.show_history()` that shows in a scratch buffer. Consider
-- making a command or a key mapping that makes that more convenient.
vim.notify = require('mini.notify').make_notify({
    ERROR = { duration = 10000 } -- The default is 5s, so double it.
})

local reminders = {
    'Use `lua MiniNotify.show_history()` to see past notifications.',
    'Text object `ii` matches an indent, `iL` a line',
    'Text object `iN` matches a number',
    'Text object `iq` matches any quote, `ib` any brace',
    'Text object `if` matches a function call',
    'Text object `i(` matches without space, `i)` WITH space',
    'Use <leader>j to use MiniJump2 (instead of EasyMotion)',
    '`"+` is the clipboard (mnemonic: "more" => persistent). Pasted with `<leader>p`',
    '`"*` is the selection (mnemonic: "star" => selection). Pasted with `<leader>P`',
    'TODO: Review `[i` and `]i` from MiniIndentscope',
    'TODO: Review some mappings starting with `<leader>` for cleanup',
    'In MiniPick, `<C-e>` edits a history/search/etc',
    'While typing a search, `<C-g>` and `<C-t> "move" between matches`',
    'MiniPick\'s "live_grep" available in menu and 6<leader>y',
    '`gx` exchanges regions (replaces vim-exchange, which was `cx`)',
    '`gm` duplicates text: `2gm3aw` makes 2 copies of 3 words',
    '`g=` evaluates as Lua and replaces with the result',
    '`gs` sorts: charwise splits on delimiters, linewise as-is',
    'mini.operators: `2Riw` pastes register contents twice over word',
    '`<leader>dp` applies a hunk, `<leader>do` resets it',
    '`<leader>dh` is the hunk textobject for operators',
}

math.randomseed(os.time())

local function show_reminder()
    local reminder = reminders[math.random(#reminders)]
    local id = MiniNotify.add(reminder, 'INFO')
    vim.defer_fn(function()
        MiniNotify.remove(id)
    end, 5000) -- Visible for 5 seconds.
end

-- Show once on startup, with half a second delay.
vim.defer_fn(show_reminder, 500)
-- Show also one each 15 minutes.
local delay = 15 * 60 * 1000
vim.uv.new_timer():start(delay, delay, vim.schedule_wrap(show_reminder))

-- My very first feature contributed to Neovim. <3<3<3
-- https://github.com/neovim/neovim/pull/8487
vim.api.nvim_create_autocmd('SearchWrapped', {
    callback = function()
        local id = MiniNotify.add('Search wrapped', 'INFO')
        vim.defer_fn(function()
            MiniNotify.remove(id)
        end, 2000) -- Visible for 2 seconds.
    end
})



------------------------------------------------------------------------------
-- MiniOperators
------------------------------------------------------------------------------
require('mini.operators').setup({
    replace = {
        prefix = 'R',
    },
})

-- Little hack that seems to work fine, so keep it as an experiment. Notify when
-- an exchange is in progress, and remind that <C-c> can cancel it.
local function exchange_in_progress()
    return vim.fn.maparg('<C-c>', 'n', false, true).desc == 'Stop exchange'
end

local original_exchange_operator = MiniOperators.exchange
MiniOperators.exchange = function(mode)
    local was_in_progress = exchange_in_progress()
    local result = original_exchange_operator(mode)
    if not was_in_progress and exchange_in_progress() then
        vim.notify('Exchange: press <C-c> to cancel', vim.log.levels.INFO)
    end
    return result
end



------------------------------------------------------------------------------
-- MiniPick
------------------------------------------------------------------------------
MiniPick = require('mini.pick')
MiniPick.setup()
require('unilove.pick') -- Auto-registers in MiniPick.registry

-- Contextual tips: show a random mini.pick usage tip each time a picker opens.
local mini_pick_tips = {
    '<S-Tab> toggles information, including mappings',
    'Mark items with <C-x>, then <M-CR> to act on all of them',
    '<C-Space> "refines" within current results (it narrows, doesn\'t restart)',
    '<M-Space> "refines" only the marked items',
    '<C-a> marks all items at once (toggle)',
    'Open in split/vsplit/tabpage with <C-s>/<C-v>/<C-q>',
    '<C-r> followed by a register name pastes it into the query',
    '<C-b>/<C-f> move the caret within the query line',
    '<C-g> jumps back to the first match',
}

vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniPickStart',
    callback = function()
        local tip = mini_pick_tips[math.random(#mini_pick_tips)]
        local id = MiniNotify.add(tip, 'INFO')
        vim.defer_fn(function()
            MiniNotify.remove(id)
        end, 8000)
    end,
    desc = 'Show a random mini.pick tip',
})

local function mini_pick_messages()
    local messages = vim.split(vim.fn.execute('messages'), '\n', { trimempty = true })
    MiniPick.start({ source = { items = messages, name = 'Messages' } })
end

local function mini_pick_command_history()
    MiniExtra.pickers.history({ scope = ':' })
end

local function mini_pick_lsp_references()
    MiniExtra.pickers.lsp({ scope = 'references' })
end

local function mini_pick_lsp_symbols()
    MiniExtra.pickers.lsp({ scope = 'workspace_symbol' })
end

-- The menu picker: a mini.pick interface that lists named actions.
-- Selecting an entry runs the corresponding picker.
local function mini_pick_menu()
    -- List of menu entries in an array, so the order is preserved.
    local entries = {
        { 'Files in tree',      function() MiniPick.builtin.files() end },
        { 'Opened buffers',     function() MiniPick.builtin.buffers() end },
        { 'Recent files',       function() MiniExtra.pickers.oldfiles() end },
        { 'Help tags',          function() MiniPick.builtin.help() end },
        { 'Command history',    mini_pick_command_history },
        { 'Grep in tree',       function() MiniPick.builtin.grep_live() end },
        { 'Messages',           mini_pick_messages },
        { 'Unicode codepoints', function() MiniPick.registry.unilove() end },
        { 'LSP diagnostics',    function() MiniExtra.pickers.diagnostic() end },
        { 'LSP references',     mini_pick_lsp_references },
        { 'LSP symbols',        mini_pick_lsp_symbols },
        { 'Neovim options',     function() MiniExtra.pickers.options() end },
        { 'Key mappings',       function() MiniExtra.pickers.keymaps() end },
        { 'Marks',              function() MiniExtra.pickers.marks() end },
        { 'Registers',          function() MiniExtra.pickers.registers() end },
        { 'Git commits',        function() MiniExtra.pickers.git_commits() end },
        { 'Git hunks',          function() MiniExtra.pickers.git_hunks({ scope = 'all' }) end },
    }

    -- MiniPick's `items` is passed as plain strings, so default matching and
    -- rendering works out of the box. We build another table to map the names
    -- to their corresponding functions.
    local names  = vim.tbl_map(function(element) return element[1] end, entries)
    local functions = {}
    for _, entry in ipairs(entries) do
        functions[entry[1]] = entry[2]
    end

    MiniPick.start({
        source = {
            name   = 'Menu',
            items  = names,
            choose = function(item)
                functions[item]()
            end,
        },
    })
end

-- Invocation trick: use `[count]<leader>y` to invoke one of the following.
vim.keymap.set('n', '<leader>y', function()
    local pickers = {
        [0] = function() MiniPick.builtin.files({ tool = 'git' }) end,
        [1] = mini_pick_menu,
        [2] = function() MiniPick.builtin.buffers() end,
        [3] = function() MiniExtra.pickers.oldfiles() end,
        [4] = mini_pick_command_history,
        [5] = mini_pick_messages,
        [6] = function() MiniPick.builtin.grep_live() end,
        [7] = function() MiniPick.builtin.help() end,
        [8] = function() MiniExtra.pickers.diagnostic() end,
        [9] = function() MiniPick.registry.unilove() end,
    }
    pickers[math.min(math.max(0, vim.v.count), #pickers)]()
end,
{ silent = true, desc = '[count]<leader>y mini.pick launcher' })

vim.keymap.set('c', '<C-s>', 'Pick history<Return>')



------------------------------------------------------------------------------
-- MiniStarter
------------------------------------------------------------------------------
MiniStarter = require('mini.starter')
local ignorable_files = {
    'COMMIT_EDITMSG', '.git/index', '/tmp/.+', 'bundle/.+/doc',
}
local function filtered_recent_files(current_only)
    return function()
        local raw = MiniStarter.sections.recent_files(10, current_only)()
        local result = {}
        for _, element in ipairs(raw) do
            local ignore = false
            for _, ignorable in ipairs(ignorable_files) do
                if element.name:match(ignorable) then
                    ignore = true
                    break
                end
            end
            if not ignore then
                table.insert(result, element)
            end
        end
        return result
    end
end

-- A mini.starter section to replicate my ancient vim-startify patch. Derives
-- recent git repositories from oldfiles, and changes to them, reloading
-- mini.starter, so you "drill down" into a project, as a form of lightweight
-- and fully automated session management. Only shown outside repositories.
local function recent_repositories()
    -- Check if we are in a git repository by searching for `.git` upwards.
    local cwd = vim.fn.getcwd()
    local repos = vim.fs.find('.git', { upward = true, path = cwd, limit = 1 })
    if #repos > 0 then
        return {}
    end

    local seen = {}
    repos = {}
    for _, path in ipairs(vim.v.oldfiles) do
        -- Cap to 9 results for space and key shortcut availability (a1 to a9).
        if #repos == 9 then
            break
        end
        if vim.fn.filereadable(path) == 1 then
            local dir = vim.fs.dirname(path)
            local found = vim.fs.find('.git', { upward = true, path = dir, limit = 1 })
            if found[1] then
                local root = vim.fs.dirname(found[1])
                if not seen[root] then
                    seen[root] = true
                    table.insert(repos, root)
                end
            end
        end
    end

    table.sort(repos)

    local items = {}
    for _, repo in ipairs(repos) do
        table.insert(items, {
            name = vim.fn.fnamemodify(repo, ':~'),
            action = function()
                vim.cmd.cd(vim.fn.fnameescape(repo))
                MiniStarter.refresh()
            end,
            section = 'Recent repositories',
        })
    end
    return items
end

MiniStarter.setup({
    autoopen = true, -- Turn to false if need to disable it.
    -- Open file/evaluate action automatically when only one item matches.
    evaluate_single = true,

    -- Items to be displayed. Should be an array with the following elements:
    -- - Item: table with <action>, <name>, and <section> keys.
    -- - Function: should return one of these three categories.
    -- - Array: elements of these three types (i.e. item, array, function).
    -- If `nil` (default), default items will be used (see |mini.starter|).
    items = {
        MiniStarter.sections.builtin_actions(),
        recent_repositories,
        filtered_recent_files(true),
        filtered_recent_files(false),
    },

    -- Array  of functions to be applied consecutively to initial content.
    -- Each function should take and return content for 'Starter' buffer (see
    -- |mini.starter| and |MiniStarter.content| for more details).
    -- content_hooks = nil,
    content_hooks = {
        MiniStarter.gen_hook.adding_bullet(),
        MiniStarter.gen_hook.indexing('section', { 'Builtin actions' }),
        MiniStarter.gen_hook.padding(8, 2),
    },

    -- Whether to disable showing non-error feedback
    silent = false,
})



------------------------------------------------------------------------------
-- MiniStatusline
------------------------------------------------------------------------------
MiniStatusline = require('mini.statusline')
MiniStatusline.setup({
    -- Content of statusline as functions which return statusline string. See
    -- `:h statusline` and code of default contents (used instead of `nil`).
    content = {
        -- Content for active window
        active = nil,
        -- Content for inactive window(s)
        -- inactive = nil,
        inactive = MiniStatusline.active,
    },

    -- Whether to use icons by default
    -- use_icons = true,
})
MiniStatusline.section_git = function()
    -- This is not very pretty... But seems fugitive hardcodes this characters.
    return vim.fn.FugitiveStatusline()
end

vim.schedule(function()
    -- TODO: This is needed for this plugin (it needs to be 2 or 3), but it
    -- should not be done here, Move it to the normal settings.
    vim.o.laststatus=3
end)



--------------------------------------------------------------------------------
-- MiniTabline
--------------------------------------------------------------------------------
require('mini.tabline').setup({
    -- Whether to show file icons (requires 'mini.icons')
    -- show_icons = true,

    -- Function which formats the tab label
    -- By default surrounds with space and possibly prepends with icon
    -- format = nil,
    format = function(buffer_id, label)
      local suffix = vim.bo[buffer_id].modified and '+ ' or ''
      return MiniTabline.default_format(buffer_id, label) .. suffix
    end,

    -- Where to show tabpage section in case of multiple vim tabpages.
    -- One of 'left', 'right', 'none'.
    -- tabpage_section = 'left',
})
-- TODO: needs to be set on colorscheme change as well. Autocmd?
vim.schedule(function()
    -- TODO: doesn't highlight properly which one is active. If 2 are active,
    -- both are shown the same. Airline also shows path, and changes color when
    -- modified. There seem to be highlight groups to customize this, but I
    -- hardly remember how to use them and make it suck less.
    vim.cmd('hi! link MiniTablineCurrent Title')
    vim.cmd('hi! link MiniTablineModifiedCurrent Title')
end)



--------------------------------------------------------------------------------
-- MiniTrailspace
--------------------------------------------------------------------------------
require('mini.trailspace').setup()



