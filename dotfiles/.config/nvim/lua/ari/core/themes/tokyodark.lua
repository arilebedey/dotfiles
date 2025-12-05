return {
  "tiagovla/tokyodark.nvim",
  name = "tokyodark",
  priority = 1000,
  config = function()
    require("tokyodark").setup({
      transparent_background = false,
      gamma = 1.0,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        identifiers = { italic = true },
        functions = {},
        variables = {},
      },
      terminal_colors = true,
    })
    vim.cmd("colorscheme tokyodark")
    vim.cmd("set laststatus=0")
  end,
}
