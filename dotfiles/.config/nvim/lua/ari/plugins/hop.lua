return {
    'smoka7/hop.nvim',
    version = "*",
    opts = {
        keys = 'tahnsiropwg.v-/;fljqkzdmbx'
    },
    keys = {
      { '<leader>hw', '<cmd>HopWord<cr>',  desc = 'Hop to word' },
      { '<leader>hc', '<cmd>HopChar1<cr>', desc = 'Hop to a char' },
      { '<leader>hl', '<cmd>HopLine<cr>', desc = 'Hop to a char' },
    },
    -- config = function ()
    --   local hop = require('hop')
    --   local directions = require('hop.hint').HintDirection
    --   vim.keymap.set('', 'f', function()
    --     hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    --   end, {remap=true})
    --   vim.keymap.set('', 'F', function()
    --   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    --   end, {remap=true})
    -- end
}
