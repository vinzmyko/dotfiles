return {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    init = function()
        -- Disable default mappings, set in keymaps.lua
        vim.g.tmux_navigator_no_mappings = 1

        vim.g.tmux_navigator_disable_when_zoomed = 1 -- Disable when tmux pane is zoomed
    end,
}
