local M = {}
M.config = function()
  vim.g.edge_style = "neon"
  vim.cmd("colorscheme edge")
  vim.cmd('set laststatus=0')
end
return {
  { "sainnhe/edge", priority = 1000, config = M.config }
}
