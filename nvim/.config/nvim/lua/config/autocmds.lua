local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General settings
local general = augroup("General", { clear = true })

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = general,
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Resize splits if window got resized
autocmd({ "VimResized" }, {
    group = general,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
    group = general,
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_pos then
            return
        end
        vim.b[buf].last_pos = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
    group = general,
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
    group = general,
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Writing mode autocmds
local writing = augroup("WritingMode", { clear = true })

-- Variables to track writing mode state
vim.g.writing_mode = false

-- Function to toggle writing mode
function _G.toggle_writing_mode()
    vim.g.writing_mode = not vim.g.writing_mode

    if vim.g.writing_mode then
        -- Enable writing mode
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_gb"
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.textwidth = 80
        vim.diagnostic.enable(false)

        -- Zen mode (simple version - hide UI elements)
        vim.opt.laststatus = 0
        vim.opt.ruler = false
        vim.opt.showcmd = false
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.signcolumn = "no"

        print("✍️  Writing mode enabled")
    else
        -- Disable writing mode
        vim.opt_local.spell = false
        vim.opt_local.wrap = false
        vim.opt_local.linebreak = false
        vim.opt_local.textwidth = 0
        vim.diagnostic.enable()

        -- Restore UI
        vim.opt.laststatus = 2 -- Show statusline
        vim.opt.ruler = true
        vim.opt.showcmd = true
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.signcolumn = "yes"

        print("💻 Writing mode disabled")
    end
end

-- Keymap for writing mode toggle
vim.keymap.set("n", "<leader>uw", toggle_writing_mode, { desc = "Toggle Writing Mode" })
