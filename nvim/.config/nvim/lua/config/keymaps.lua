local map = vim.keymap.set

-- Better up/down movement (handles wrapped lines)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Window navigation (works with tmux-navigator)
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

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
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

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
map("n", "<C-d>", "<C-d>zz", { desc = "Half Page Down (center)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half Page Up (center)" })
map("n", "n", "nzzzv", { desc = "Next Search (center)" })
map("n", "N", "Nzzzv", { desc = "Prev Search (center)" })

-- Clear search highlighting
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear Search Highlight" })

-- Better word deletion in insert mode (avoid browser conflicts)
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
