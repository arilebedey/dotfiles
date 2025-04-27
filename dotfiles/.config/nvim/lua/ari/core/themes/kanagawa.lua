local M = {}

M.config = function()
  vim.g.kanagawa_theme = "dragon"
  vim.cmd("colorscheme kanagawa")
  vim.cmd('set laststatus=0')
end

return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = M.config,
  },
}
