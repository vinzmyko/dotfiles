return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require('neo-tree').setup({
			close_if_last_window = true,
			window = {
				position = "right",
				width = 30,
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				-- Always start in the current buffer's directory
				hijack_netrw_behavior = "open_current",
			}
		})

		-- Keymap to open Neo-tree focused on current buffer's directory
		vim.keymap.set("n", "<leader>E", ":Neotree filesystem reveal right<CR>", { silent = true, desc = "Open Neo-tree sidebar" })
	end,
}
