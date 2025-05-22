return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        local npairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")

        npairs.setup({
            check_ts = true,
            disable_filetype = { "TelescopePrompt" },
            -- Make this very permissive
            ignored_next_char = ".",
            enable_bracket_in_quote = true,
            enable_check_bracket_line = false,
        })

        -- Integration with nvim-cmp
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp_status_ok, cmp = pcall(require, "cmp")
        if cmp_status_ok then
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end

        -- Remove any existing angle bracket rule
        npairs.remove_rule("<")

        -- Add a simpler, more permissive rule for angle brackets in Rust
        npairs.add_rules({
            -- Simple angle bracket rule with no conditions
            Rule("<", ">", { "rust" }),
        })

        -- Override the nested parentheses rule
        local rules = npairs.get_rules("(")
        rules[1]
            :with_pair(function()
                return true
            end)
            :with_move(function(opts)
                return opts.char == ")"
            end)
    end,
}
