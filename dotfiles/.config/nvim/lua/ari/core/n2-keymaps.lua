vim.g.mapleader = " "
-- local keymap = vim.keymap
local kms = vim.keymap.set

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
kms("n", "<leader>ia", ":wq<CR>")
kms("n", "<leader>ii", ":w<CR>")
-- kms("i", "<leader>ii", "<ESC>:w<CR>i")
kms("n", "<leader>,,", ":qa<CR>")
kms("n", "<leader>,u", ":q!<CR>")

-- MAP S&T TO J&K
kms("n", "s", "k")
kms("v", "s", "k")
kms("n", "t", "j")
kms("v", "t", "j")

-- SEARCH
kms("n", "<ENTER>", ":nohl<CR>")

-- WINDOWS
kms("n", "<leader>wl", "<C-w>v", { desc = "[W]indow [L]eft" })
kms("n", "<leader>wb", "<C-w>s", { desc = "[W]indow [B]elow" })
kms("n", "<leader>wc", "<C-w>q", { desc = "[W]indow [C]lose" })
kms("n", "<leader>we", "<C-w>=", { desc = "[W]indow [E]qualize" })
-- VIM-MAXIMIZER
kms("n", "<leader>wm", "<cmd>MaximizerToggle<CR>", { desc = "[S]et window to [M]aximized" })

-- TABS
kms("n", "<leader>tn", ":tabnew<CR>", { desc = "[T]ab [N]ew" })
kms("n", "<leader>tc", ":tabclose<CR>", { desc = "[T]ab [C]lose" })
kms("n", "<leader>ts", ":tabnew %<CR>", { desc = "[T]ab [S]end Current File" })
kms("n", "<leader>tg", ":tabn<CR>", { desc = "Next Tab" })
kms("n", "gt", ":BufferLineCycleNext<CR>", { desc = "Next Tab" })
kms("n", "gp", ":BufferLineCyclePrev<CR>", { desc = "Previous Tab" })
kms("n", "<leader>gg", ":bdelete<CR>", { desc = "Close Tab" })
-- -------------copied

-- AUTO-SESSION
kms("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "[S]ession [R]estore" })
kms("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "[S]ession [S]ave" })
kms("n", "<leader>sd", "<cmd>SessionDelete<CR>", { desc = "[S]ession [D]elete" })
-- Set mapping for searching a session.
-- ⚠️ This will only work if Telescope.nvim is installed
kms("n", "<C-s>", require("auto-session.session-lens").search_session, {
	noremap = true,
})

-- TELESCOPE KEYMAPS
kms("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "[F]uzzy find in CWD" })
kms("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "[F]uzzy find [R]ecent files" })
kms("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "[F]uzzy find [S]tring in CWD" })
kms("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "[F]uzzy find string under [C]ursor" })
kms("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "[F]uzzy find [P]rojects" })
-- TODO
kms("n", "<leader>cs", "<cmd>TodoTelescope<CR>", { desc = "TOOD [C]omment [S]ee list" })

-- TROUBLE
kms("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Open/close trouble list" })
kms("n", "<leader>xp", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Open diagnostics for [P]roject" })
kms("n", "<leader>xb", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Open diagnostics for [B]uffer" })
kms("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Open trouble quickfix list" })
kms("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>", { desc = "Open trouble location list" })
kms("n", "<leader>xt", "<cmd>TodoTrouble<CR>", { desc = "Open [T]odos in trouble" })

-- LINTING
vim.keymap.set("n", "<leader>l", function()
	lint.try_lint()
end, { desc = "Trigger linting for current file" })

-- GITSIGNS
-- https://youtu.be/6pAG3BHurdM?si=0cFeblgQBqFi52h3&t=4924
local gs = package.loaded.gitsigns
kms("n", "<leader>gn", gs.next_hunk, { desc = "Github [N]ext Hunk" })
kms("n", "<leader>gp", gs.prev_hunk, { desc = "Github [P]rev Hunk" })
kms("n", "<leader>gs", gs.stage_hunk, { desc = "[S]tage hunk" })
kms("n", "<leader>gr", gs.reset_hunk, { desc = "[R]eset hunk" })
kms("v", "<leader>gs", function()
	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "[S]tage hunk" })
kms("v", "<leader>gr", function()
	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "[R]eset hunk" })

kms("n", "<leader>gS", gs.stage_buffer, { desc = "[S]tage buffer" })
kms("n", "<leader>gR", gs.reset_buffer, { desc = "[R]eset buffer" })

kms("n", "<leader>gu", gs.undo_stage_hunk, { desc = "[U]ndo stage hunk" })

kms("n", "<leader>gP", gs.preview_hunk, { desc = "[P]review hunk" })

kms("n", "<leader>gb", function()
	gs.blame_line({ full = true })
end, { desc = "[B]lame line" })
kms("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle line [B]lame" })

kms("n", "<leader>gd", gs.diffthis, { desc = "[D]iff this buffer" })
kms("n", "<leader>gD", function()
	gs.diffthis("~")
end, { desc = "[D]iff this ~" })

-- Text object
kms({ "o", "x" }, "h", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns select hunk" })

-- Copy path
function insertFullPath()
	local filepath = vim.fn.expand("%")
	vim.fn.setreg("+", filepath) -- write to clippoard
end

vim.keymap.set("n", "<leader>pc", insertFullPath, { noremap = true, silent = true })

-- Key mappings for Ctrl-A to select all text
vim.api.nvim_set_keymap(
	"n",
	"<C-A>",
	':lua vim.api.nvim_command("normal! ggVG")<CR>',
	{ noremap = true, silent = true }
)

-- HARPOON
-- vim.keymap.set("n", "<leader>a", function()
-- 	harpoon:list():add()
-- end)
-- vim.keymap.set("n", "<leader>h", function()
-- 	harpoon.ui:toggle_quick_menu(harpoon:list())
-- end)
--
-- vim.keymap.set("n", "<C-/>", function()
-- 	harpoon:list():select(1)
-- end)
-- vim.keymap.set("n", "<C-v>", function()
-- 	harpoon:list():select(2)
-- end)
-- vim.keymap.set("n", "<C-g>", function()
-- 	harpoon:list():select(3)
-- end)
-- vim.keymap.set("n", "<C-p>", function()
-- 	harpoon:list():select(4)
-- end)
--
-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-[>", function()
-- 	harpoon:list():prev()
-- end)
-- vim.keymap.set("n", "<C-]>", function()
-- 	harpoon:list():next()
-- end)
--
--

-- Define a function to copy the entire file without moving the cursor
local function copy_entire_file()
	local current_pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd("normal! ggVGy")
	vim.api.nvim_win_set_cursor(0, current_pos)
end
-- Make the function available globally
_G.copy_entire_file = copy_entire_file
-- Create a key mapping for copying the entire file with 'yyy'
vim.api.nvim_set_keymap("n", "yt", ":lua copy_entire_file()<CR>", { noremap = true, silent = true })
