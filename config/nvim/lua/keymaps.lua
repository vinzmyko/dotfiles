local map = vim.keymap.set
local project_filters = require('project-filters')

-- Window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Centre cursor
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
local function jump_to_mark_centered(mark)
    vim.cmd("normal! '" .. mark .. "zz")
end
for i = string.byte('a'), string.byte('z') do
    local mark = string.char(i)
    vim.keymap.set('n', "'" .. mark, function() jump_to_mark_centered(mark) end)
end

-- Visual mode indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Join lines while preserving cursor position
map("n", "J", "mzJ`z")

-- Diagnostic navigation
map('n', '<leader>K', vim.diagnostic.open_float)
map('n', '<leader>dr', ':DiagnosticRefresh<CR>')

-- Quickfix navigation
map('n', '<leader>dd', vim.diagnostic.setqflist, { desc = "All diagnostics to quickfix" })
map('n', '<leader>de', function()
    vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Only errors to quickfix" })
map('n', '<leader>dw', function()
    vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Only warnings to quickfix" })

map('n', '[q', ':cprev<CR>', { desc = "Previous quickfix item" })
map('n', ']q', ':cnext<CR>', { desc = "Next quickfix item" })
map('n', '<leader>qo', ':copen<CR>', { desc = "Open quickfix list" })
map('n', '<leader>qc', ':cclose<CR>', { desc = "Close quickfix list" })

-- File operations
map('n', '<leader>fs', function()
    vim.ui.input({ prompt = 'Find file: ' }, function(pattern)
        vim.cmd('echo ""')
        if not pattern or pattern == '' then return end

        -- Get project specific exclusions
        local excludes = project_filters.get_fd_excludes()
        local cmd = string.format(
            'fd --type f --hidden --exclude .git --exclude .cache --exclude .local %s %s',
            excludes,
            vim.fn.shellescape(pattern)
        )

        local handle = io.popen(cmd)
        if not handle then
            print("fd not found")
            return
        end

        local files = {}
        for file in handle:lines() do
            table.insert(files, file)
        end
        handle:close()

        if #files == 0 then
            print("No matches for: " .. pattern)
        elseif #files == 1 then
            vim.cmd('edit ' .. vim.fn.fnameescape(files[1]))
        else
            vim.ui.select(files, {
                prompt = string.format('%d matches for "%s": ', #files, pattern),
            }, function(choice)
                if choice then
                    vim.cmd('edit ' .. vim.fn.fnameescape(choice))
                end
            end)
        end
    end)
end, { desc = "Find file by name" })

-- Live grep with fd + ripgrep
map('n', '<leader>fg', function()
    vim.ui.input({ prompt = 'Grep pattern: ' }, function(pattern)
        vim.cmd('echo ""')
        if not pattern or pattern == '' then return end

        -- Get project specific exclusions
        local excludes = project_filters.get_rg_excludes()
        local cmd = string.format(
            'rg -n --no-heading --hidden -g "!.git" %s %s',
            excludes,
            vim.fn.shellescape(pattern)
        )

        local handle = io.popen(cmd)
        if not handle then
            print("ripgrep not found")
            return
        end

        local matches = {}
        local max_basename_len = 0
        local max_line_len = 0

        -- Collect matches and find max lengths
        for line in handle:lines() do
            local file, line_num, content = line:match("^([^:]+):(%d+):(.*)$")
            if file and line_num and content then
                local basename = vim.fn.fnamemodify(file, ':t')
                max_basename_len = math.max(max_basename_len, #basename)
                max_line_len = math.max(max_line_len, #line_num)

                table.insert(matches, {
                    file = file,
                    basename = basename,
                    line = tonumber(line_num),
                    line_str = line_num,
                    content = content
                })
            end
        end
        handle:close()

        if #matches == 0 then
            print("No matches found")
            return
        end

        -- Format with alignment
        for _, match in ipairs(matches) do
            -- Trim leading whitespace from content
            local content = match.content:gsub("^%s+", "")
            if #content > 70 then
                content = content:sub(1, 67) .. "..."
            end

            -- Create aligned display string with fixed column widths
            match.display = string.format(
                "%-" .. max_basename_len .. "s  %" .. max_line_len .. "s  %s",
                match.basename,
                match.line_str,
                content
            )
        end

        -- Auto-open if only one match
        if #matches == 1 then
            local match = matches[1]
            vim.cmd('edit ' .. vim.fn.fnameescape(match.file))
            vim.api.nvim_win_set_cursor(0, { match.line, 0 })
            vim.cmd('normal! zz')
            return
        end

        -- Multiple matches show selector
        vim.ui.select(matches, {
            prompt = string.format('Found %d matches for "%s":', #matches, pattern),
            format_item = function(item) return item.display end,
        }, function(choice)
            if choice then
                vim.cmd('edit ' .. vim.fn.fnameescape(choice.file))
                vim.api.nvim_win_set_cursor(0, { choice.line, 0 })
                vim.cmd('normal! zz')
            end
        end)
    end)
end, { desc = "Live grep with ripgrep" })

-- Quick config access
map('n', '<leader>rc', ':edit ~/.config/nvim/init.lua<CR>', { desc = "Edit nvim config" })

-- Enable Ctrl + Backspace word deletion
map('i', '<C-BS>', '<C-w>') -- Normal way
map('i', '<C-?>', '<C-w>')  -- Thinkpad way
map('i', '<C-h>', '<C-w>')  -- Terminal way

-- Show current file path
map('n', '<leader>fp', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    print('Copied: ' .. path)
end, { desc = "Copy full file path" })

-- LSP document symbols - filtered
map('n', '<leader>s', function()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(err, result, ctx, config)
        if err or not result or vim.tbl_isempty(result) then
            print("No symbols found")
            return
        end

        -- Symbols wanted
        local allowed_kinds = {
            [5] = true,  -- Class
            [6] = true,  -- Method
            [10] = true, -- Enum
            [11] = true, -- Interface
            [12] = true, -- Function
            [23] = true, -- Struct
        }

        -- Flatten nested symbols and filter by kind
        local function flatten_symbols(symbols, items)
            items = items or {}
            for _, symbol in ipairs(symbols) do
                if allowed_kinds[symbol.kind] then
                    table.insert(items, {
                        filename = vim.api.nvim_buf_get_name(0),
                        lnum = symbol.range.start.line + 1,
                        col = symbol.range.start.character + 1,
                        text = string.format("[%s] %s",
                            vim.lsp.protocol.SymbolKind[symbol.kind] or "Unknown",
                            symbol.name
                        )
                    })
                end
                -- Recursively process nested symbols
                if symbol.children then
                    flatten_symbols(symbol.children, items)
                end
            end
            return items
        end

        local items = flatten_symbols(result)

        if #items == 0 then
            print("No structural symbols found (functions, methods, types)")
            return
        end

        -- Set location list and open it
        vim.fn.setloclist(0, {}, ' ', {
            title = 'Symbols in ' .. vim.fn.expand('%:t'),
            items = items,
        })
        vim.cmd('lopen')
    end)
end, { desc = "Show document symbols (filtered)" })
