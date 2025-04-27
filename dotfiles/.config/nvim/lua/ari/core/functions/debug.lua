-- Save this as debug_theme.lua in your Neovim config directory
-- Run with `:luafile /path/to/debug_theme.lua`

local function debug_theme_switcher()
  -- Path to theme.txt file
  local theme_file = vim.fn.stdpath('config') .. "/lua/ari/core/variables/theme.txt"
  print("Theme file path: " .. theme_file)

  -- Check if file exists
  local file_exists = vim.fn.filereadable(theme_file) == 1
  print("Theme file exists: " .. tostring(file_exists))

  -- Try to read current theme
  local current_theme = nil
  if file_exists then
    local file = io.open(theme_file, "r")
    if file then
      current_theme = file:read("*all"):gsub("%s+", "")
      file:close()
      print("Current theme from file: " .. (current_theme or "nil"))
    else
      print("Failed to open theme file for reading")
    end
  end

  -- Check themes directory
  local themes_dir = vim.fn.stdpath('config') .. "/lua/ari/core/themes/"
  print("Themes directory: " .. themes_dir)
  print("Directory exists: " .. tostring(vim.fn.isdirectory(themes_dir) == 1))

  -- List available themes
  local themes = {}
  local handle = vim.loop.fs_scandir(themes_dir)
  if handle then
    print("Found themes:")
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then break end
      if type == "file" and name:match("%.lua$") then
        local theme_name = name:gsub("%.lua$", "")
        table.insert(themes, theme_name)
        print("  - " .. theme_name)
      end
    end
  else
    print("Failed to scan themes directory")
  end

  -- Test theme loading function (without actually changing theme)
  print("\nTesting theme loading functionality:")
  
  -- Try to load a theme module
  local test_theme = current_theme or (themes[1] or "onedark")
  print("Testing with theme: " .. test_theme)
  
  local status, theme_module = pcall(require, "ari.core.themes." .. test_theme)
  print("Module load success: " .. tostring(status))
  
  if status then
    print("Module type: " .. type(theme_module))
    
    if type(theme_module) == "table" then
      -- Check for direct config function
      if type(theme_module.config) == "function" then
        print("Found direct config function")
      -- Check for array with config
      elseif #theme_module == 1 and type(theme_module[1]) == "table" and type(theme_module[1].config) == "function" then
        print("Found config in first array item")
      else
        print("No config function found in expected locations")
        -- Dump the module structure
        print("Module keys: ")
        for k, v in pairs(theme_module) do
          print("  - " .. k .. " (" .. type(v) .. ")")
        end
      end
    end
  end
  
  -- Test file writing
  print("\nTesting file writing:")
  local test_file = vim.fn.stdpath('config') .. "/lua/ari/core/variables/theme_test.txt"
  local write_file = io.open(test_file, "w")
  if write_file then
    write_file:write("test_theme")
    write_file:close()
    print("Test file written successfully")
    
    -- Read back the test file
    local read_file = io.open(test_file, "r")
    if read_file then
      local content = read_file:read("*all")
      read_file:close()
      print("Test file content: " .. content)
      
      -- Clean up test file
      os.remove(test_file)
    else
      print("Failed to read test file")
    end
  else
    print("Failed to write test file")
  end
end

-- Run the debug function
debug_theme_switcher()
