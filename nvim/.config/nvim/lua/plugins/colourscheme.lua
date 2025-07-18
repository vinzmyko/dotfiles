return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",     -- storm, moon, night, day
            transparent = false, -- Enable if you want transparent background
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                functions = {},
                variables = {},
                sidebars = "dark",                   -- style for sidebars, see below
                floats = "dark",                     -- style for floating windows
            },
            sidebars = { "qf", "help", "neo-tree" }, -- Set a darker background on sidebar-like windows
            day_brightness = 0.3,                    -- Adjusts the brightness of the colors of the Day style
            hide_inactive_statusline = false,        -- Enabling this option will hide inactive statuslines
            dim_inactive = false,                    -- dims inactive windows
            lualine_bold = false,                    -- When true, section headers in the lualine theme will be bold

            on_colors = function(colors)
                -- Customize colors if needed
            end,

            on_highlights = function(highlights, colors)
                -- Customize highlights if needed
                -- Example: highlights.Comment = { fg = colors.comment, italic = true }

                highlights.TelescopeSelectionCaret = {
                    fg = colors.orange, -- Use tokyonight's orange
                    bold = true
                }

                highlights.TelescopeSelection = {
                    fg = colors.fg,
                    bg = colors.bg_highlight,
                    bold = true
                }

                highlights.TelescopeMatching = {
                    fg = colors.blue,
                    bold = true
                }

                highlights.TelescopePromptPrefix = {
                    fg = colors.purple
                }

                highlights.NeoTreeFloatBorder = {
                    fg = colors.blue1,
                    bg = colors.none
                }

                highlights.NeoTreeFloatNormal = {
                    bg = colors.bg_float,
                    fg = colors.fg
                }
            end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight")
        end,
    },
}
