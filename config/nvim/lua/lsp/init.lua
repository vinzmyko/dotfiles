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

-- Strip snippet placeholders from completions
-- TODO: Remove this when switching to a completion plugin that handles snippets
vim.api.nvim_create_autocmd('CompleteDone', {
    group = vim.api.nvim_create_augroup("StripSnippets", { clear = true }),
    callback = function()
        local completed = vim.v.completed_item
        if completed and completed.word then
            -- Remove anything after the first (
            local clean_word = completed.word:match("^([^(]+)")
            if clean_word and clean_word ~= completed.word then
                local pos = vim.api.nvim_win_get_cursor(0)
                local line = vim.api.nvim_get_current_line()
                vim.api.nvim_set_current_line(
                    line:sub(1, pos[2] - #completed.word + #clean_word) .. line:sub(pos[2] + 1)
                )
                vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - #completed.word + #clean_word })
            end
        end
    end,
})

-- Command for when diagnostics get stuck
vim.api.nvim_create_user_command('DiagnosticRefresh', function()
    vim.diagnostic.reset() -- Clear all diagnostic cache
    vim.lsp.buf_request(0, 'textDocument/diagnostic', {
        textDocument = vim.lsp.util.make_text_document_params()
    })
    print("Diagnostics refreshed")
end, { desc = 'Force refresh diagnostics' })

-- LSP attach keymaps and omnifunc setup
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Disable semantic tokens to test if they're causing issues
        if client then
            client.server_capabilities.semanticTokensProvider = nil
        end

        local opts = { buffer = ev.buf }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)

        vim.keymap.set('n', '<leader>cf', function()
            vim.lsp.buf.format { async = true }
        end, opts)

        -- Rounded floating windows
        vim.keymap.set('n', 'K', function()
            vim.lsp.buf.hover({
                border = "rounded",
            })
        end, opts)
        vim.keymap.set('i', '<C-k>', function()
            vim.lsp.buf.signature_help({ border = "rounded" })
        end, opts)

        -- Enable omnifunc completion
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end,
})

-- Utility Commands

-- Show LSP info
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

-- Restart LSP
vim.api.nvim_create_user_command('LspRestart', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        print("No LSP clients attached to current buffer")
        return
    end

    for _, client in ipairs(clients) do
        print("Restarting LSP: " .. client.name)
        vim.lsp.stop_client(client.id)
    end

    vim.cmd('doautocmd FileType')
end, { desc = 'Restart LSP clients' })

require("lsp.lua")
require("lsp.nix")
require("lsp.rust")
require("lsp.go")
require("lsp.python")
require("lsp.gdscript")
require("lsp.html")
require("lsp.css")
require("lsp.toml")

return M
