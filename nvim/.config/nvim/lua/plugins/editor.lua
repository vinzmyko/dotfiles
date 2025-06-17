return {
    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = {
            { "<leader>E",  "<cmd>Neotree filesystem reveal right<cr>", desc = "Explorer NeoTree (reveal)" },
            { "<leader>be", "<cmd>Neotree buffers reveal float<cr>",    desc = "Buffer Explorer" },
        },
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        init = function()
            if vim.fn.argc(-1) == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = {
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            source_selector = {
                winbar = false,
                statusline = false,
            },
            popup_border_style = "rounded",
            open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                hijack_netrw_behavior = "open_current", -- Start in current buffer's directory
                filtered_items = {
                    visible = true,                     -- Show hidden files
                    hide_dotfiles = false,
                    hide_gitignored = true,             -- Hide git-ignored files (key change!)
                    hide_hidden = false,
                    never_show = {                      -- Never show these files/folders
                        ".DS_Store",
                        "thumbs.db",
                        "node_modules",
                        ".git",
                        "__pycache__",
                        ".pytest_cache",
                        ".cargo",
                        "target", -- Rust build files
                        "bin",
                        "obj",    -- C# build files
                    },
                },
                -- Git-aware root detection
                find_command = "fd", -- Use fd for better performance
                find_args = {
                    fd = {
                        "--exclude", ".git",
                        "--exclude", "node_modules",
                        "--exclude", "target",
                        "--exclude", "bin",
                        "--exclude", "obj",
                    }
                },
            },
            window = {
                position = "right",
                width = 30,
                header = {
                    text = function()
                        local current_file = vim.fn.expand('%:p')
                        if current_file == '' then
                            return vim.fn.getcwd()
                        else
                            return vim.fn.fnamemodify(current_file, ':h')
                        end
                    end,
                    align = "center",
                },
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
                mappings = {
                    ["<space>"] = "none",
                    ["Y"] = {
                        function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.setreg("+", path, "c")
                        end,
                        desc = "Copy Path to Clipboard",
                    },
                    ["O"] = {
                        function(state)
                            local path = state.tree:get_node().path
                            vim.fn.jobstart({ "xdg-open", path }, { detach = true })
                        end,
                        desc = "Open with System Application",
                    },
                    ["P"] = { "toggle_preview", config = { use_float = false } },
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                        modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                        deleted = "✖", -- this can only be used in the git_status source
                        renamed = "󰁕", -- this can only be used in the git_status source
                        -- Status type
                        untracked = "",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "",
                    },
                },
            },
        },
        config = function(_, opts)
            local function on_move(data)
                -- Simple file rename notification instead of LazyVim utility
                vim.notify(string.format("File moved: %s -> %s", data.source, data.destination))
            end

            local events = require("neo-tree.events")
            opts.event_handlers = opts.event_handlers or {}
            vim.list_extend(opts.event_handlers, {
                { event = events.FILE_MOVED,   handler = on_move },
                { event = events.FILE_RENAMED, handler = on_move },
            })
            require("neo-tree").setup(opts)
            vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { link = "TelescopeBorder" })
            vim.api.nvim_set_hl(0, "NeoTreeFloatNormal", { link = "TelescopeNormal" })
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
        end,
    },
    -- TODO comments highlighting
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        config = true,
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
            { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
        },
    },

    -- Trouble diagnostics
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
            { "<leader>xL", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous trouble/quickfix item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next trouble/quickfix item",
            },
        },
    },

    -- Session management
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = { options = vim.opt.sessionoptions:get() },
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
        },
    },

    -- Better % matching
    {
        "andymass/vim-matchup",
        event = { "BufReadPost" },
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },

    -- Smart word motions (replaces vim-camelcasemotion)
    {
        "chaoren/vim-wordmotion",
        event = "VeryLazy",
        init = function()
            vim.g.wordmotion_prefix = "<leader>"
        end,
    },
}
