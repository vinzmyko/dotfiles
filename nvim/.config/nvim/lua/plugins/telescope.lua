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

            -- Symbol finding
            {
                "<leader>fy",
                "<cmd>Telescope lsp_document_symbols symbols={'Function','Method','Constructor'}<cr>",
                desc = "Find Document Functions",
            },
            { "<leader>fY", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find Document Symbols" },

            -- LSP integration
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>",          desc = "Find Diagnostics" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = "❯ ",
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
                    find_files = { find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }, hidden = true },
                    git_files = { show_untracked = true },
                    live_grep = { additional_args = function() return { "--hidden", "--glob", "!**/.git/*" } end },
                    grep_string = { additional_args = function() return { "--hidden", "--glob", "!**/.git/*" } end },
                    buffers = {
                        sort_mru = true,
                        sort_lastused = true,
                        ignore_current_buffer = true,
                        mappings = { i = { ["<C-d>"] = actions.delete_buffer }, n = { ["dd"] = actions.delete_buffer } },
                    },

                    lsp_document_symbols = {
                        path_display = { "hidden" },
                        symbol_width = 0.85,
                        attach_mappings = function(prompt_bufnr, map)
                            local actions = require('telescope.actions')
                            local action_state = require('telescope.actions.state')

                            actions.select_default:replace(function()
                                actions.close(prompt_bufnr)
                                local entry = action_state.get_selected_entry()
                                if entry then
                                    vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col })
                                    vim.cmd("normal! zt")
                                    vim.cmd("normal! zv") -- Unfold if needed
                                end
                            end)

                            return true
                        end,
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
                extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
}
