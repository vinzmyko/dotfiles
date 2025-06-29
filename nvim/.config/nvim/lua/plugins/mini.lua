return {
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {
            modes = { insert = true, command = false, terminal = false },
            -- skip autopair when next character is one of these
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            -- skip autopair when the cursor is inside these treesitter nodes
            skip_ts = { "string" },
            -- skip autopair when next character is closing pair and there are more closing pairs than opening pairs
            skip_unbalanced = true,
            -- better deal with markdown code blocks
            markdown = true,
        },
        config = function(_, opts)
            require("mini.pairs").setup(opts)

            -- Rust-specific autopair configuration
            local rust_group = vim.api.nvim_create_augroup("Rust_autopairs", { clear = true })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "rust",
                group = rust_group,
                callback = function()
                    -- Disable single quote pairing in Rust (for lifetimes like &'a)
                    vim.keymap.set("i", "'", "'", {
                        buffer = true,
                        desc = "Insert single quote without pairing for Rust lifetimes"
                    })

                    -- Add angle bracket pairs for Rust generics using mini.pairs API
                    local MiniPairs = require("mini.pairs")

                    -- Map < to open angle bracket pair
                    MiniPairs.map_buf(0, "i", "<", {
                        action = "open",
                        pair = "<>",
                        neigh_pattern = "[^\\]."
                    })

                    -- Map > to close angle bracket pair
                    MiniPairs.map_buf(0, "i", ">", {
                        action = "close",
                        pair = "<>",
                        neigh_pattern = "[^\\]."
                    })
                end,
                desc = "Configure mini.pairs for Rust",
            })

            -- Handle lazy loading case - ensure config applies even if mini.pairs loads late
            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyLoad",
                group = rust_group,
                callback = function(event)
                    if event.data == "mini.pairs" then
                        -- Re-trigger FileType autocmd for any open Rust buffers
                        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "rust" then
                                -- Manually apply the configuration for this buffer
                                vim.api.nvim_buf_call(buf, function()
                                    -- Disable single quote pairing in Rust (for lifetimes like &'a)
                                    vim.keymap.set("i", "'", "'", {
                                        buffer = true,
                                        desc = "Insert single quote without pairing for Rust lifetimes"
                                    })

                                    -- Add angle bracket pairs for Rust generics using mini.pairs API
                                    local MiniPairs = require("mini.pairs")

                                    -- Map < to open angle bracket pair
                                    MiniPairs.map_buf(0, "i", "<", {
                                        action = "open",
                                        pair = "<>",
                                        neigh_pattern = "[^\\]."
                                    })

                                    -- Map > to close angle bracket pair
                                    MiniPairs.map_buf(0, "i", ">", {
                                        action = "close",
                                        pair = "<>",
                                        neigh_pattern = "[^\\]."
                                    })
                                end)
                            end
                        end
                    end
                end,
                desc = "Handle mini.pairs lazy loading for Rust",
            })
        end,
    },

    -- Text objects
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                    d = { "%f[%d]%d+" }, -- digits
                    e = {                -- Word with case
                        {
                            "%u[%l%d]+%f[^%l%d]",
                            "%f[%S][%l%d]+%f[^%l%d]",
                            "%f[%P][%l%d]+%f[^%l%d]",
                            "^[%l%d]+%f[^%l%d]",
                        },
                        "^().*()$",
                    },
                    u = ai.gen_spec.function_call(),                           -- u for "Usage"
                    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
        end,
    },

    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        opts = {
            mappings = {
                add = "gsa",            -- Add surrounding in Normal and Visual modes
                delete = "gsd",         -- Delete surrounding
                find = "gsf",           -- Find surrounding (to the right)
                find_left = "gsF",      -- Find surrounding (to the left)
                highlight = "gsh",      -- Highlight surrounding
                replace = "gsr",        -- Replace surrounding
                update_n_lines = "gsn", -- Update `n_lines`

                suffix_last = "l",      -- Suffix to search with "prev" method
                suffix_next = "n",      -- Suffix to search with "next" method
            },
        },
        config = function(_, opts)
            require("mini.surround").setup(opts)
        end,
    },

    -- Comment functionality
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo
                        .commentstring
                end,
            },
        },
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                lazy = true,
                opts = {
                    enable_autocmd = false,
                },
            },
        },
    },

    -- Highlight patterns (useful for TODO comments and more)
    {
        "echasnovski/mini.hipatterns",
        event = "VeryLazy",
        opts = function()
            local hi = require("mini.hipatterns")
            return {
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                    -- Highlight hex color strings (`#rrggbb`) with that color
                    hex_color = hi.gen_highlighter.hex_color(),
                },
            }
        end,
    },

    -- Move lines/blocks (alternative to your Primeagen mappings)
    {
        "echasnovski/mini.move",
        event = "VeryLazy",
        opts = {
            mappings = {
                -- Move visual selection in Visual mode. Defaults are Alt + hjkl.
                left = "<M-h>",
                right = "<M-l>",
                down = "<M-j>",
                up = "<M-k>",

                -- Move current line in Normal mode
                line_left = "<M-h>",
                line_right = "<M-l>",
                line_down = "<M-j>",
                line_up = "<M-k>",
            },
        },
        config = function(_, opts)
            require("mini.move").setup(opts)

            -- We'll keep your Primeagen-style J/K mappings in keymaps.lua
            -- This gives you both options: Alt+jk for mini.move, J/K for your style
        end,
    },
}
