return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({})
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            -- Add error handling wrapper
            local function safe_setup(server, config)
                local success, err = pcall(function()
                    lspconfig[server].setup(config)
                end)
                if not success then
                    vim.notify("Failed to setup " .. server .. ": " .. err, vim.log.levels.ERROR)
                end
            end

            safe_setup("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                        completion = {
                            callSnippet = "Replace"
                        },
                    },
                },
            })

            safe_setup("rust_analyzer", {
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "check", -- More stable than clippy
                        },
                        diagnostics = {
                            disabled = {"unresolved-proc-macro"}, -- Major crash source
                        },
                    },
                },
            })

            safe_setup("pylsp", {
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            jedi_definition = {
                                enabled = false, -- This is causing the NoneType - 'int' error
                            },
                            jedi_hover = {
                                enabled = true,
                            },
                            jedi_completion = {
                                enabled = true,
                            },
                        },
                    }
                },
                flags = {
                    debounce_text_changes = 200,
                },
            })

            -- Keep your existing keymaps (they're fine)
            vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<leader>K", vim.diagnostic.open_float, {})
            vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, {})
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })
        end,
    },
}
