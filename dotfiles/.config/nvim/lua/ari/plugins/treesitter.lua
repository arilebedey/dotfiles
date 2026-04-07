return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- After setting up Neovim on a new machine, install the parsers manually:
    -- :TSInstall javascript typescript tsx
    -- Without them, TSX/JSX-aware features like contextual commenting will
    -- fall back to plain buffer commentstring behavior.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    vim.treesitter.language.register("bash", "zsh")
  end,
}

-- :TSInstall json javascript typescript tsx yaml html css markdown markdown_inline bash lua vim dockerfile gitignore query vimdoc c
