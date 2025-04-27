local M = {}

M.config = function()
  vim.g.nightflyCursorColor = true
  vim.g.nightflyItalics = true
  vim.g.nightflyUndercurls = true
  vim.cmd("colorscheme nightfly")
  vim.cmd('set laststatus=0')
end

return {
  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    priority = 1000,
    config = M.config,
  },
}


