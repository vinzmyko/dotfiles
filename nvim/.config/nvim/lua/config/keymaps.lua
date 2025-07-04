local map = vim.keymap.set

-- Better up/down movement (handles wrapped lines)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Tmux & Window navigation
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to Left Window" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to Right Window" })

-- Window resizing
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Window splits
map("n", "<leader>-", "<C-w>s", { desc = "Split Window Below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete Window" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Buffer navigation by position (BufferLine)
map("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", { desc = "Go to Buffer 1" })
map("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", { desc = "Go to Buffer 2" })
map("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", { desc = "Go to Buffer 3" })
map("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", { desc = "Go to Buffer 4" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent Left" })
map("v", ">", ">gv", { desc = "Indent Right" })

-- Move lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Lines Down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Lines Up" })
map("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move Lines Down" })
map("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move Lines Up" })

-- Ergonomic cursor placement
map("n", "J", "mzJ`z", { desc = "Join Lines (keep cursor)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half Page Down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half Page Up" })
map("n", "n", "nztZv", { desc = "Next Search" })
map("n", "N", "NztZv", { desc = "Prev Search" })

-- Center after treesitter function navigation
map("n", "]f", function()
    require("nvim-treesitter.textobjects.move").goto_next_start("@function.outer")
    vim.cmd("normal! zt")
end, { desc = "Next Function" })

map("n", "[f", function()
    require("nvim-treesitter.textobjects.move").goto_previous_start("@function.outer")
    vim.cmd("normal! zt")
end, { desc = "Previous Function" })

-- Clear search highlighting
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear Search Highlight" })

-- Better word deletion in insert mode
map("i", "<C-BS>", "<C-w>", { desc = "Delete Word Backward" })
map("i", "<C-H>", "<C-w>", { desc = "Delete Word Backward (alt)" })

-- Add undo break-points
map("i", ",", ",<c-g>u", { desc = "Add Undo Break" })
map("i", ".", ".<c-g>u", { desc = "Add Undo Break" })
map("i", ";", ";<c-g>u", { desc = "Add Undo Break" })

-- Commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Terminal mappings
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
