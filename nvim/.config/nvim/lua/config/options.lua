-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Visual enhancements
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 7     -- Keep 'x' lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 'x' columns left/right of cursor
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = ""  -- No color column by default

-- Performance
vim.opt.updatetime = 50  -- Faster completion
vim.opt.timeoutlen = 300 -- Shorter timeout for mappings

-- Files and backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Formatting
vim.opt.wrap = false                            -- No line wrap by default
vim.opt.linebreak = true                        -- Break at word boundaries when wrap is on
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- Don't continue comments on new lines

-- Visual feedback for yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Mouse support
vim.opt.mouse = "a"

-- Better completion experience
vim.opt.completeopt = "menuone,noselect"

-- True color support
vim.opt.termguicolors = true

-- Load icons
require("config.icons")
