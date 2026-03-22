return {
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			options = {
				mode = "tabs",
				separator_style = "slant",
				diagnostics = "nvim_lsp",
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
		},
	},
}
