return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    local comment = require("Comment")
    local ok, ts_context_commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")

    if ok then
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end

    local pre_hook
    if ok then
      local hook = ts_context_commentstring.create_pre_hook()
      pre_hook = function(ctx)
        local hook_ok, commentstring = pcall(hook, ctx)
        if hook_ok then
          return commentstring
        end
      end
    end

    comment.setup({
      pre_hook = pre_hook,
    })
  end,
}
