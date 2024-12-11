return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  enabled = true,
  event = "BufEnter",
  keys = {
    {
      '<Leader>b',
      function()
        local off = vim.b['barbecue_entries'] == nil
        require('barbecue.ui').toggle(off and true or nil)
      end,
      desc = 'Breadcrumbs toggle',
    },
  },
  opts = {
    -- configurations go here
  },
}
