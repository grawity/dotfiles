require("lazy").setup({
	spec = {
		--{ "EdenEast/nightfox.nvim" },
		{ url = "https://tpope.io/vim/eunuch.git" },
		{ url = "https://github.com/preservim/tagbar" },
	},
	performance = {
		rtp = {
			reset = false,
			paths = {
				"~/.config/nvim/pack/*/start/*",
			},
		},
	},
})
