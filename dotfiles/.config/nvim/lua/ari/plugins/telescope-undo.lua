return {
  "debugloop/telescope-undo.nvim",
  dependencies = { -- note how they're inverted to above example

    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
  },
  keys = {
    { -- lazy style key map
      "<leader>ut",
      "<cmd>Telescope undo<cr>",
      desc = "[U]ndo [T]elescope",
    },

  },
  opts = {
    -- don't use `defaults = { }` here, do this in the main telescope spec   
    extensions = {
      undo = {
        use_delta = true,
        use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
        side_by_side = false,
        -- side_by_side = true,
        -- layout_strategy = "vertical",
        -- layout_config = {
        --   preview_height = 0.8,
        -- },
        vim_diff_opts = {
          ctxlen = vim.o.scrolloff,
        },
        entry_format = "state #$ID, $STAT, $TIME",
        time_format = "",
        saved_only = false,
        -- theme = "ivy"
        mappings = {
          i = {
            ["<C-n>"] = function(bufnr)
              return require("telescope-undo.actions").yank_additions(bufnr)
            end,
            ["<C-d>"] = function(bufnr)
              return require("telescope-undo.actions").yank_deletions(bufnr)
            end,
            -- ["<C-CR>"] = function(bufnr)
            --   return require("telescope-undo.actions").restore(bufnr)
            -- end,
            ["<C-y>"] = function(bufnr)
              return require("telescope-undo.actions").restore(bufnr)
            end,
          },
          -- n = {
          --   ["y"] = function(bufnr)
          --     return require("telescope-undo.actions").retore(bufnr)
          --   end,
          -- },
        },
      },
      -- no other extensions here, they can have their own spec too
    },
  },
  config = function(_, opts)
    -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
    -- configs for us. We won't use data, as everything is in it's own namespace (telescope
    -- defaults, as well as each extension).
    require("telescope").setup(opts)
    require("telescope").load_extension("undo")
  end,

}
