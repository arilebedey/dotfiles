return {
  {
    "yetone/avante.nvim",
    opts = {
      provider = "openai",
      providers = {
        openai = {
          model = "gpt-5",
        },
      },
      windows = {
        position = "right",
        wrap = true,
        height = 100,
        width = 40,
        input = { prefix = "➜ " },
        sidebar_header = {
          align = "center",
          rounded = false,
        },
      },
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        toggle = {
          default = "<leader>al",
          debug = "<leader>ad",
          hint = "<leader>ah",
        },
      },
      hints = {
        enabled = false,
      }
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
