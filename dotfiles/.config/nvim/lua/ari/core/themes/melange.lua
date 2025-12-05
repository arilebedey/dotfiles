return {
  "savq/melange-nvim",
  name = "melange",
  priority = 1000,
  config = function()
    vim.o.background = "dark"
    vim.cmd("colorscheme melange")
    vim.cmd("set laststatus=0")
  end,
}
