-- .../core/themes/onedark.lua

return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    require('onedark').setup({
      style = 'darker' -- Choose the darker variant
    })
    require('onedark').load()
    vim.cmd('set laststatus=0')
  end
}
