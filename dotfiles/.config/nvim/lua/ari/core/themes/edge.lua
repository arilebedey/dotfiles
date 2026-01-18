local M = {}
M.config = function()
	vim.g.edge_style = "neon"
	vim.g.edge_colors_override = {
		bg0 = { "#22202b", "234" },
		bg1 = { "#292530", "235" },
		bg2 = { "#302c38", "236" },
	}
	vim.cmd("colorscheme edge")
	vim.cmd("set laststatus=0")
end
return {
	{ "sainnhe/edge", priority = 1000, config = M.config },
}
