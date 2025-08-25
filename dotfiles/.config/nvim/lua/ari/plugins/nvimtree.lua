return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")
    local tree_config = require("ari.core.functions.tree_config")

    -- delete s key mapping
    local function my_on_attach(bufnr)
      local api = require('nvim-tree.api')
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.del('n', 's', { buffer = bufnr })
      vim.keymap.del('n', '-', { buffer = bufnr })
    end

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Load tree_shown preference
    local tree_state = tree_config.get_tree_state()

    -- Store the actual quit_on_open setting in a global variable so we can toggle it
    -- This avoids having to access nvim-tree internals
    vim.g.nvim_tree_quit_on_open = not tree_state

    -- Store the full configuration so we can reuse it when toggling
    local full_config = {
      on_attach = my_on_attach,
      view = {
        width = 25,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "",   -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
          quit_on_open = vim.g.nvim_tree_quit_on_open, -- Use our global variable
        },
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = true,
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      diagnostics = {
        enable = true,
      },
    }

    nvimtree.setup(full_config)

    -- custom fn for opening at parent
    local api = require('nvim-tree.api')
    local function toggle_and_navigate_parent()
      -- Check if tree is already open
      if vim.fn.exists("g:nvim_tree_win_id") == 1 then
        -- Close tree if already open
        pcall(vim.cmd, "NvimTreeClose")
      end
      -- Toggle the file explorer
      vim.cmd('NvimTreeFindFile')
      -- Navigate to the parent node after a short delay
      vim.defer_fn(function()
        api.node.navigate.parent()
      end, 50)
    end

    -- Toggle tree_shown state
    local function toggle_tree_state()
      -- Toggle the state in the configuration file
      local new_state = tree_config.toggle_tree_state()

      -- Update the global variable
      vim.g.nvim_tree_quit_on_open = not new_state

      -- Show notification of current state
      if new_state then
        vim.notify("NvimTree: Will stay open when selecting files", vim.log.levels.INFO)
      else
        vim.notify("NvimTree: Will close when selecting files", vim.log.levels.INFO)
      end

      -- We need to apply this setting immediately
      -- Get the current NvimTree module (if loaded)
      local ok, nvim_tree_mod = pcall(require, "nvim-tree")
      if ok then
        -- Close tree if it's open
        pcall(vim.cmd, "NvimTreeClose")

        -- Update our full config
        full_config.actions.open_file.quit_on_open = vim.g.nvim_tree_quit_on_open

        -- Apply our new settings by recreating the setup with the full config
        nvim_tree_mod.setup(full_config)

        -- No need to reopen - user can open when needed
      end
    end

    -- set keymaps
    local keymap = vim.keymap                                                                  -- for conciseness

    keymap.set("n", "-.", "<cmd>NvimTreeOpen<CR>", { desc = "Toggle file explorer" })          -- toggle file explorer
    keymap.set('n', '-w', toggle_and_navigate_parent, { desc = 'Toggle file explorer and navigate to parent' })
    keymap.set("n", "--w", "<cmd>NvimTreeFindFile<CR>", { desc = "Toggle file explorer" })     -- toggle file explorer
    keymap.set("n", "<leader>.", "<cmd>NvimTreeClose<CR>", { desc = "Toggle file explorer" })  -- toggle file explorer
    keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorernvim-
    -- keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    -- keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    -- keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

    -- Add new hotkey for toggling the tree_state
    keymap.set("n", "<leader>tz", toggle_tree_state, { desc = "Toggle NvimTree stay open behavior" })
  end
}
