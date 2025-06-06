vim.g.mapleader = " "
-- local keymap = vim.keymap
local kms = vim.keymap.set

kms("n", "<leader>uo", ":source /home/ari/.config/nvim/init.lua<CR>", { desc = "Source config file", silent = false })

-- MISC
kms("n", "vV", "Vp")
kms("n", "Vv", "Vp")

-- Insert mode mapping
vim.api.nvim_set_keymap("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })
-- Remap r to Ctrl-r in normal mode
vim.api.nvim_set_keymap("n", "r", "<C-r>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "r", "<C-r>", { noremap = true, silent = true })

-- Command-line mode mapping
vim.api.nvim_set_keymap("c", "<C-BS>", "<C-W>", { noremap = true, silent = true })

-- FILES
kms("n", "<leader>a", ":wq<CR>", { silent = true, desc = "Save and Close" })
kms("n", "<leader>i", ":w<CR>", { silent = true, desc = "Save" })
kms("n", "<leader>,", ":qa<CR>", { silent = true, desc = "Quit all" })
kms("n", "<leader>u,", ":q!<CR>", { silent = true, desc = "Force quit" })

-- MAP S&T TO J&K
kms("n", "s", "k")
kms("v", "s", "k")
kms("n", "t", "j")
kms("v", "t", "j")

-- SEARCH
kms("n", "<ENTER>", ":nohl<CR>", { silent = true })

-- WINDOWS
-- kms("n", "<leader>wl", "<C-w>v", { desc = "[W]indow [L]eft" })
-- kms("n", "<leader>wb", "<C-w>s", { desc = "[W]indow [B]elow" })
-- kms("n", "<leader>wc", "<C-w>q", { desc = "[W]indow [C]lose" })
-- kms("n", "<leader>we", "<C-w>=", { desc = "[W]indow [E]qualize" })
-- VIM-MAXIMIZER
-- kms("n", "<leader>wm", "<cmd>MaximizerToggle<CR>", { desc = "[S]et window to [M]aximized" })

-- TABS
kms("n", "<leader>tn", ":tabnew<CR>", { desc = "[T]ab [N]ew", silent = true })
kms("n", "<leader>tc", ":tabclose<CR>", { desc = "[T]ab [C]lose", silent = true })
-- kms("n", "<leader>ts", ":tabnew %<CR>", { desc = "[T]ab [S]end Current File", silent = true })
-- kms("n", "gt", ":BufferLineCycleNext<CR>", { desc = "Next Tab", silent = true })
-- kms("n", "gp", ":BufferLineCyclePrev<CR>", { desc = "Previous Tab", silent = true })
-- kms("n", "<leader>a", ":BufferLinePick<CR>", { desc = "Pick Tab", silent = true })
-- kms("n", "gc", ":BufferLinePickClose<CR>", { desc = "Pick Close", silent = true })

-- LAZY
kms("n", "<leader>la", "<cmd>Lazy<CR>", { desc = "Open Lazy.nvim" })

-- COPYING INFO
vim.api.nvim_set_keymap('n', '<leader>cc',
  [[:lua require('ari.core.functions.copy_file_path').copy_current_file_path()<CR>]],
  { desc = "Copy Full File Path", noremap = true, silent = true })
-- Map Ctrl-A to select all text
vim.api.nvim_set_keymap('n', 'ya', 'ggVG', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'yf', [[:lua require('ari.core.functions.copy_entire_file').copy_entire_file()<CR>]],
  { desc = "Copy Entire File", noremap = true, silent = true })

-- Toggle Status Line
vim.api.nvim_set_keymap('n', '<leader>w',
  [[:lua require('ari.core.functions.toggle_statusline').toggle_statusline()<CR>]],
  { desc = "Toggle Status Line", noremap = true, silent = true })

-- 42 header
vim.cmd('source ' .. vim.fn.stdpath('config') .. '/lua/ari/plugins/42header.vim')
vim.api.nvim_set_keymap('n', '<leader>nt', ':Stdheader<CR>', { noremap = true, silent = true })

-----------------------------------
-- CLIBBOARD STUFF | COPYING ETC --
-----------------------------------

-- Binding to clear file and paste clipboard content
vim.api.nvim_set_keymap('n', '<leader>cp', ':%delete_<CR>"+P', { noremap = true, silent = true })

-- For visual mode, directly use "+p to paste from system clipboard
vim.api.nvim_set_keymap('v', 'p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'P', '"+P', { noremap = true, silent = true })


-----------------------------------
-- Deleting --
-----------------------------------

vim.keymap.set('n', 'dL', 'v$hd', { noremap = true })
vim.keymap.set('n', 'yL', 'v$hy', { noremap = true })
vim.keymap.set('n', 'cL', 'v$hc', { noremap = true })

-----------------------------------
-- Load theme-specific keybindings
-----------------------------------

require("ari.core.theme-binds")
