return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")

			-- Find the project root directory using git or current working directory
			local function get_project_root()
				-- Try to find git root first
				local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
				if git_root and vim.v.shell_error == 0 then
					return git_root
				end

				-- Fallback to current working directory if not in git repo
				return vim.fn.getcwd()
			end

			-- Always search from project root with Ctrl+P
			vim.keymap.set("n", "<C-p>", function()
				builtin.find_files({
					cwd = get_project_root(),
				})
			end, { desc = "Find files from project root" })

			-- Additional option to search in current buffer's directory if needed
			vim.keymap.set("n", "<leader>fc", function()
				builtin.find_files({
					cwd = vim.fn.expand("%:p:h"),
					search_dirs = { vim.fn.expand("%:p:h") },
				})
			end, { desc = "Find files in current buffer's directory" })

			-- Live grep configuration (also from project root)
			vim.keymap.set("n", "<leader>fg", function()
				builtin.live_grep({
					cwd = get_project_root(),
				})
			end, { desc = "Live grep from project root" })

			-- Keep the global find files option
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files globally" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
