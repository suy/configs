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

