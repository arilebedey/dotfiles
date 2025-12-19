local keymap = vim.keymap
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		opts.desc = "Show [L]SP [R]eferences"
		keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "Go to declaration"
		keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, opts)

		opts.desc = "Show [L]SP [D]efinitions"
		keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)

		opts.desc = "Show [L]SP [I]mplementations"
		keymap.set("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", opts)

		opts.desc = "Show [L]SP [T]ype definitions"
		keymap.set("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

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

		keymap.set("n", "<leader>D", vim.lsp.buf.hover, opts)

		opts.desc = "[Diagnostic] LSP Restart"
		keymap.set("n", "<leader>dr", ":LspRestart<CR>", opts)
	end,
})

local severity = vim.diagnostic.severity

vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.HINT] = "󰠠 ",
			[severity.INFO] = " ",
		},
	},
	virtual_text = {
		prefix = "●",
		spacing = 4,
		source = "if_many",
		severity = { min = severity.HINT },
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
