local M = {}

M.expansions = {
    ["date"] = function()
        return vim.fn.strftime("%d/%m/%Y")
    end,

    ["time"] = function()
        return vim.fn.strftime("%H:%M")
    end,

    ["check"] = function()
        return "✅"
    end,

    ["x"] = function()
        return "❌"
    end,

    ["star"] = function()
        return "⭐"
    end,

    ["arrow"] = function()
        return "→"
    end,
}

-- Function to expand a trigger and handle the colon removal
M.expand = function(trigger)
    local expansion = M.expansions[trigger]
    if expansion and type(expansion) == "function" then
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]

        if col > 0 and line:sub(col, col) == ':' then
            -- Remove the colon by moving cursor back and deleting it
            vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col - 1 })
            vim.api.nvim_del_current_line()
            vim.api.nvim_put({ line:sub(1, col - 1) .. expansion() .. line:sub(col + 1) }, 'l', false, true)
            -- Set cursor after the expansion
            vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], col - 1 + #expansion() })
            return ""
        end

        return expansion()
    else
        return trigger -- fallback to the trigger itself
    end
end

M.setup = function()
    -- Create an autocmd that triggers on text change in insert mode
    vim.api.nvim_create_autocmd("TextChangedI", {
        callback = function()
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]

            -- Look for :word pattern before cursor
            local before_cursor = line:sub(1, col)
            local pattern = before_cursor:match(":(%w+)$")

            if pattern and M.expansions[pattern] then
                local expansion = M.expansions[pattern]()

                -- Calculate start position (including the colon)
                local start_col = col - #pattern - 1 -- -1 for the colon

                -- Replace the :pattern with expansion
                local new_line = line:sub(1, start_col) .. expansion .. line:sub(col + 1)

                -- Update the line
                vim.api.nvim_set_current_line(new_line)

                -- Set cursor after the expansion
                vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], start_col + #expansion })
            end
        end,
        desc = "Text expansions on :pattern"
    })
end

-- Simple expansion function for fallback abbreviations
M.expand_simple = function(trigger)
    local expansion = M.expansions[trigger]
    if expansion and type(expansion) == "function" then
        return expansion()
    else
        return trigger
    end
end

return M
