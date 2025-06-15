return {
    -- Formatting
    {
        "stevearc/conform.nvim",
        lazy = true,
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                -- Primary languages
                rust = { "rustfmt" },
                cs = { "csharpier" },
                yaml = { "yamlfmt" },
                dockerfile = { "dockerfile_format" },

                -- Secondary languages
                go = { "goimports", "gofmt" },
                javascript = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                javascriptreact = { { "prettierd", "prettier" } },
                typescriptreact = { { "prettierd", "prettier" } },
                html = { { "prettierd", "prettier" } },
                css = { { "prettierd", "prettier" } },
                json = { { "prettierd", "prettier" } },

                -- Config files
                lua = { "stylua" },
                markdown = { { "prettierd", "prettier" } },

                -- Use the "*" filetype to run formatters on all filetypes.
                ["*"] = { "codespell" },
                -- Use the "_" filetype to run formatters on filetypes that don't
                -- have other formatters configured.
                ["_"] = { "trim_whitespace" },
            },
            -- Set default options
            default_format_opts = {
                lsp_format = "fallback",
            },
            -- Set up format-on-save (optional, you wanted manual)
            format_on_save = false,
            -- Customize formatters
            formatters = {
                shfmt = {
                    prepend_args = { "-i", "2" },
                },
            },
        },
        init = function()
            -- If you want to format on save, uncomment this:
            -- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },

    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                -- Primary languages (most handled by LSP)
                rust = {}, -- clippy via rust-analyzer
                cs = {},   -- handled by omnisharp
                yaml = {},
                dockerfile = { "hadolint" },

                -- Secondary languages
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },

                -- Config files
                markdown = { "markdownlint" },
            }

            -- Create autocommand which carries out the actual linting
            -- on the specified events.
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    -- Only run linter if the buffer is modifiable and not a special buffer
                    if vim.opt_local.modifiable:get() and vim.api.nvim_buf_get_name(0) ~= "" then
                        lint.try_lint()
                    end
                end,
            })

            -- Manual lint command
            vim.keymap.set("n", "<leader>cl", function()
                lint.try_lint()
            end, { desc = "Trigger linting for current file" })
        end,
    },
}
