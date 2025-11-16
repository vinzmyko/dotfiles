local lsp_utils = require('lsp')

local function setup_html_lsp()
    if vim.fn.executable('vscode-html-language-server') == 0 then
        return
    end

    vim.lsp.start({
        name = 'html',
        cmd = { 'vscode-html-language-server', '--stdio' },
        filetypes = { 'html', 'gotmpl' },
        root_dir = lsp_utils.find_root({ '.git', 'package.json' }),
        init_options = {
            provideFormatter = true,
            embeddedLanguages = {
                css = true,
                javascript = true,
            },
        },
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspHtml", { clear = true }),
    pattern = { "html", "gotmpl" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
        setup_html_lsp()
    end,
})
