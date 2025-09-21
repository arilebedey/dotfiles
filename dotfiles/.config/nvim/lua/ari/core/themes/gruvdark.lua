local M = {}

M.config = function()
  require("gruvdark").setup({})
  vim.cmd.colorscheme("gruvdark")
  -- vim.cmd.colorscheme("gruvdark-light")
  vim.cmd("set laststatus=0")
end

return {
  {
    "darianmorat/gruvdark.nvim",
    lazy = false,
    priority = 1000,
    config = M.config,
  },
}
