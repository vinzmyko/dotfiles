return {
	"bkad/CamelCaseMotion",
	config = function()
		vim.g.camelcasemotion_key = "<leader>"

		vim.keymap.set({ "n", "x", "o" }, "<leader>w", "<Plug>CamelCaseMotion_w", { silent = true })
		vim.keymap.set({ "n", "x", "o" }, "<leader>b", "<Plug>CamelCaseMotion_b", { silent = true })
		vim.keymap.set({ "n", "x", "o" }, "<leader>e", "<Plug>CamelCaseMotion_e", { silent = true })
	end,
}
