local M = {}

-- Find project root
function M.find_root(patterns)
    local path = vim.fn.expand('%:p:h')
    local root = vim.fs.find(patterns, { path = path, upward = true })[1]
    return root and vim.fn.fnamemodify(root, ':h') or path
end

package.loaded['lsp'] = M

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = { prefix = '●' },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "i",
            [vim.diagnostic.severity.HINT] = "h",
        }
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded" }
})

-- LSP attach keymaps and omnifunc setup
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)

        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>cf', function()
            vim.lsp.buf.format { async = true }
        end, opts)

        -- Rounded floating windows
        vim.keymap.set('n', 'K', function()
            vim.lsp.buf.hover({
                border = "rounded",
            })
        end, opts)
        vim.keymap.set('i', '<C-p>', function()
            vim.lsp.buf.signature_help({ border = "rounded" })
        end, opts)

        -- Enable omnifunc completion
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end,
})

-- Utility command to show LSP info
vim.api.nvim_create_user_command('LspInfo', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        print("No LSP clients attached to current buffer")
    else
        for _, client in ipairs(clients) do
            print("LSP: " .. client.name .. " (ID: " .. client.id .. ")")
        end
    end
end, { desc = 'Show LSP client info' })

require("lsp.lua")
require("lsp.nix")
require("lsp.rust")
require("lsp.python")

return M
