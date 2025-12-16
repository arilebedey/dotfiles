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

    -- ✅ Get editor dimensions
    local function get_editor_dims()
      return {
        width = vim.o.columns,
        height = vim.o.lines,
      }
    end

    local dims = get_editor_dims()
    local tree_width = 0
    if dims.width > 140 then
      tree_width = math.floor(dims.width / 4)
    else
      tree_width = math.floor(dims.width / 5)
    end

    -- Dynamic setup
    local full_config = {
      on_attach = my_on_attach,
      view = {
        width = tree_width,
        relativenumber = true,
      },
      renderer = {
        indent_markers = { enable = true },
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

    -- custom function for opening at parent
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
      local ok2, nvim_tree_mod = pcall(require, "nvim-tree")
      if ok2 then
        pcall(vim.cmd, "NvimTreeClose")
        full_config.actions.open_file.quit_on_open = vim.g.nvim_tree_quit_on_open
        nvim_tree_mod.setup(full_config)
      end
    end

    -- Auto-open tree on startup if preference is enabled
    if tree_state then
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          -- prevent opening for certain cases like git commit (.git/COMMIT_EDITMSG)
          local ignored_ft = { "gitcommit" }
          if vim.tbl_contains(ignored_ft, vim.bo[data.buf].filetype) then
            return
          end

          -- check if we opened a directory
          local file = vim.api.nvim_buf_get_name(data.buf)
          local stat = vim.loop.fs_stat(file)
          local api = require("nvim-tree.api")

          if stat and stat.type == "directory" then
            vim.cmd.cd(file)
            api.tree.open()
            -- focus back to main window (not tree)
            vim.cmd.wincmd("p")
          else
            api.tree.open()
            -- focus back to main window (not tree)
            vim.cmd.wincmd("p")
          end
        end,
      })
    end

    -- Keymaps
    local keymap = vim.keymap
    keymap.set("n", "-.", "<cmd>NvimTreeOpen<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "-w", toggle_and_navigate_parent, { desc = "Toggle file explorer and navigate to parent" })
    keymap.set("n", "--w", "<cmd>NvimTreeFindFile<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>.", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>tz", toggle_tree_state, { desc = "Toggle NvimTree stay open behavior" })

    -- Auto-close NvimTree before quitting Neovim
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if api.tree.is_visible() then
          api.tree.close()
        end
      end,
    })
  end,
}
