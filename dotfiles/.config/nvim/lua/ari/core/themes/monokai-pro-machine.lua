return {
  "loctvl842/monokai-pro.nvim",
  name = "monokai-pro-machine",
  priority = 1000,
  opts = {
    filter = 'machine', -- classic | octagon | pro | machine | ristretto | spectrum
  },
  config = function()
    vim.cmd('set laststatus=0')
  end
}
