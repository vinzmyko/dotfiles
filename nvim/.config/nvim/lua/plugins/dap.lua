return {
    -- Debug Adapter Protocol
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "nvim-neotest/nvim-nio",
            },
            -- UI for DAP
            {
                "rcarriga/nvim-dap-ui",
                opts = {},
                config = function(_, opts)
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open()
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close()
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close()
                    end
                end,
            },
            -- Virtual text for DAP
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
            -- Mason integration for DAP
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = "mason.nvim",
                cmd = { "DapInstall", "DapUninstall" },
                opts = {
                    automatic_installation = true,
                    handlers = {},
                    ensure_installed = {
                        "coreclr",  -- C# debugger
                        "codelldb", -- Rust debugger
                    },
                },
            },
        },
        keys = {
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
            { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
            { "<leader>da", function() require("dap").continue({ before = get_args }) end,                        desc = "Run with Args" },
            { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
            { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
            { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
            { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
            { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
            { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
            { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
            { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
            { "<leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
            { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
            { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
            { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
            { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
            { "<leader>du", function() require("dapui").toggle({}) end,                                           desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end,                                               desc = "Eval",                   mode = { "n", "v" } },
        },
        config = function()
            local dap = require("dap")

            -- Rust configuration
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = { "--port", "${port}" },
                }
            }

            dap.configurations.rust = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }

            -- C# configuration
            dap.adapters.coreclr = {
                type = "executable",
                command = "netcoredbg",
                args = { "--interpreter=vscode" }
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "launch - netcoredbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                    end,
                },
            }

            -- Set up signs
            vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
            vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f79000" })
            vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#8b0000" })
            vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
            vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })

            vim.fn.sign_define('DapBreakpoint', {
                text = 'B',
                texthl = 'DapBreakpoint',
                linehl = '',
                numhl = 'DapBreakpoint'
            })
            vim.fn.sign_define('DapBreakpointCondition', {
                text = 'C',
                texthl = 'DapBreakpointCondition',
                linehl = '',
                numhl = 'DapBreakpointCondition'
            })
            vim.fn.sign_define('DapLogPoint', {
                text = 'L',
                texthl = 'DapLogPoint',
                linehl = '',
                numhl = 'DapLogPoint'
            })
            vim.fn.sign_define('DapStopped', {
                text = '>',
                texthl = 'DapStopped',
                linehl = 'DapStopped',
                numhl = 'DapStopped'
            })
            vim.fn.sign_define('DapBreakpointRejected', {
                text = 'X',
                texthl = 'DapBreakpointRejected',
                linehl = '',
                numhl = 'DapBreakpointRejected'
            })
        end,
    },
}
