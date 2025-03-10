-- ari/core/functions/tree_config.lua
local M = {}

-- Directory for configuration files
local config_dir = vim.fn.stdpath("config") .. "/variables/"
local tree_config_file = config_dir .. "tree_shown.txt"

-- Create the directory if it doesn't exist
local function ensure_config_dir()
  if vim.fn.isdirectory(config_dir) == 0 then
    vim.fn.mkdir(config_dir, "p")
  end
end

-- Default configuration: true means tree stays open when selecting files
local default_state = true

-- Read the tree state from file
function M.get_tree_state()
  ensure_config_dir()

  local state = default_state
  local file = io.open(tree_config_file, "r")

  if file then
    local content = file:read("*all")
    file:close()

    -- Convert string to boolean
    if content:match("^%s*true%s*$") then
      state = true
    elseif content:match("^%s*false%s*$") then
      state = false
    end
  else
    -- If file doesn't exist, create it with default value
    M.save_tree_state(default_state)
  end

  return state
end

-- Save the tree state to file
function M.save_tree_state(state)
  ensure_config_dir()

  local file, err = io.open(tree_config_file, "w")
  if file then
    file:write(tostring(state))
    file:close()
  else
    vim.notify("Failed to save tree state configuration: " .. (err or "unknown error"), vim.log.levels.ERROR)
  end
end

-- Toggle the tree state and save it
function M.toggle_tree_state()
  local current_state = M.get_tree_state()
  local new_state = not current_state

  M.save_tree_state(new_state)
  return new_state
end

return M
