local M = {}
M.config = function()
  vim.cmd("colorscheme oxocarbon")
  vim.cmd('set laststatus=0')
end
return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000,
    config = M.config,
  },
}
