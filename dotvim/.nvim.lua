vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
                -- Gets all Neovim's runtime lua paths (vim.api, vim.lsp, etc.)
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            diagnostics = { globals = { 'vim' } },
        },
    },
})
