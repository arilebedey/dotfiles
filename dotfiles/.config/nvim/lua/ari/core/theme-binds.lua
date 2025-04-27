-- This file contains all theme-related keybindings

local kms = vim.api.nvim_set_keymap

-- Theme switching keybinds
kms('n', '<leader>ton', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("onedark")<CR>',
  { noremap = true, silent = true, desc = "Switch to Onedark theme" })

kms('n', '<leader>tko', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("tokyonight")<CR>',
  { noremap = true, silent = true, desc = "Switch to Tokyonight theme" })

kms('n', '<leader>tca', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("carbonfox")<CR>',
  { noremap = true, silent = true, desc = "Switch to Carbonfox theme" })

kms('n', '<leader>tte', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("tender")<CR>',
  { noremap = true, silent = true, desc = "Switch to Tender theme" })

kms('n', '<leader>tka', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("kanagawa")<CR>',
  { noremap = true, silent = true, desc = "Switch to Kanagawa theme" })

kms('n', '<leader>tnf', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("nightfly")<CR>',
  { noremap = true, silent = true, desc = "Switch to Nightfly theme" })

kms('n', '<leader>tmf', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("moonfly")<CR>',
  { noremap = true, silent = true, desc = "Switch to Moonfly theme" })

kms('n', '<leader>tne', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("nightfox")<CR>',
  { noremap = true, silent = true, desc = "Switch to Nightfox theme" })

kms('n', '<leader>tma', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("material")<CR>',
  { noremap = true, silent = true, desc = "Switch to Material theme" })

kms('n', '<leader>tmo',
  ':lua require("ari.core.functions.theme_switcher").load_theme("monokai-pro-machine")<CR>',
  { noremap = true, silent = true, desc = "Switch to Preferred Monokai" })

-- Theme utility commands
kms('n', '<leader>tl', 
  ':lua local themes = require("ari.core.functions.theme_switcher").list_themes(); print("Available themes: " .. table.concat(themes, ", "))<CR>',
  { noremap = true, silent = false, desc = "List all available themes" })

kms('n', '<leader>tc', 
  ':lua local current = require("ari.core.functions.theme_switcher").current_theme; print("Current theme: " .. (current or "none"))<CR>',
  { noremap = true, silent = false, desc = "Show current theme" })

-- Return the module so it can be required from init.lua or keymaps.lua
return {}
