return {
  "numToStr/Comment.nvim",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    local comment = require("Comment")
    local ft = require("Comment.ft")
    local ok, ts_context_commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")

    if ok then
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end

    local pre_hook = function(ctx)
      local fallback = ft.get(vim.bo.filetype, ctx.ctype) or vim.bo.commentstring

      if not ok then
        return fallback
      end

      local parser_ok, parser = pcall(vim.treesitter.get_parser, 0)
      if not parser_ok or not parser then
        return fallback
      end

      local hook = ts_context_commentstring.create_pre_hook()
      local hook_ok, commentstring = pcall(hook, ctx)

      if hook_ok and commentstring then
        return commentstring
      end

      return fallback
    end

    comment.setup({
      pre_hook = pre_hook,
    })
  end,
}
