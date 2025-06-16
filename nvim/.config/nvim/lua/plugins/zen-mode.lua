return {
    -- Zen mode for focused writing
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = {
            { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
        },
        opts = {
            window = {
                backdrop = 0.95,            -- shade the backdrop of the Zen window
                width = 110,                -- width of the Zen window
                height = 1,                 -- height of the Zen window
                options = {
                    signcolumn = "no",      -- disable signcolumn
                    number = false,         -- disable number column
                    relativenumber = false, -- disable relative numbers
                    cursorline = false,     -- disable cursorline
                    cursorcolumn = false,   -- disable cursor column
                    foldcolumn = "0",       -- disable fold column
                    list = false,           -- disable whitespace characters
                },
            },
            plugins = {
                options = {
                    enabled = true,
                    ruler = false,              -- disables the ruler text in the cmd line area
                    showcmd = false,            -- disables the command in the last line of the screen
                    laststatus = 0,             -- turn off the statusline in zen mode
                },
                twilight = { enabled = true },  -- enable twilight (ataraxia)
                gitsigns = { enabled = false }, -- disables git signs
                tmux = { enabled = false },     -- disables the tmux statusline
                kitty = {
                    enabled = false,
                    font = "+4", -- font size increment
                },
                alacritty = {
                    enabled = false,
                    font = "14", -- font size
                },
                wezterm = {
                    enabled = false,
                    font = "+4", -- (10% increase per step)
                },
            },
            on_open = function(win)
                -- Additional setup for writing mode
                vim.opt_local.spell = true
                vim.opt_local.spelllang = "en_gb"
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true
            end,
            on_close = function()
                -- Cleanup when exiting zen mode
                vim.opt_local.spell = false
                vim.opt_local.wrap = false
                vim.opt_local.linebreak = false
            end,
        },
    },

    -- Twilight - dims inactive portions of code
    {
        "folke/twilight.nvim",
        cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
        opts = {
            dimming = {
                alpha = 0.25,        -- amount of dimming
                color = { "Normal", "#ffffff" },
                term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
                inactive = false,    -- when true, other windows will be fully dimmed (unless they contain the same buffer)
            },
            context = 10,            -- amount of lines we will try to show around the current line
            treesitter = true,       -- use treesitter when available for the filetype
            exclude = {},            -- exclude these filetypes
        },
    },
}
