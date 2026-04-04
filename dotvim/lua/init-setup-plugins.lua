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
-- MiniNotify
------------------------------------------------------------------------------
require('mini.notify').setup()
-- TODO: `:Messages` from Scriptease.vim shows the list of messages. MiniNotify
-- has `lua MiniNotify.show_history()` that shows in a scratch buffer. Consider
-- making a command or a key mapping that makes that more convenient.
vim.notify = require('mini.notify').make_notify({
    ERROR = { duration = 10000 } -- The default is 5s, so double it.
})



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



