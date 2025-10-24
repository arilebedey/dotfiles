return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      opts = { lsp = { auto_attach = true } },
    },
  },

  config = function()
    local lsp_switcher = require("ari.core.functions.lsp_switcher")
    if lsp_switcher.current_state == "off" then
      vim.notify("LSP disabled by user setting", vim.log.levels.WARN)
      return
    end

    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      virtual_text = {
        prefix = "●",
        spacing = 4,
        source = "if_many",
        severity = { min = vim.diagnostic.severity.HINT },
      },
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
      update_in_insert = false,
      severity_sort = true,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local keymap = vim.keymap
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show [L]SP [R]eferences"
        keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show [L]SP [D]efinitions"
        keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)

        opts.desc = "Show [L]SP [I]mplementations"
        keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)

        opts.desc = "Show [L]SP [T]ype definitions"
        keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, opts)

        opts.desc = "See available [L]SP code [A]ctions"
        keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, opts)

        opts.desc = "[LSP] Smart re[n]ame"
        keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>db", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line [D]iagnostics"
        keymap.set("n", "<leader>dl", function()
          vim.diagnostic.open_float({ focus = true })
        end, opts)

        opts.desc = "Focus diagnostic float window"
        keymap.set("n", "<leader>df", "<cmd>wincmd w<CR>", opts)

        opts.desc = "[D]iagnostic [P]revious"
        keymap.set("n", "<leader>dp", function()
          vim.diagnostic.goto_prev({ float = true })
        end, opts)

        opts.desc = "[D]iagnostic [N]ext"
        keymap.set("n", "<leader>dn", function()
          vim.diagnostic.goto_next({ float = true })
        end, opts)

        opts.desc = "[Diagnostic] Show documentation (hover)"
        keymap.set("n", "<leader>dd", vim.lsp.buf.hover, opts)

        opts.desc = "[Diagnostic] LSP Restart"
        keymap.set("n", "<leader>dr", ":LspRestart<CR>", opts)
      end,
    })

    local capabilities = cmp_nvim_lsp.default_capabilities()

    local configs = {
      ts_ls = {
        capabilities = capabilities,
      },
      html = {
        capabilities = capabilities,
      },
      cssls = {
        capabilities = capabilities,
      },
      tailwindcss = {
        capabilities = capabilities,
      },
      prismals = {
        capabilities = capabilities,
      },
      pyright = {
        capabilities = capabilities,
      },
      clangd = {
        capabilities = capabilities,
        cmd = { "clangd", "--compile-commands-dir=." },
      },

      svelte = {
        capabilities = capabilities,
        on_attach = function(client, _)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      },

      graphql = {
        capabilities = capabilities,
        filetypes = {
          "graphql",
          "gql",
          "svelte",
          "typescriptreact",
          "javascriptreact",
        },
      },

      emmet_ls = {
        capabilities = capabilities,
        filetypes = {
          "html",
          "typescriptreact",
          "javascriptreact",
          "css",
          "sass",
          "scss",
          "less",
          "svelte",
        },
      },

      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      },

      gopls = {
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
          },
        },
      },
    }

    for server, config in pairs(configs) do
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end

    mason_lspconfig.setup_handlers({
      function(server_name)
        if not configs[server_name] then
          vim.lsp.config(server_name, { capabilities = capabilities })
          vim.lsp.enable(server_name)
        end
      end,
    })
  end,
}
