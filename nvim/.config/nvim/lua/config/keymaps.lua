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
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

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
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Helper function to get pinned buffers
local function get_pinned_buffers()
    local pinned_buffers = {}

    -- Get all buffers from bufferline
    local ok, bufferline = pcall(require, "bufferline")
    if not ok then
        return pinned_buffers
    end

    local ok2, elements = pcall(bufferline.get_elements)
    if not ok2 or not elements or not elements.elements then
        return pinned_buffers
    end

    -- Check each buffer for pinned status
    for _, element in ipairs(elements.elements) do
        if is_buffer_pinned(element.id) then
            table.insert(pinned_buffers, element.id)
        end
    end

    return pinned_buffers
end

-- Pinned buffer navigation
map("n", "<leader>1", function()
    local pinned_buffers = get_pinned_buffers()
    if #pinned_buffers >= 1 then
        vim.api.nvim_set_current_buf(pinned_buffers[1])
    else
        -- Fallback: use BufferLineGoToBuffer for position-based access
        vim.cmd("BufferLineGoToBuffer 1")
    end
end, { desc = "Go to 1st Pinned Buffer (or 1st Buffer)" })

map("n", "<leader>2", function()
    local pinned_buffers = get_pinned_buffers()
    if #pinned_buffers >= 2 then
        vim.api.nvim_set_current_buf(pinned_buffers[2])
    else
        vim.cmd("BufferLineGoToBuffer 2")
    end
end, { desc = "Go to 2nd Pinned Buffer (or 2nd Buffer)" })

map("n", "<leader>3", function()
    local pinned_buffers = get_pinned_buffers()
    if #pinned_buffers >= 3 then
        vim.api.nvim_set_current_buf(pinned_buffers[3])
    else
        vim.cmd("BufferLineGoToBuffer 3")
    end
end, { desc = "Go to 3rd Pinned Buffer (or 3rd Buffer)" })

map("n", "<leader>4", function()
    local pinned_buffers = get_pinned_buffers()
    if #pinned_buffers >= 4 then
        vim.api.nvim_set_current_buf(pinned_buffers[4])
    else
        vim.cmd("BufferLineGoToBuffer 4")
    end
end, { desc = "Go to 4th Pinned Buffer (or 4th Buffer)" })

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

-- Center after treesitter function navigation
map("n", "]f", function()
    require("nvim-treesitter.textobjects.move").goto_next_start("@function.outer")
    vim.cmd("normal! zz")
end, { desc = "Next Function (centered)" })

map("n", "[f", function()
    require("nvim-treesitter.textobjects.move").goto_previous_start("@function.outer")
    vim.cmd("normal! zz")
end, { desc = "Previous Function (centered)" })

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
