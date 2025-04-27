-- ari/core/themes/nightfox.lua
local M = {}

M.config = function()
  require("nightfox").setup({
    options = {
      styles = {
        comments = "italic",
        keywords = "bold",
        types = "italic,bold",
      },
      inverse = {
        match_paren = false,
        visual = false,
        search = false,
      },
      dim_inactive = false,
    },
    groups = {
      all = {
        LineNr = { fg = "palette.fg3" },
      },
    },
  })
  
  vim.cmd("colorscheme nightfox")
  vim.cmd('set laststatus=0')
end

-- For Lazy package manager
return {
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = M.config
  },
}
