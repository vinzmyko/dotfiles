local lsp_utils = require('lsp')

local function setup_toml_lsp()
    if vim.fn.executable('taplo') == 0 then
        return
    end

    vim.lsp.start({
        name = 'taplo',
        cmd = { 'taplo', 'lsp', 'stdio' },
        filetypes = { 'toml' },
        root_dir = lsp_utils.find_root({ '.git', 'hugo.toml', 'Cargo.toml' }),
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspToml", { clear = true }),
    pattern = "toml",
    callback = function()
        setup_toml_lsp()
    end,
})
