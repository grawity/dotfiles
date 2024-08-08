require("lazy").setup({
	spec = {
		{
			"epwalsh/obsidian.nvim",
			version = "*",
			--lazy = true,
			--ft = "markdown",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("obsidian").setup({
					ui = {
						-- disable fancy features that require conceallevel
						enable = false,
					},
					workspaces = {
						{
							name = "personal",
							path = "~/test",
						},
					},
				})
			end,
		},
	},
})
