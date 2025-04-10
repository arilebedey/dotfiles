-------------
-- Outline --
-------------
return {
  'hedyhli/outline.nvim',
  cmd = { 'Outline', 'OutlineOpen' },
  keys = {
    { '<leader>uu', '<cmd>Outline<CR>', desc = 'Toggle outline' },
  },
  config = function()
    require('outline').setup({
      symbols = {

      },
    })
  end
}
