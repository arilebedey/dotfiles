return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-s>"] = actions.move_selection_previous, -- move to prev result
            ["<C-t>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-p>"] = trouble_telescope.open,
          },
        },
        -- path_display : smart displays parent directory only
        -- path_display = { "smart" },
        previewer = true,
        dynamic_preview_title = true,
        path_display = {
          filename_first = {
            reverse_directories = false,
          }
        },
      },
      pickers = {
        lsp_document_symbols = {
          theme = "ivy",
        },
        oldfiles = {
          theme = "ivy",
        },
        find_files = {
          theme = "ivy",
        },
        live_grep = {
          theme = "ivy",
        },
        help_tags = {
          theme = "ivy",
        },
        marks = {
          attach_mappings = function(prompt_bufnr, map)
            map("i", "<C-d>", function()
              require("telescope.actions").delete_mark(prompt_bufnr)
            end)
            return true -- Keep default mappings as well as the custom ones
          end,
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps

    local kms = vim.keymap.set

    kms("n", "<leader>ss", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy [S]earch recent file[S]" })

    kms("n", "<leader>st", "<cmd>Telescope find_files theme=ivy<CR>",
      { desc = "Fuzzy [S]earch Files in [P]roject (cwd)" })
    kms("n", "<leader>sg", "<cmd>Telescope find_files theme=ivy<CR>",
      { desc = "Fuzzy [S]earch Files in [P]roject (cwd)" })

    kms("n", "<leader>sh", "<cmd>Telescope live_grep theme=ivy<CR>",
      { desc = "Fuzzy [S]earch strings with [G]rep in CWD" })
    kms("n", "<leader>sp", "<cmd>Telescope live_grep theme=ivy<CR>",
      { desc = "Fuzzy [S]earch strings with [G]rep in CWD" })

    kms("n", "<leader>m", "<cmd>Telescope frecency workspace=CWD theme=ivy<CR>",
      { desc = "Fuzzy [S]earch recent file[S]sssss" })
    kms("n", "<leader>sl", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "[S]ee [L]SP Document Symbols" })
    kms("n", "<leader>sc", "<cmd>Telescope grep_string<CR>", { desc = "Fuzzy [S]earch string under [C]ursor" })

    kms("n", "<leader>sm", "<cmd>Telescope marks<CR>", { desc = "[S]earch [M]arks" })
    -- TODO
    kms("n", "<leader>sd", "<cmd>TodoTelescope<CR>", { desc = "[S]ee [T]ODO Comment List" })
    kms('n', '<leader>sb', ':lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>',
      { desc = "[S]earch [B]uffer" })
    kms('n', '<leader>/', ':lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>',
      { desc = "[S]earch [B]uffer" })
    kms("n", "<leader>sf", "<cmd>Telescope frecency workspace=CWD theme=ivy<CR>",
      { desc = "[S]earch [F]requent files" })
  end,
}
