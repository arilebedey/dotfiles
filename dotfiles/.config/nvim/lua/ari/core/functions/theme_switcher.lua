-- .../core/functions/theme_switcher.lua

local M = {}

local theme_path = "ari.core.themes."
local themes = {}
local theme_file = vim.fn.stdpath('config') .. "/lua/ari/core/variables/theme.txt"

-- Function to fetch all theme files from the themes directory
local function fetch_themes()
  local dir_path = vim.fn.stdpath('config') .. "/lua/ari/core/themes/"
  local handle = vim.loop.fs_scandir(dir_path)
  if handle then
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then break end
      if type == "file" and name:match("%.lua$") then
        local theme_name = name:gsub("%.lua$", "")
        table.insert(themes, theme_name)
      end
    end
  else
    vim.notify("Failed to scan themes directory", vim.log.levels.ERROR)
  end
end

fetch_themes()

M.current_theme = nil

-- Function to save the selected theme to a file
local function save_theme_to_file(theme_name)
  local file = io.open(theme_file, "w")
  if file then
    file:write(theme_name)
    file:close()
  else
    vim.notify("Failed to write theme to file", vim.log.levels.ERROR)
  end
end

M.load_theme = function(theme_name)
  -- Check if the theme is valid
  local valid_theme = false
  for _, theme in ipairs(themes) do
    if theme == theme_name then
      valid_theme = true
      break
    end
  end

  if not valid_theme then
    vim.notify("Invalid theme: " .. theme_name, vim.log.levels.ERROR)
    return
  end

  -- Unload current theme if any
  if M.current_theme then
    package.loaded[theme_path .. M.current_theme] = nil
  end

  -- Set the new theme
  vim.cmd("colorscheme " .. theme_name)

  -- Load the new theme configuration
  local theme_config = require(theme_path .. theme_name)
  if theme_config.config then
    theme_config.config()
  end

  M.current_theme = theme_name
  save_theme_to_file(theme_name)
end

return M

