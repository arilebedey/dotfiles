local M = {}
M.config = function()
  require("rose-pine").setup({ variant = "moon" })
  vim.cmd("colorscheme rose-pine")
  vim.cmd('set laststatus=0')
end
return {
  { "rose-pine/neovim", name = "rose-pine", priority = 1000, config = M.config }
}
