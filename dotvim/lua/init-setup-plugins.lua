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
-- TODO: make a wrapper function that stores the message in a ring buffer, then
-- passes it to the make_notify function. Then add a function that displays the
-- messages, like :Messages does.
vim.notify = require('mini.notify').make_notify({
    ERROR = { duration = 10000 } -- The default is 5s, so double it.
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

    -- Whether to set Vim's settings for statusline (make it always shown)
    -- set_vim_settings = true,
    set_vim_settings = false,
})
MiniStatusline.section_git = function()
    -- This is not very pretty... But seems fugitive hardcodes this characters.
    return vim.fn.FugitiveStatusline()
end

vim.schedule(function()
    vim.o.laststatus=3 -- TODO: Not needed if I just set it in the settings
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

    -- Whether to set Vim's settings for tabline (make it always shown and
    -- allow hidden buffers)
    -- set_vim_settings = true,
    set_vim_settings = false,

    -- Where to show tabpage section in case of multiple vim tabpages.
    -- One of 'left', 'right', 'none'.
    -- tabpage_section = 'left',
})
-- TODO: needs to be set on colorscheme change as well. Autocmd?
vim.schedule(function()
    vim.o.showtabline = 2 -- Always show tabline
    -- TODO: doesn't highlight properly which one is active. If 2 are active,
    -- both are shown the same. Airline also shows path, and changes color when
    -- modified. There seem to be highlight groups to customize this, but I
    -- hardly remember how to use them and make it suck less.
    vim.cmd('hi! link MiniTablineCurrent Title')
    vim.cmd('hi! link MiniTablineModifiedCurrent Title')
end)



