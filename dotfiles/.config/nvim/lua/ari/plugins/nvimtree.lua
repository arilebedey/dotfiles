return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")
    local tree_config = require("ari.core.functions.tree_config")

    -- delete s key mapping
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.del("n", "s", { buffer = bufnr })
      vim.keymap.del("n", "-", { buffer = bufnr })
    end

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Load tree_shown preference
    local tree_state = tree_config.get_tree_state()
    vim.g.nvim_tree_quit_on_open = not tree_state

    -- ✅ Detect screen width on Linux or macOS
    local function get_screen_width()
      if vim.fn.has("macunix") == 1 then
        -- macOS: parse system_profiler output
        local ok, output =
            pcall(vim.fn.system, "system_profiler SPDisplaysDataType | grep Resolution | head -n1")
        if ok and output and output ~= "" then
          local w = tonumber(output:match("Resolution:%s+(%d+)%s*x%s*%d+"))
          return w
        end
      else
        -- Linux (xrandr)
        local ok, output =
            pcall(vim.fn.system, "xrandr | grep '*' | head -n1 | awk '{print $1}'")
        if ok and output and output ~= "" then
          output = vim.trim(output)
          local w = tonumber(output:match("^(%d+)x%d+"))
          return w
        end
      end
      return nil
    end

    local screen_width = get_screen_width()
    local width = 25
    if screen_width and screen_width > 1440 then
      width = 40
    end

    -- Store the full configuration so we can reuse it when toggling
    local full_config = {
      on_attach = my_on_attach,
      view = {
        width = width, -- dynamically chosen width
        relativenumber = true,
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            },
          },
        },
      },
      actions = {
        open_file = {
          window_picker = { enable = false },
          quit_on_open = vim.g.nvim_tree_quit_on_open,
        },
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = true,
        },
      },
      filters = { custom = { ".DS_Store" } },
      git = { ignore = false },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      diagnostics = { enable = true },
    }

    nvimtree.setup(full_config)

    -- custom fn for opening at parent
    local api = require("nvim-tree.api")
    local function toggle_and_navigate_parent()
      if vim.fn.exists("g:nvim_tree_win_id") == 1 then
        pcall(vim.cmd, "NvimTreeClose")
      end
      vim.cmd("NvimTreeFindFile")
      vim.defer_fn(function()
        api.node.navigate.parent()
      end, 50)
    end

    local function toggle_tree_state()
      local new_state = tree_config.toggle_tree_state()
      vim.g.nvim_tree_quit_on_open = not new_state
      if new_state then
        vim.notify("NvimTree: Will stay open when selecting files", vim.log.levels.INFO)
      else
        vim.notify("NvimTree: Will close when selecting files", vim.log.levels.INFO)
      end
      local ok2, nvim_tree_mod = pcall(require, "nvim-tree")
      if ok2 then
        pcall(vim.cmd, "NvimTreeClose")
        full_config.actions.open_file.quit_on_open = vim.g.nvim_tree_quit_on_open
        nvim_tree_mod.setup(full_config)
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
