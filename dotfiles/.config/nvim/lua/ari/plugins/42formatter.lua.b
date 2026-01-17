return {
	"Diogo-ss/42-C-Formatter.nvim",
	ft = { "c" },
	cmd = "CFormat42",
	config = function()
		local uv = vim.uv or vim.loop

		if uv.os_uname().sysname == "Darwin" then
			local venv_path = "/Users/ari/.venv/c-formatter-42/bin"
			vim.env.PATH = venv_path .. ":" .. vim.env.PATH
		end

		local formatter = require("42-formatter")

		formatter.setup({
			formatter = "c_formatter_42",
			filetypes = {
				c = true,
			},
		})

		local group = vim.api.nvim_create_augroup("C_format_42", { clear = true })

		vim.api.nvim_create_autocmd("BufWritePost", {
			group = group,
			pattern = "*.c",
			callback = function()
				vim.cmd("silent CFormat42")
				vim.cmd("silent write")
			end,
		})
	end,
}
