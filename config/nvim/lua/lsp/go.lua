local lsp_utils = require('lsp')

local function setup_go_lsp()
    if vim.fn.executable('gopls') == 0 then
        return
    end

    vim.lsp.start({
        name = 'gopls',
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_dir = lsp_utils.find_root({ 'go.mod', 'go.work', '.git' }),
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        },
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspGo", { clear = true }),
    pattern = { "go", "gomod", "gowork", "gotmpl" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = false -- Go uses tabs
        setup_go_lsp()
    end,
})
