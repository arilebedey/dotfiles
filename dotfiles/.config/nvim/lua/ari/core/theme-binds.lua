-- This file contains all theme-related keybindings

local kms = vim.api.nvim_set_keymap

-- Theme switching keybinds
kms('n', '<leader>thd', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("onedark")<CR>',
  { noremap = true, silent = true, desc = "Switch to Onedark theme" })

kms('n', '<leader>thk', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("kanagawa")<CR>',
  { noremap = true, silent = true, desc = "Switch to Kanagawa theme" })

kms('n', '<leader>thf', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("nightfly")<CR>',
  { noremap = true, silent = true, desc = "Switch to Nightfly theme" })

kms('n', '<leader>tho', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("moonfly")<CR>',
  { noremap = true, silent = true, desc = "Switch to Moonfly theme" })

kms('n', '<leader>thn', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("nightfox")<CR>',
  { noremap = true, silent = true, desc = "Switch to Nightfox theme" })

kms('n', '<leader>tha', 
  ':lua require("ari.core.functions.theme_switcher").load_theme("material")<CR>',
  { noremap = true, silent = true, desc = "Switch to Material theme" })

-- Theme utility commands
kms('n', '<leader>tl', 
  ':lua local themes = require("ari.core.functions.theme_switcher").list_themes(); print("Available themes: " .. table.concat(themes, ", "))<CR>',
  { noremap = true, silent = false, desc = "List all available themes" })

kms('n', '<leader>tc', 
  ':lua local current = require("ari.core.functions.theme_switcher").current_theme; print("Current theme: " .. (current or "none"))<CR>',
  { noremap = true, silent = false, desc = "Show current theme" })

-- Return the module so it can be required from init.lua or keymaps.lua
return {}
