return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
        local npairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")
        local cond = require("nvim-autopairs.conds")

        npairs.setup({
            check_ts = true,
            disable_filetype = { "TelescopePrompt" },
            enable_bracket_in_quote = true,
            enable_check_bracket_line = false,
            -- This is important for angle brackets - it allows moving through them
            enable_moveright = true,
            -- This helps with angle bracket detection
            ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        })

        -- Integration with nvim-cmp
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp_status_ok, cmp = pcall(require, "cmp")
        if cmp_status_ok then
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end

        -- Remove single quote rule for Rust files
        -- This prevents auto-pairing of single quotes which interfere with lifetime syntax
        npairs.remove_rule("'")
        npairs.add_rule(Rule("'", "'"):with_pair(cond.not_filetypes({ "rust" })))

        -- Better angle bracket handling for Rust
        -- First remove any existing angle bracket rules
        npairs.remove_rule("<")

        -- Add a smarter rule for angle brackets in Rust
        npairs.add_rule(Rule("<", ">", "rust")
            -- Only add pair when preceded by a word character (for generics)
            :with_pair(cond.before_regex("%w"))
            -- Allow moving through the closing bracket
            :with_move(function(opts)
                return opts.char == ">"
            end)
            -- Don't pair when followed by =, -, or > (for operators like <=, <-, <<)
            :with_pair(
                cond.not_after_regex("[%-%=>]")
            ))

        -- Optional: Add rules for other filetypes that might need angle brackets
        npairs.add_rule(Rule("<", ">", { "html", "xml", "typescriptreact", "javascriptreact" }))
    end,
}
