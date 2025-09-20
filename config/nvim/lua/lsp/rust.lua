local lsp_utils = require('lsp')

local function setup_rust_lsp()
    if vim.fn.executable('rust-analyzer') == 0 then
        return
    end

    vim.lsp.start({
        name = 'rust_analyzer',
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_dir = lsp_utils.find_root({ 'Cargo.toml', '.git' }),
        settings = {
            ['rust-analyzer'] = {
                cargo = { allFeatures = true },
                checkOnSave = true,
            },
        },
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspRust", { clear = true }),
    pattern = "rust",
    callback = function()
        setup_rust_lsp()
    end,
})
