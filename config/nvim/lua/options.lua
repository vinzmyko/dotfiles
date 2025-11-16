vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Visual/UI Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Search behavior
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true  -- Unless uppercase present
vim.opt.incsearch = true  -- Show matches while typing
vim.opt.hlsearch = false  -- Don't highlight results after search

-- File/Buffer management
vim.opt.swapfile = false -- No swap files
vim.opt.undofile = true  -- Persistent undo
vim.opt.autoread = true  -- Auto-reload changed files
vim.opt.hidden = true    -- Allow hidden buffers

-- Indentation
vim.opt.tabstop = 4        -- Tab display width
vim.opt.shiftwidth = 4     -- Indent width
vim.opt.expandtab = true   -- Spaces instead of tabs
vim.opt.smartindent = true -- Context-aware indenting

-- Performance
vim.opt.lazyredraw = true -- Don't redraw during macros
vim.opt.synmaxcol = 300   -- Syntax highlighting limit
vim.opt.updatetime = 300  -- Faster completion
vim.opt.timeoutlen = 500  -- Key timeout duration

-- Better completion
vim.opt.completeopt = "menuone,noselect" -- Better completion menu
vim.opt.pumheight = 10                   -- Popup menu height

-- Split behavior
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

-- Clipboard
vim.opt.clipboard:append("unnamedplus")

-- File handling
vim.opt.encoding = "UTF-8"     -- Set encoding
vim.opt.fileencoding = "utf-8" -- File encoding

-- Disable automatic comment continuation on Enter and o/O
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        vim.opt_local.formatoptions:remove({ 'r', 'o' })
    end,
})

-- Highlight yanked text
local augroup = vim.api.nvim_create_augroup("UserConfig", {})
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})
