return {
  "nvim-mini/mini.comment",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    local ok, ts_context_commentstring = pcall(require, "ts_context_commentstring")

    if ok then
      ts_context_commentstring.setup({
        enable_autocmd = false,
      })
    end

    require("mini.comment").setup({
      options = {
        custom_commentstring = function(ref_position)
          if not ok or not ref_position then
            return nil
          end

          local parser_ok, parser = pcall(vim.treesitter.get_parser, 0)
          if not parser_ok or not parser then
            return nil
          end

          local commentstring_ok, commentstring = pcall(ts_context_commentstring.calculate_commentstring, {
            key = "__default",
            location = {
              ref_position[1] - 1,
              math.max(ref_position[2] - 1, 0),
            },
          })

          if commentstring_ok and commentstring then
            return commentstring
          end

          return nil
        end,
      },
      mappings = {
        comment = "gc",
        comment_line = "gcc",
        comment_visual = "gc",
        textobject = "gc",
      },
    })
  end,
}
