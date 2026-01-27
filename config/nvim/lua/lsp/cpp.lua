local lsp_utils = require('lsp')

local function setup_cpp_lsp()
    if vim.fn.executable('clangd') == 0 then
        return
    end

    -- Build clangd command
    local clangd_cmd = { 'clangd', '--background-index' }

    -- NixOS needs a glob pattern to find compilers in /nix/store
    if vim.fn.isdirectory('/nix/store') == 1 then
        table.insert(clangd_cmd, '--query-driver=/nix/store/*/bin/*')
    else
        -- Non-NixOS: use CXX env var or default
        local cxx = vim.fn.getenv('CXX')
        if cxx == vim.NIL or cxx == '' then
            cxx = 'clang++'
        end
        table.insert(clangd_cmd, '--query-driver=' .. cxx)
    end

    vim.lsp.start({
        name = 'clangd',
        cmd = clangd_cmd,
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        root_dir = lsp_utils.find_root({
            'compile_commands.json',
            'compile_flags.txt',
            '.clangd',
            '.git',
            'CMakeLists.txt',
            'Makefile'
        }),
        capabilities = {
            offsetEncoding = { "utf-16" },
        },
        on_attach = function(client, bufnr)
            local opts = { buffer = bufnr }
            vim.keymap.set('n', '<leader>ch', ':ClangdSwitchSourceHeader<CR>',
                vim.tbl_extend('force', opts, { desc = "Switch header/source" }))
        end,
    })
end

local function setup_cmake_lsp()
    if vim.fn.executable('cmake-language-server') == 0 then
        return
    end

    vim.lsp.start({
        name = 'cmake',
        cmd = { 'cmake-language-server' },
        filetypes = { 'cmake' },
        root_dir = lsp_utils.find_root({ 'CMakeLists.txt', '.git' }),
        init_options = {
            buildDirectory = "build"
        }
    })
end

-- C/C++ setup
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspCpp", { clear = true }),
    pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
        setup_cpp_lsp()
    end,
})

-- CMake setup
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspCMake", { clear = true }),
    pattern = "cmake",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
        setup_cmake_lsp()
    end,
})
