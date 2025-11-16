local lsp_utils = require('lsp')

local function setup_python_lsp()
    if vim.fn.executable('pyright-langserver') == 1 then
        vim.lsp.start({
            name = 'pyright',
            cmd = { 'pyright-langserver', '--stdio' },
            filetypes = { 'python' },
            root_dir = lsp_utils.find_root({
                'pyproject.toml',
                'setup.py',
                'setup.cfg',
                'requirements.txt',
                'Pipfile',
                '.git'
            }),
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = 'workspace',
                        typeCheckingMode = 'basic',
                    },
                },
            },
        })
    elseif vim.fn.executable('pylsp') == 1 then
        vim.lsp.start({
            name = 'pylsp',
            cmd = { 'pylsp' },
            filetypes = { 'python' },
            root_dir = lsp_utils.find_root({
                'pyproject.toml',
                'setup.py',
                'setup.cfg',
                'requirements.txt',
                'Pipfile',
                '.git'
            }),
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = { enabled = true, maxLineLength = 88 },
                        pyflakes = { enabled = true },
                        pylint = { enabled = false },
                        black = { enabled = true },
                        isort = { enabled = true },
                        mypy = { enabled = false },
                    },
                },
            },
        })
    end
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspPython", { clear = true }),
    pattern = "python",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
        vim.opt_local.textwidth = 88

        setup_python_lsp()
    end,
})
