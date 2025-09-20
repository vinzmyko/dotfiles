local lsp_utils = require('lsp')

local function setup_lua_lsp()
    vim.lsp.start({
        name = 'lua_ls',
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_dir = lsp_utils.find_root({ '.luarc.json', '.luarc.jsonc', '.git' }),
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspLua", { clear = true }),
    pattern = "lua",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
        setup_lua_lsp()
    end,
})
