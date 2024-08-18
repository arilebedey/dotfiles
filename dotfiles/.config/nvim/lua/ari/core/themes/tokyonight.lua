-- .../core/themes/tokyonight.lua

return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- vim.cmd("colorscheme tokyonight")
    vim.cmd('set laststatus=0')
  end
}

