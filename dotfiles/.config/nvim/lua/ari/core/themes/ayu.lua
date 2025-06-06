local M = {}
M.config = function()
  vim.g.ayucolor = "dark"
  vim.cmd("colorscheme ayu")
  vim.cmd('set laststatus=0')
end
return {
  { "ayu-theme/ayu-vim", priority = 1000, config = M.config }
}
