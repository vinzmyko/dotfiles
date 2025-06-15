require("lazy").setup({
    spec = {
        -- Import all plugin configurations
        { import = "plugins" },
    },
    defaults = {
        -- Plugins will be lazy-loaded by default
        lazy = false,
        -- Always use latest git commit
        version = false,
    },
    install = {
        colorscheme = { "tokyonight", "habamax" }
    },
    checker = {
        enabled = true, -- Check for plugin updates
        notify = false, -- Don't notify about updates
    },
    change_detection = {
        enabled = true,
        notify = false, -- Don't notify about config changes
    },
    performance = {
        rtp = {
            -- Disable some rtp plugins for faster startup
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- Load keymaps and autocmds after plugins
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("config.autocmds")
        require("config.keymaps")
    end,
})
