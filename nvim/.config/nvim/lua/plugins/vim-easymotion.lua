return {
	"easymotion/vim-easymotion",
	config = function()
		local diagnostic_state = true

		vim.api.nvim_create_augroup("EasyMotionDiagnostics", { clear = true })

		vim.api.nvim_create_autocmd("User", {
			pattern = "EasyMotionPromptBegin",
			group = "EasyMotionDiagnostics",
			callback = function()
				diagnostic_state = vim.diagnostic.is_enabled()
				vim.diagnostic.enable(false)
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "EasyMotionPromptEnd",
			group = "EasyMotionDiagnostics",
			callback = function()
				vim.defer_fn(function()
					if diagnostic_state then
						vim.diagnostic.enable(true)
					end
				end, 100)
			end,
		})

		vim.g.EasyMotion_leader_key = "<leader><leader>"
		vim.g.EasyMotion_do_mapping = 1
		vim.g.EasyMotion_smartcase = 1
		vim.g.EasyMotion_enter_jump_first = 1
	end,
}
