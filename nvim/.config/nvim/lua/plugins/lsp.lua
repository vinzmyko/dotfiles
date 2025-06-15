return {
    -- Mason - LSP installer
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {
                -- Primary languages
                "rust-analyzer",
                "omnisharp", -- C#
                "yaml-language-server",
                "dockerfile-language-server",

                -- Secondary languages
                "gopls", -- Go
                "html-lsp",
                "typescript-language-server",
                "css-lsp",

                -- Formatters
                "rustfmt",
                "prettier",
                "yamlfmt",

                -- Linters
                "eslint_d",
                "yamllint",
            },
        },
    },

    -- Mason-lspconfig bridge
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function() end, -- Disable automatic setup like LazyVim does
    },

    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
            "mason-lspconfig.nvim",
            {
                "folke/neodev.nvim",
                opts = {},
            },
        },
        config = function()
            -- Set up capabilities for completion
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            -- Custom LSP keybindings (your hybrid approach)
            local on_attach = function(client, bufnr)
                local map = vim.keymap.set
                local opts = { buffer = bufnr, silent = true }

                -- Your preferred LSP bindings
                map("n", "<leader>k", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: Hover" }))
                map("n", "<leader>K", vim.diagnostic.open_float,
                    vim.tbl_extend("force", opts, { desc = "LSP: Diagnostics" }))
                map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: Go to Definition" }))
                map("n", "<leader>gr", vim.lsp.buf.references,
                    vim.tbl_extend("force", opts, { desc = "LSP: References" }))
                map("n", "<leader>gi", vim.lsp.buf.implementation,
                    vim.tbl_extend("force", opts, { desc = "LSP: Implementation" }))
                map("n", "<leader>gt", vim.lsp.buf.type_definition,
                    vim.tbl_extend("force", opts, { desc = "LSP: Type Definition" }))
                map("n", "<leader>.", vim.lsp.buf.code_action,
                    vim.tbl_extend("force", opts, { desc = "LSP: Code Action" }))
                map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: Rename" }))

                -- Enhanced diagnostic navigation
                map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
                map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Prev Diagnostic" }))
                map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
                    vim.tbl_extend("force", opts, { desc = "Next Error" }))
                map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
                    vim.tbl_extend("force", opts, { desc = "Prev Error" }))
                map("n", "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end,
                    vim.tbl_extend("force", opts, { desc = "Next Warning" }))
                map("n", "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end,
                    vim.tbl_extend("force", opts, { desc = "Prev Warning" }))
            end

            -- Manual setup for each server (no mason-lspconfig automatic handlers)
            local lspconfig = require("lspconfig")

            -- Setup servers individually
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = { checkThirdParty = false },
                            completion = { callSnippet = "Replace" },
                            diagnostics = { globals = { "vim" } },
                        },
                    },
                },
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true },
                            checkOnSave = true,     -- Just enable it
                            check = {
                                command = "clippy", -- Put clippy command here instead
                            },
                            procMacro = { enable = true },
                        },
                    },
                },
                omnisharp = {
                    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
                },
                yamlls = {
                    settings = {
                        yaml = {
                            keyOrdering = false,
                            schemas = {
                                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                                ["https://json.schemastore.org/docker-compose.yml"] = "docker-compose*.yml",
                            },
                        },
                    },
                },
                dockerls = {
                    settings = {
                        docker = {
                            languageserver = {
                                formatter = { ignoreMultilineInstructions = true },
                            },
                        },
                    },
                },
                gopls = {},
                html = {},
                ts_ls = {}, -- Updated from tsserver
                cssls = {},
            }

            -- Setup each server
            for server_name, server_config in pairs(servers) do
                local config = vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }, server_config)

                lspconfig[server_name].setup(config)
            end

            -- Global diagnostic configuration
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "E",
                        [vim.diagnostic.severity.WARN] = "W",
                        [vim.diagnostic.severity.HINT] = "H",
                        [vim.diagnostic.severity.INFO] = "I",
                    },
                },
            })
        end,
    },

    -- Completion (same as before)
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            return {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = function(_, item)
                        local icons = require("config.icons").kinds
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                        end
                        return item
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
            }
        end,
    },

    -- Function signatures while typing
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            bind = true,
            handler_opts = {
                border = "rounded",
            },
        },
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },
}
