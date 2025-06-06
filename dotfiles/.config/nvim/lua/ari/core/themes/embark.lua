local M = {}
M.config = function()
  vim.cmd("colorscheme embark")
  vim.cmd('set laststatus=0')
end
return {
  { "embark-theme/vim", name = "embark", priority = 1000, config = M.config }
}
