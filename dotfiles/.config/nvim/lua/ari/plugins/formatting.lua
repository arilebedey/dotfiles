return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        -- React Native specific
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        -- Your other formatters
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "gofmt", "goimports" },
      },
      format_on_save = {
        -- Add a filter to exclude c and cpp files
        filter = function(bufnr)
          local filename = vim.api.nvim_buf_get_name(bufnr)
          local filetype = vim.bo[bufnr].filetype
          -- Return false for c and cpp files to exclude them
          if filetype == "c" or filetype == "cpp" then
            return false
          end
          return true
        end,
        -- Use the new lsp_format option instead of lsp_fallback
        lsp_format = "fallback", -- This replaces lsp_fallback = true
        async = false,
        timeout_ms = 2000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_format = "fallback", -- This replaces lsp_fallback = true
        async = false,
        timeout_ms = 2000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
