return {
    "easymotion/vim-easymotion",
    config = function()
        -- Store diagnostics and handlers
        local saved_diagnostics = {}
        local original_handlers = {}
        local saved_config = nil

        vim.api.nvim_create_augroup("EasyMotionDiagnostics", { clear = true })

        -- Function to completely disable diagnostics
        local function disable_all_diagnostics()
            -- Save and clear diagnostics for all buffers
            saved_diagnostics = {}
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(bufnr) then
                    saved_diagnostics[bufnr] = {}
                    local namespaces = vim.diagnostic.get_namespaces()
                    for ns_id, _ in pairs(namespaces) do
                        saved_diagnostics[bufnr][ns_id] = vim.diagnostic.get(bufnr, { namespace = ns_id })
                        vim.diagnostic.set(ns_id, bufnr, {})
                    end
                end
            end

            -- Save current config
            saved_config = vim.diagnostic.config()

            -- Disable all visual diagnostics
            vim.diagnostic.config({
                virtual_text = false,
                signs = false,
                underline = false,
                update_in_insert = false,
            })

            -- Override ALL diagnostic-related handlers
            original_handlers = {
                publishDiagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"],
                diagnostic = vim.lsp.handlers["textDocument/diagnostic"],
                diagnosticWorkspace = vim.lsp.handlers["workspace/diagnostic"],
            }

            -- Replace with no-op functions
            vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
            vim.lsp.handlers["textDocument/diagnostic"] = function() end
            vim.lsp.handlers["workspace/diagnostic"] = function() end
        end

        -- Function to restore diagnostics
        local function restore_all_diagnostics()
            -- Restore handlers
            for name, handler in pairs(original_handlers) do
                if name == "publishDiagnostics" then
                    vim.lsp.handlers["textDocument/publishDiagnostics"] = handler
                elseif name == "diagnostic" then
                    vim.lsp.handlers["textDocument/diagnostic"] = handler
                elseif name == "diagnosticWorkspace" then
                    vim.lsp.handlers["workspace/diagnostic"] = handler
                end
            end

            -- Restore config
            if saved_config then
                vim.diagnostic.config(saved_config)
            end

            -- Restore diagnostics
            for bufnr, namespaces in pairs(saved_diagnostics) do
                if vim.api.nvim_buf_is_valid(bufnr) then
                    for ns_id, diagnostics in pairs(namespaces) do
                        vim.diagnostic.set(ns_id, bufnr, diagnostics)
                    end
                end
            end

            saved_diagnostics = {}
        end

        -- Intercept easymotion commands BEFORE they execute
        local unction wrap_easymotion_command(cmd)
            return function()
                disable_all_diagnostics()
                -- Execute the command after disabling diagnostics
                vim.schedule(function()
                    vim.cmd(cmd)
                end)
            end
        end

        -- Set up autocmds for additional safety
        vim.api.nvim_create_autocmd("User", {
            pattern = "EasyMotionPromptBegin",
            group = "EasyMotionDiagnostics",
            callback = disable_all_diagnostics,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "EasyMotionPromptEnd",
            group = "EasyMotionDiagnostics",
            callback = function()
                vim.defer_fn(restore_all_diagnostics, 100)
            end,
        })

        -- Override common easymotion mappings to disable diagnostics first
        vim.api.nvim_create_autocmd("VimEnter", {
            group = "EasyMotionDiagnostics",
            callback = function()
                -- Wait a bit to ensure easymotion mappings are set
                vim.defer_fn(function()
                    -- Get common easymotion mappings and wrap them
                    local mappings = {
                        "<leader><leader>w",
                        "<leader><leader>b",
                        "<leader><leader>s",
                        "<leader><leader>f",
                        "<leader><leader>F",
                        "<leader><leader>t",
                        "<leader><leader>T",
                        "<leader><leader>j",
                        "<leader><leader>k",
                    }

                    for _, mapping in ipairs(mappings) do
                        local original = vim.fn.maparg(mapping, "n", false, true)
                        if original and original.rhs and original.rhs:match("EasyMotion") then
                            vim.keymap.set("n", mapping, function()
                                disable_all_diagnostics()
                                vim.schedule(function()
                                    vim.api.nvim_feedkeys(
                                        vim.api.nvim_replace_termcodes(original.rhs, true, true, true),
                                        "m",
                                        false
                                    )
                                end)
                            end, { silent = true })
                        end
                    end
                end, 100)
            end,
        })

        vim.g.EasyMotion_leader_key = "<leader><leader>"
        vim.g.EasyMotion_do_mapping = 1
        vim.g.EasyMotion_smartcase = 1
        vim.g.EasyMotion_enter_jump_first = 1

        -- Add a command to manually clear diagnostics if needed
        vim.api.nvim_create_user_command("DiagnosticsClear", disable_all_diagnostics, {})
        vim.api.nvim_create_user_command("DiagnosticsRestore", restore_all_diagnostics, {})
    end,
}
