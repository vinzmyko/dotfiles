return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        cmd = "Telescope",
        keys = {
            { "<C-p>",      "<cmd>Telescope git_files<cr>",                                desc = "Find Git Files" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>",                               desc = "Find All Files" },
            { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Find Buffers" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                 desc = "Find Recent Files" },

            -- Search functionality
            { "<leader>fs", "<cmd>Telescope live_grep<cr>",                                desc = "Live Grep (Git Files)" },
            { "<leader>fw", "<cmd>Telescope grep_string<cr>",                              desc = "Find Word Under Cursor" },

            -- Help and utility
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",                                desc = "Find Help" },
            { "<leader>fc", "<cmd>Telescope commands<cr>",                                 desc = "Find Commands" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>",                                  desc = "Find Keymaps" },

            -- LSP integration
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>",                              desc = "Find Diagnostics" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = "❯ ",
                    get_selection_window = function()
                        local wins = vim.api.nvim_list_wins()
                        table.insert(wins, 1, vim.api.nvim_get_current_win())
                        for _, win in ipairs(wins) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].buftype == "" then
                                return win
                            end
                        end
                        return 0
                    end,
                    mappings = {
                        i = {
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                        },
                        n = {
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["q"] = actions.close,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                        hidden = true,
                    },
                    git_files = {
                        show_untracked = true,
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden", "--glob", "!**/.git/*" }
                        end,
                    },
                    grep_string = {
                        additional_args = function()
                            return { "--hidden", "--glob", "!**/.git/*" }
                        end,
                    },
                    buffers = {
                        sort_mru = true,
                        sort_lastused = true,
                        ignore_current_buffer = true,
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer,
                            },
                            n = {
                                ["dd"] = actions.delete_buffer,
                            },
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            -- Load extensions
            pcall(telescope.load_extension, "fzf")
        end,
    },

    -- UI Select integration
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
}
