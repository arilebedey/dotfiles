return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  priority = 1000,
  config = function()
    vim.g.moonflyCursorColor = true
    vim.g.moonflyItalics = true
    vim.g.moonflyNormalPmenu = true
    vim.g.moonflyNormalFloat = true
    vim.g.moonflyTerminalColors = true
    vim.g.moonflyTransparent = false
    vim.g.moonflyUndercurls = true
    vim.g.moonflyUnderlineMatchParen = false
    vim.g.moonflyVirtualTextColor = false
    vim.g.moonflyWinSeparator = 1
    vim.cmd("colorscheme moonfly")
    vim.cmd("set laststatus=0")
  end,
}
