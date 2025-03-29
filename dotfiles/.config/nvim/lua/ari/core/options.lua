vim.opt.swapfile = false

local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.clipboard:append("unnamedplus")

vim.o.number = true
vim.o.relativenumber = true

vim.o.signcolumn = "yes"

-- UNDO HISTORY
vim.opt.undodir = vim.fn.expand("~/.local/nvim/undodir")
vim.opt.undofile = true

-- UNDO
vim.keymap.set('n', 'r', '<C-r>', { noremap = true })
vim.keymap.set('n', 'R', 'r', { noremap = true })

-- TABS & INDENTATION
vim.o.tabstop = 2
vim.o.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false

-- Apply settings only for C files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c", -- Trigger for C files
  callback = function()
    -- TABS & INDENTATION
    vim.bo.tabstop = 4        -- Number of spaces a tab character counts for
    vim.bo.shiftwidth = 4     -- Number of spaces used for auto-indenting
    vim.bo.softtabstop = 4    -- Number of spaces used when hitting Tab
    vim.bo.expandtab = false  -- Use tabs, not spaces
    vim.bo.autoindent = true  -- Enable auto-indentation
    vim.bo.smartindent = true -- Enable smart indentation

    -- DISPLAY CHARACTERS (optional)
    vim.wo.list = true                  -- Show whitespace characters
    vim.wo.listchars = "tab:>-,trail:-" -- Customize how tabs/trailing spaces look
  end,
})


-- SEARCH
opt.ignorecase = true
opt.smartcase = true

-- THEME
opt.background = "dark"
opt.termguicolors = true
-- local read_theme = require("ari.core.functions.read_theme")
-- read_theme.apply_last_theme()

-- BACKSPACE
opt.backspace = "indent,eol,start"

-- SPLIT WINDOWS
opt.splitright = false
opt.splitbelow = true

vim.o.updatetime = 300

vim.o.termguicolors = true


vim.o.mouse = "a"
vim.opt.guicursor = { 'n:block', 'v:ver25', 'i:ver25' }

vim.filetype.add({
  extension = {
    keymap = "cpp",
  },
})

-- FOR avante.nvim
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- Accept luasnip edit place
vim.api.nvim_set_keymap('s', '<C-l>', '<ESC>ciw', { noremap = true, silent = true })
