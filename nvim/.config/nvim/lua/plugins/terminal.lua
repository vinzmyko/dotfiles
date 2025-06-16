return {
    -- Floating terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<leader>ft", function() require("toggleterm").toggle() end,                                                  desc = "Toggle Terminal" },
            { "<leader>fT", function() require("toggleterm.terminal").Terminal:new({ dir = vim.fn.getcwd() }):toggle() end, desc = "Terminal (cwd)" },
            { "<C-/>",      function() require("toggleterm").toggle() end,                                                  desc = "Toggle Terminal",  mode = { "n", "t" } },
            { "<C-_>",      function() require("toggleterm").toggle() end,                                                  desc = "which_key_ignore", mode = { "n", "t" } },
        },
        cmd = { "ToggleTerm", "TermExec" },
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<C-\>]], -- Alternative mapping
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            auto_scroll = true,
            float_opts = {
                border = "curved",
                winblend = 0,
                width = function()
                    return math.floor(vim.o.columns * 0.8)
                end,
                height = function()
                    return math.floor(vim.o.lines * 0.8)
                end,
            },
            highlights = {
                FloatBorder = { link = "FloatBorder" },
                NormalFloat = { link = "NormalFloat" },
            },
            winbar = {
                enabled = false,
                name_formatter = function(term) --  term: Terminal
                    return term.name
                end
            },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            -- Custom terminal configurations
            local Terminal = require("toggleterm.terminal").Terminal

            -- Lazygit terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                direction = "float",
                float_opts = {
                    border = "double",
                },
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
                on_close = function(term)
                    vim.cmd("startinsert!")
                end,
            })

            -- Python REPL
            local python = Terminal:new({
                cmd = "python3",
                direction = "float",
                float_opts = {
                    border = "double",
                },
            })

            -- Node REPL
            local node = Terminal:new({
                cmd = "node",
                direction = "float",
                float_opts = {
                    border = "double",
                },
            })

            -- Keybindings for custom terminals
            vim.keymap.set("n", "<leader>gl", function() lazygit:toggle() end, { desc = "LazyGit" })
            vim.keymap.set("n", "<leader>tp", function() python:toggle() end, { desc = "Python Terminal" })
            vim.keymap.set("n", "<leader>tn", function() node:toggle() end, { desc = "Node Terminal" })

            -- Terminal mode mappings
            function _G.set_terminal_keymaps()
                local opts = { buffer = 0 }
                vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
                vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
            end

            -- Apply terminal keymaps when entering terminal mode
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        end,
    },

    -- Tmux integration (since you use tmux)
    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
        end,
    },
}
