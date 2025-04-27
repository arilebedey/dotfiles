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
  -- Ensure directories exist
  local dir_path = vim.fn.fnamemodify(theme_file, ":h")
  if vim.fn.isdirectory(dir_path) ~= 1 then
    vim.fn.mkdir(dir_path, "p")
  end
  
  local file = io.open(theme_file, "w")
  if file then
    file:write(theme_name)
    file:close()
  else
    vim.notify("Failed to write theme to file", vim.log.levels.ERROR)
  end
end

-- Apply a colorscheme directly
local function apply_colorscheme(theme_name)
  local success = pcall(function()
    vim.cmd("colorscheme " .. theme_name)
  end)
  
  return success
end

-- Function to get theme configuration
local function get_theme_config(theme_name)
  local status, theme_module = pcall(require, theme_path .. theme_name)
  
  if not status then
    vim.notify("Failed to load theme module: " .. theme_name, vim.log.levels.ERROR)
    return nil
  end
  
  -- Handle different theme module structures
  if type(theme_module) == "table" then
    -- Case 1: Direct module with config function
    if type(theme_module.config) == "function" then
      return theme_module
    end
    
    -- Case 2: Lazy plugin spec with a single entry
    if type(theme_module[1]) == "table" and theme_module[1].config and type(theme_module[1].config) == "function" then
      return {
        config = theme_module[1].config
      }
    end
    
    -- Case 3: Lazy plugin spec as a direct table with config
    if theme_module.config and type(theme_module.config) == "function" then
      return {
        config = theme_module.config
      }
    end
    
    -- Case 4: Kanagawa-specific fix
    if theme_name == "kanagawa" then
      return {
        config = function()
          vim.g.kanagawa_theme = "dragon"
          vim.cmd("colorscheme kanagawa")
          vim.cmd('set laststatus=0')
        end
      }
    end
  end
  
  -- If we reach here, we couldn't identify a valid config pattern
  
  -- Create a fallback config that just sets the colorscheme
  return {
    config = function()
      vim.cmd("colorscheme " .. theme_name)
      vim.cmd('set laststatus=0')
    end
  }
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
  
  -- Get the theme configuration
  local theme_config = get_theme_config(theme_name)
  
  if not theme_config then
    return
  end
  
  -- Try direct colorscheme first
  local colorscheme_success = apply_colorscheme(theme_name)
  
  -- Apply the config function
  if theme_config.config then
    local config_success, err = pcall(theme_config.config)
    
    if not config_success then
      vim.notify("Error applying theme config: " .. tostring(err), vim.log.levels.ERROR)
    end
  end
  
  -- Save theme to file
  M.current_theme = theme_name
  save_theme_to_file(theme_name)
  
  vim.notify("Theme switched to: " .. theme_name, vim.log.levels.INFO)
end

-- List available themes
M.list_themes = function()
  return themes
end

return M
