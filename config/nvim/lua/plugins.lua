return {
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "storm",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    sidebars = "transparent",
                    floats = "transparent",
                },
                on_colors = function(colors)
                end,
                on_highlights = function(highlights, colors)
                    highlights.SignColumn = { bg = "none" }
                    highlights.LineNr = { fg = "#c0caf5" }                    -- Base line numbers
                    highlights.CursorLineNr = { fg = "#ff9e64", bold = true } -- Orange current line
                    highlights.LineNrAbove = { fg = "#c0caf5" }               -- Relative numbers above
                    highlights.LineNrBelow = { fg = "#c0caf5" }               -- Relative numbers below
                    highlights.CursorLine = { bg = colors.bg_highlight }
                    highlights.qfFileName = { fg = colors.blue, bold = true }
                    highlights.qfLineNr = { fg = colors.orange }
                end,
            })
            vim.cmd.colorscheme("tokyonight-storm")
        end
    },

    -- Treesitter for syntax highlighting and text objects
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua", "vim", "vimdoc", "query",
                    "nix",
                    "markdown", "markdown_inline",
                },
                sync_install = false,
                auto_install = true,

                highlight = {
                    enable = true,
                    -- Disable for very large files
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                },

                indent = {
                    enable = true,
                },
            })
        end
    },

    -- File manager
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                skip_confirm_for_simple_edits = true,
                view_options = {
                    show_hidden = true,
                    is_hidden_file = function(name, bufnr)
                        return vim.startswith(name, ".")
                    end,
                    is_always_hidden = function(name, bufnr)
                        return name == ".." or name == ".git"
                    end,
                },
                float = {
                    border = "rounded",
                    max_width = 80,
                    max_height = 40,
                },
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-v>"] = "actions.select_vsplit",
                    ["<C-s>"] = "actions.select_split",
                    ["<C-r>"] = "actions.refresh",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["g."] = "actions.toggle_hidden",
                },
            })

            -- Override netrw
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs_staged_enable = true,
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    follow_files = true
                },
                attach_to_untracked = true,
                current_line_blame = false,

                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    -- Hunk navigation
                    vim.keymap.set('n', ']h', function()
                        if vim.wo.diff then return ']h' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, buffer = bufnr, desc = "Next git hunk" })

                    vim.keymap.set('n', '[h', function()
                        if vim.wo.diff then return '[h' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, buffer = bufnr, desc = "Previous git hunk" })

                    -- Hunk actions
                    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
                    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
                    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
                end
            })
        end
    },
}
