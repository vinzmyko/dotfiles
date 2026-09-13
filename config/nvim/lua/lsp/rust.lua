local lsp_utils = require('lsp')

vim.filetype.add({
    extension = {
        ron = 'ron',
        rhai = 'rhai',
    },
})

local function find_rust_workspace_root()
    local path = vim.fn.expand('%:p:h')
    local candidates = vim.fs.find('Cargo.toml', { path = path, upward = true, limit = math.huge })

    -- Prefer the outermost Cargo.toml that declares [workspace]
    for i = #candidates, 1, -1 do
        local content = table.concat(vim.fn.readfile(candidates[i]), '\n')
        if content:match('%[workspace%]') then
            return vim.fn.fnamemodify(candidates[i], ':h')
        end
    end

    -- Fallback: nearest Cargo.toml, or .git
    return lsp_utils.find_root({ 'Cargo.toml', '.git' })
end

local function setup_rust_lsp()
    if vim.fn.executable('rust-analyzer') == 0 then
        return
    end

    vim.lsp.start({
        name = 'rust_analyzer',
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_dir = find_rust_workspace_root(),
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

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("UserRustDiagnosticRefresh", { clear = true }),
    pattern = "*.rs",
    callback = function()
        vim.cmd('DiagnosticRefresh')
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserFormatRon", { clear = true }),
    pattern = "ron",
    callback = function()
        vim.keymap.set('n', '<leader>cf', function()
            require('ron-formatter').format_buffer()
        end, { buffer = true, desc = "Format RON" })
    end,
})
