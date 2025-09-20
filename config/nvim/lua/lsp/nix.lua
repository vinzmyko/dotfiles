local lsp_utils = require('lsp')

local function setup_nix_lsp()
    vim.lsp.start({
        name = 'nixd',
        cmd = { 'nixd' },
        filetypes = { 'nix' },
        root_dir = lsp_utils.find_root({ 'flake.nix', 'default.nix', '.git' }),
        settings = {},
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspNix", { clear = true }),
    pattern = "nix",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
        setup_nix_lsp()
    end,
})
