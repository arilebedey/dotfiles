return {
  "tpope/vim-fugitive",
  keys = {
    -- Open current file on github.com
    {
      "<leader>go",
      ":GBrowse<cr>",
      mode = { "n", "v" },
      desc = "Open file in Github",
    },
    -- { "<leader>gs", ":Git<cr>", mode = { "n", "v" }, desc = "[G]it [S]tatus" },
    { "<leader>gg", ":G<cr>", mode = { "n", "v" }, desc = "[G]it" },
  },
  cmd = { "Git" },
  dependencies = { "tpope/vim-rhubarb" },
}
