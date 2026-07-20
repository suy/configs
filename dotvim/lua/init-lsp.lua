-- Note about new LSP mappings that will land in 0.11:
-- https://bsky.app/profile/neovim.io/post/3lb2u3tjlnc2f
-- gra - select code action
-- gri - list implementations
-- grn - rename references
-- grr - list references
-- Details:
-- https://github.com/neovim/neovim/pull/28650/files
-- https://github.com/neovim/neovim/pull/30764/files
-- https://github.com/neovim/neovim/pull/30781/files
-- |grn| in Normal mode maps to |vim.lsp.buf.rename()|
-- |grr| in Normal mode maps to |vim.lsp.buf.references()|
-- |gri| in Normal mode maps to |vim.lsp.buf.implementation()|
-- |gO| in Normal mode maps to |vim.lsp.buf.document_symbol()|
-- |gra| in Normal and Visual mode maps to |vim.lsp.buf.code_action()|
-- CTRL-S in Insert mode maps to |vim.lsp.buf.signature_help()|

-- (Possibly) others from 0.10:
-- https://neovim.io/doc/user/news-0.10.html
-- https://gpanders.com/blog/whats-new-in-neovim-0.10/


-- Neovim >=0.11 sets omnifunc, formatexpr, and gr* keymaps automatically via
-- vim.lsp.enable(). But filetype matching does NOT prevent LSP from attaching
-- to unwanted buffers. A Lua file opened via fugitive (:Gedit, :Gdiffsplit)
-- has a `fugitive://` URI but keeps filetype 'lua'. The LspAttach autocmd
-- filters by URI scheme:
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
    callback = function(args)
        local buffer = args.buf
        if vim.api.nvim_buf_get_name(buffer):match '^%a+://' then
            vim.lsp.buf_detach_client(buffer, args.data.client_id)
        end
    end,
})


-- Disable stuff that I don't want so far. This probably should be done better,
-- to support a variety of languages/servers/etc.
vim.diagnostic.config({
    virtual_text = true,
    -- signs = true, -- default
    signs = false,
    -- underline = true, -- default
    underline = false,
    update_in_insert = false,
    severity_sort = false,
})

vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    -- Only set "universal" settings. Workspace stuff should be per-project.
    settings = {
        Lua = {
            telemetry = { enable = false },
            runtime = {
                version = 'LuaJIT' -- So far LuaJIT is a safe fallback/"standard".
            },
            workspace = {
                -- `checkThirdParty` and `userThirdParty` should be safe for all
                -- Lua projects. When `lua_ls` sees patterns specified in either
                -- addon in the addon directory (e.g. a certain file path or
                -- `require`), it loads the definitions automatically.
                checkThirdParty = 'ApplyInMemory',
                userThirdParty = {
                    -- Try to resolve the path to the configs repository, then
                    -- append the subdirectory where the LS addons are.
                    vim.fs.dirname(vim.fn.resolve(vim.fn.stdpath('config')))
                        .. '/lua-language-server-addons/',
                },
            },
        },
    },
})
vim.lsp.enable('lua_ls')

--[[
require('lspconfig').lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT' -- So far LuaJIT is a safe fallback/"standard".
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                },
                checkThirdParty = 'ApplyInMemory',
                userThirdParty = {
                   vim.fn.expand('~/personal/configs/lua-language-server-addons/')
                }
            }
        }
    }
}
--]]
