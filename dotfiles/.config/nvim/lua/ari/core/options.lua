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

-- TABS & INDENTATION
vim.o.tabstop = 2
vim.o.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false

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

-- Disable clipboard override when pasting over a selection
vim.api.nvim_set_keymap('v', 'p', '"0p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'P', '"0P', { noremap = true, silent = true })

vim.filetype.add({
  extension = {
    keymap = "cpp",
  },
})
