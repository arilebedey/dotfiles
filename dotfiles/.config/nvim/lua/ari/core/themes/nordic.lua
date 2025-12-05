return {
  "AlexvZyl/nordic.nvim",
  name = "nordic",
  priority = 1000,
  config = function()
    require("nordic").setup({
      bold_keywords = false,
      italic_comments = true,
      transparent = {
        bg = false,
        float = false,
      },
      bright_border = false,
      reduced_blue = true,
      cursorline = {
        bold = false,
        bold_number = true,
        theme = "dark",
        blend = 0.85,
      },
      telescope = { style = "flat" },
    })
    require("nordic").load()
    vim.cmd("set laststatus=0")
  end,
}
