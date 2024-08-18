-- .../core/functions/read_theme.lua

local M = {}
local theme_switcher = require("ari.core.functions.theme_switcher")
local theme_file = vim.fn.stdpath('config') .. "/lua/ari/core/variables/theme.txt"

-- Function to read the theme from the file
local function read_theme_from_file()
  local file = io.open(theme_file, "r")
  if file then
    local theme_name = file:read("*all"):gsub("%s+", "")
    file:close()
    return theme_name
  else
    vim.notify("Failed to read theme from file", vim.log.levels.ERROR)
    return nil
  end
end

M.apply_last_theme = function()
  local last_theme = read_theme_from_file()
  if last_theme then
    theme_switcher.load_theme(last_theme)
  end
end

return M

