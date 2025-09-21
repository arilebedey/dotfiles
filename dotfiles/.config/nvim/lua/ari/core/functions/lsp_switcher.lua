-- .../core/functions/lsp_switcher.lua
local M = {}
local state_file = vim.fn.stdpath("config") .. "/lua/ari/core/variables/lsp_state.txt"

M.current_state = "on"

-- Ensure state dir exists
local function ensure_dir()
  local dir_path = vim.fn.fnamemodify(state_file, ":h")
  if vim.fn.isdirectory(dir_path) ~= 1 then
    vim.fn.mkdir(dir_path, "p")
  end
end

-- Save LSP state to file
local function save_state(state)
  ensure_dir()
  local f = io.open(state_file, "w")
  if f then
    f:write(state)
    f:close()
  else
    vim.notify("Failed to write LSP state", vim.log.levels.ERROR)
  end
end

-- Load saved state
local function load_state()
  local f = io.open(state_file, "r")
  if f then
    local state = f:read("*l")
    f:close()
    if state == "off" or state == "on" then
      return state
    end
  end
  return "on" -- default
end

-- Apply state (start/stop LSP)
local function apply_state(state)
  if state == "off" then
    for _, client in pairs(vim.lsp.get_clients()) do
      client.stop(true)
    end
    vim.notify("LSP stopped", vim.log.levels.INFO)
  elseif state == "on" then
    vim.notify("LSP enabled (restart Neovim or reload to attach servers)", vim.log.levels.INFO)
  end
end

M.load_state = function()
  local s = load_state()
  M.current_state = s
  apply_state(s)
end

M.toggle = function()
  if M.current_state == "on" then
    M.current_state = "off"
  else
    M.current_state = "on"
  end
  save_state(M.current_state)
  apply_state(M.current_state)
end

return M
