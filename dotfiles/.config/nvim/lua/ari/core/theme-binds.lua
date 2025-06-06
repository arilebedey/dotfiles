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

kms('n', '<leader>thy',
  ':lua require("ari.core.functions.theme_switcher").load_theme("ayu")<CR>',
  { noremap = true, silent = true, desc = "Switch to Ayu theme" })

kms('n', '<leader>the',
  ':lua require("ari.core.functions.theme_switcher").load_theme("edge")<CR>',
  { noremap = true, silent = true, desc = "Switch to Edge theme" })

kms('n', '<leader>thx', ':lua require("ari.core.functions.theme_switcher").load_theme("oxocarbon")<CR>',
  { noremap = true, silent = true, desc = "Switch to Oxocarbon theme" })

kms('n', '<leader>thr', ':lua require("ari.core.functions.theme_switcher").load_theme("rose-pine-moon")<CR>',
  { noremap = true, silent = true, desc = "Switch to Rose Pine Moon theme" })

kms('n', '<leader>thb', ':lua require("ari.core.functions.theme_switcher").load_theme("embark")<CR>',
  { noremap = true, silent = true, desc = "Switch to Embark theme" })

kms('n', '<leader>thw', ':lua require("ari.core.functions.theme_switcher").load_theme("night-owl")<CR>',
  { noremap = true, silent = true, desc = "Switch to Night Owl theme" })

-- Return the module so it can be required from init.lua or keymaps.lua
return {}
