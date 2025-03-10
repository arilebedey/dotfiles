return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

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

    nvimtree.setup({
      on_attach = my_on_attach,
      view = {
        width = 35,
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
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
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
          quit_on_open = true,
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- custom fn for opening at parent
    local api = require('nvim-tree.api')
    local function toggle_and_navigate_parent()
      -- Toggle the file explorer
      vim.cmd('NvimTreeFindFile')
      -- Navigate to the parent node
      api.node.navigate.parent()
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
  end
}
