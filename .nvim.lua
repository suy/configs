vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
                library = {
                    -- Neovim's runtime (i.e. only editor APIs).
                    vim.env.VIMRUNTIME,
                    -- Every `&runtimepath` entry (i.e. every plugin). This is
                    -- not generally advisable, as not only is pretty extensive:
                    -- it is also using the real code instead of the type stubs.
                    vim.api.nvim_get_runtime_file('', true),
                },
                checkThirdParty = false,
            },
            -- Supress diagnostics about unknown globals. I should very, very
            -- rarely need this, as the globals from mini.nvim can be declared
            -- in my own config just fine, the same way the plugin does it.
            -- However, I'm going to let this here, as a reminder of the
            -- feature, in case some other module/plugin/whatever does something
            -- that I can't fix in a cleaner way.
            diagnostics = {
                globals = {
                    'MiniJump2d',
                },
            },
        },
    },
})
