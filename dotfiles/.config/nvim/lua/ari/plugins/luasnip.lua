return {
	-- luacheck: ignore
	-- Snippet engine for Neovim, Added event for lazy loading
	-- Using neotab as default fallback for <tab> and tabout for <s-tab>
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		keys = {
			{ "<tab>", mode = { "i", "s" }, false },
			{ "<s-tab>", mode = { "i", "s" }, false },
			{
				"<C-n>",
				function()
					if require("luasnip").jumpable(1) then
						require("luasnip").jump(1)
					end
				end,
				mode = { "i", "s" },
				desc = "LuaSnip Forward Jump",
			},
			{
				"<C-p>",
				function()
					if require("luasnip").jumpable(-1) then
						require("luasnip").jump(-1)
					end
				end,
				mode = { "i", "s" },
				desc = "LuaSnip Backward Jump",
			},
			{
				"<C-s>",
				function()
					if require("luasnip").expandable() then
						require("luasnip").expand()
					end
				end,
				mode = "i",
				desc = "LuaSnip Expand",
			},
			{
				"<C-e>",
				function()
					if require("luasnip").expand_or_jumpable() then
						require("luasnip").expand_or_jump()
					end
				end,
				mode = "i",
				silent = true,
				noremap = true,
			},
		},
	},
}
