---@module "neominimap.config.meta"
return {
  "Isrothy/neominimap.nvim",
  version = "v3.x.x",
  lazy = false,
  keys = {
    { "<leader>ns",  "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
    { "<leader>nm",  "<cmd>Neominimap Toggle<cr>",      desc = "Toggle global minimap" },
    { "<leader>nbt", "<cmd>Neominimap BufToggle<cr>",   desc = "Toggle minimap for current buffer" },

    -- System
    { "<leader>nc",  "<cmd>Neominimap Disable<cr>",     desc = "Disable global minimap" },
    { "<leader>nr",  "<cmd>Neominimap Refresh<cr>",     desc = "Refresh global minimap" },
    { "<leader>nbr", "<cmd>Neominimap BufRefresh<cr>",  desc = "Refresh minimap for current buffer" },

    -- --- Off
    -- { "<leader>nbo", "<cmd>Neominimap BufEnable<cr>",   desc = "Enable minimap for current buffer" },
    -- { "<leader>nbc", "<cmd>Neominimap BufDisable<cr>",  desc = "Disable minimap for current buffer" },
    -- { "<leader>no",  "<cmd>Neominimap Enable<cr>",      desc = "Enable global minimap" },
    -- { "<leader>nf",  "<cmd>Neominimap Focus<cr>",       desc = "Focus on minimap" },
    -- { "<leader>nu",  "<cmd>Neominimap Unfocus<cr>",     desc = "Unfocus minimap" },
    -- -- Tab-Specific Minimap Controls
    -- { "<leader>ntt", "<cmd>Neominimap TabToggle<cr>",   desc = "Toggle minimap for current tab" },
    -- { "<leader>ntr", "<cmd>Neominimap TabRefresh<cr>",  desc = "Refresh minimap for current tab" },
    -- { "<leader>nto", "<cmd>Neominimap TabEnable<cr>",   desc = "Enable minimap for current tab" },
    -- { "<leader>ntc", "<cmd>Neominimap TabDisable<cr>",  desc = "Disable minimap for current tab" },
    -- -- Tab-Specific Minimap Controls
    -- { "<leader>ntt", "<cmd>Neominimap TabToggle<cr>",   desc = "Toggle minimap for current tab" },
    -- { "<leader>ntr", "<cmd>Neominimap TabRefresh<cr>",  desc = "Refresh minimap for current tab" },
    -- { "<leader>nto", "<cmd>Neominimap TabEnable<cr>",   desc = "Enable minimap for current tab" },
    -- { "<leader>ntc", "<cmd>Neominimap TabDisable<cr>",  desc = "Disable minimap for current tab" },
  },
  init = function()
    vim.g.neominimap = {
      buf_filter = function(bufnr)
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        return line_count < 4096
      end
    }

    vim.opt.wrap = false
    vim.opt.sidescrolloff = 36 -- Set a large value

    ---@type Neominimap.UserConfig
    vim.g.neominimap = {
      auto_enable = false,
    }
  end,
}
