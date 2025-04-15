-- INFO: Integrates autocompletion with language server
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
        "MunifTanjim/nui.nvim"
      },
      opts = { lsp = { auto_attach = true } }
    }
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    -- Add diagnostic configuration here
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "if_many", -- Changed from "always" to "if_many"
        header = "",
        prefix = "",
      },
    })

    vim.diagnostic.config({
      virtual_text = {
      prefix = '●', -- Could be '■', '▎', 'x', '●', etc
      spacing = 4,
      source = "if_many",
      severity = {
        min = vim.diagnostic.severity.HINT,
        },
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show [L]SP [R]eferences"
        keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, opts) -- go to declaration

        -- Where in the project it is defined
        opts.desc = "Show [L]SP [D]efinitions"
        keymap.set("n", "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show [L]SP [I]mplementations"
        keymap.set("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show [L]SP [T]ype definitions"
        keymap.set("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available [L]SP code [A]ctions"
        keymap.set({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        -- Should work renaming vars in whole project
        opts.desc = "[LSP] Smart re[n]ame"
        keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>db", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line [D]iagnostics"
        keymap.set("n", "<leader>dl", function()
          vim.diagnostic.open_float({ focus = true })
        end, opts) -- show diagnostics for line with focus

        -- Add a keymap to focus the diagnostic float window
        opts.desc = "Focus diagnostic float window"
        keymap.set("n", "<leader>df", "<cmd>wincmd w<CR>", opts)

        opts.desc = "[D]iagnostic [P]revious"
        keymap.set("n", "<leader>dp", function()
          vim.diagnostic.goto_prev({ float = true })
        end, opts) -- jump to previous diagnostic in buffer with float window

        opts.desc = "[D]iagnostic [N]ext"
        keymap.set("n", "<leader>dn", function()
          vim.diagnostic.goto_next({ float = true })
        end, opts) -- jump to next diagnostic in buffer with float window

        opts.desc = "[Diagnostic] Show documentation for what is under cursor"
        keymap.set("n", "<leader>dd", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "[Diagnostic] LSP Restart"
        keymap.set("n", "<leader>dr", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    -- Replace the sign_define block with this:
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      -- Keep your other diagnostic settings
      virtual_text = {
        prefix = '●',
        spacing = 4,
        source = "if_many",
        severity = {
          min = vim.diagnostic.severity.HINT,
        },
      },
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "if_many", -- Changed from "always" to "if_many"
        header = "",
        prefix = "",
      },
      -- Your other settings...
      update_in_insert = false,
      severity_sort = true,
    })

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["svelte"] = function()
        -- configure svelte server
        lspconfig["svelte"].setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                -- Here use ctx.match instead of ctx.file
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end,
        })
      end,
      ["graphql"] = function()
        -- configure graphql language server
        lspconfig["graphql"].setup({
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      end,
      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
      ["gopls"] = function()
        lspconfig["gopls"].setup({
          capabilities = capabilities,
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
            },
          },
        })
      end,
    })
  end,
}
