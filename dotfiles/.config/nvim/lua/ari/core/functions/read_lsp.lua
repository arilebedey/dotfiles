-- .../core/functions/read_lsp.lua
local lsp_switcher = require("ari.core.functions.lsp_switcher")

local M = {}

M.apply_last_lsp_state = function()
  lsp_switcher.load_state()
end

return M
