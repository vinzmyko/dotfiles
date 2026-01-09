local lsp_utils = require('lsp')

local function setup_css_lsp()
    if vim.fn.executable('vscode-css-language-server') == 0 then
        return
    end

    vim.lsp.start({
        name = 'css',
        cmd = { 'vscode-css-language-server', '--stdio' },
        filetypes = { 'css', 'scss', 'less' },
        root_dir = lsp_utils.find_root({ '.git', 'package.json', 'hugo.toml' }),
        settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true }
        },

        init_options = {
            provideFormatter = true
        }
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspCss", { clear = true }),
    pattern = { "css", "scss", "less" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
        setup_css_lsp()
    end,
})
