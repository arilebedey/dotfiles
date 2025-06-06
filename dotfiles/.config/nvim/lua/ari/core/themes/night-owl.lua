local M = {}
M.config = function()
  vim.cmd("colorscheme night-owl")
  vim.cmd('set laststatus=0')
end
return {
  { "haishanh/night-owl.vim", priority = 1000, config = M.config }
}
