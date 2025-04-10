return {
  -- luacheck: ignore
  -- Snippet engine for Neovim, Added event for lazy loading
  -- Using neotab as default fallback for <tab> and tabout for <s-tab>
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    keys = {
      { "<tab>",   mode = { "i", "s" }, false },
      { "<s-tab>", mode = { "i", "s" }, false },
      {
        "<Tab>",
        function()
          if require("luasnip").expand_or_jumpable() then
            return "<Plug>luasnip-expand-or-jump"
          else
            return "<Tab>"
          end
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<Tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<S-Tab>",
        function()
          if require("luasnip").jumpable(-1) then
            return "<Plug>luasnip-jump-prev"
          else
            return "<S-Tab>"
          end
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<S-Tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = "s",
      },
      {
        "<C-e>",
        function()
          if require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          end
        end,
        mode = "i",
        silent = true,
        noremap = true,
      },
    },
  },
}

