return {
  -- {{{ Define the Harpoon lazy.vim specificaiton.

  "ThePrimeagen/harpoon",
  enabled = true,
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  -- ----------------------------------------------------------------------- }}}
  -- {{{ Define events to load Harpoon.

  keys = function()
    local harpoon = require("harpoon")
    local conf = require("telescope.config").values

    -- basic telescope configuration
    local function toggle_telescope(harpoon_files)
      local finder = function()
        local paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(paths, item.value)
        end

        return require("telescope.finders").new_table({
          results = paths,
        })
      end

      require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = finder(),
            initial_mode = "normal",
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
              map("n", "dd", function()
                local state = require("telescope.actions.state")
                local selected_entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_bufnr)

                table.remove(harpoon_files.items, selected_entry.index)
                current_picker:refresh(finder())
              end)
              return true
            end,
          })
          :find()
    end


    return {
      -- Harpoon marked files 1 through 4
      { ",n",    function() harpoon:list():select(1) end,                     desc = "Harpoon buffer 1" },
      { ",i",    function() harpoon:list():select(2) end,                     desc = "Harpoon buffer 2" },
      { ",w",    function() harpoon:list():select(3) end,                     desc = "Harpoon buffer 3" },
      { ",-",    function() harpoon:list():select(4) end,                     desc = "Harpoon buffer 4" },
      { ",a",    function() harpoon:list():select(5) end,                     desc = "Harpoon buffer 5" },
      { ",.",    function() harpoon:list():select(6) end,                     desc = "Harpoon buffer 6" },

      -- Harpoon next and previous.
      { "<a-5>", function() harpoon:list():next() end,                        desc = "Harpoon next buffer" },
      { "<a-6>", function() harpoon:list():prev() end,                        desc = "Harpoon prev buffer" },

      -- Harpoon user interface.
      { "<a-7>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon Toggle Menu" },
      { ",l",    function() harpoon:list():add() end,                         desc = "Harpoon add file" },

      -- Use Telescope as Harpoon user interface.
      { ",u",    function() toggle_telescope(harpoon:list()) end,             desc = "Open Harpoon window" },
    }
  end,

  -- ----------------------------------------------------------------------- }}}
  -- {{{ Use Harpoon defaults or my customizations.

  opts = function(_, opts)
    opts.settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
      save_on_change = true,
      enter_on_sendcmd = false,
      tmux_autoclose_windows = false,
      excluded_filetypes = { "harpoon", "alpha", "dashboard", "gitcommit" },
      -- per git branch marks
      mark_branch = true,
      key = function()
        return vim.loop.cwd()
      end
    }
  end,

  -- ----------------------------------------------------------------------- }}}
  -- {{{ Configure Harpoon.

  config = function(_, opts)
    require("harpoon").setup(opts)
  end,

  -- ----------------------------------------------------------------------- }}}
}
