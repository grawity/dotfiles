require("lazy").setup({
	spec = {
		{
			url = "https://tpope.io/vim/eunuch.git",
		},
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
