local M = {}

M.config = function()
  vim.g.material_style = "deep ocean" -- darker variant (other options: oceanic, palenight, darker, lighter)
  
  require("material").setup({
    contrast = {
      terminal = false,
      sidebars = false,
      floating_windows = false,
      cursor_line = false,
    },
    italics = {
      comments = true,
      keywords = true,
      functions = false,
    },
  })
  
  vim.cmd("colorscheme material")
  vim.cmd('set laststatus=0')
end

-- For Lazy package manager
return {
  {
    "marko-cerovac/material.nvim",
    priority = 1000,
    config = M.config
  },
}
