local M = {}

M.config = function()
  vim.g.moonflyItalics = true
  vim.g.moonflyUnderlineMatchParen = true
  vim.g.moonflyWinSeparator = 2
  vim.cmd("colorscheme moonfly")
  vim.cmd('set laststatus=0')
end

return {
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    priority = 1000,
    config = M.config,
  },
}
