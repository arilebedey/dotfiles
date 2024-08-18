return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>c", group = "Copy something" },
      { "<leader>d", group = "Diagnostics" },
      { "<leader>g", group = "Git/Goto" },
      { "<leader>h", group = "Hop" },
      { "<leader>l", group = "LSP" },
      { "<leader>r", group = "Replace" },
      { "<leader>s", group = "Telescope/Fuzzy Search" },
      { "<leader>t", group = "Theme/Tab" },
      { "<leader>u", group = "Undo/Outline/Neovim Source" },
      { "<leader>x", group = "Trouble" },
      { "<leader>f", group = "File: (just) Linting" },
    })
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
