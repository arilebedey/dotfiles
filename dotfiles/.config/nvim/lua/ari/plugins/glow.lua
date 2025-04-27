return {
  "ellisonleao/glow.nvim",
  config = function()
    require("glow").setup({
      -- Basic options
      glow_path = "/usr/bin/glow", -- Leave empty to use system-installed glow
      install_path = vim.fn.stdpath("data") .. "/glow", -- Install location
      border = "rounded",
      style = "dark",
      pager = false,
      width = 120,
      height = 100, -- Fixed height instead of ratio
      height_ratio = 0.7,
      
      -- Additional required fields
      transparent_background = false,
      terminal_colors = true, -- Use terminal colors
      devicons = true,
      filter = true,
      styles = {
        bold = true,
        italic = true,
        heading = true,
      },
      day_night = true, -- Use different style based on system time
      inc_search = true, -- Enable incremental search
      background_clear = false, -- Clear background
      
      -- Extended configuration
      extend = {
        -- Additional configuration can go here if needed
      },
      setup = function(path)
        -- Custom setup function if needed
      end,
    })
    
    -- Set keymaps for Markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.api.nvim_buf_set_keymap(
          0,
          "n",
          "<leader>md",
          ":Glow<CR>",
          { noremap = true, silent = true, desc = "Preview Markdown with Glow" }
        )
      end,
    })
  end,
  ft = {"markdown"},
  cmd = "Glow",
}
