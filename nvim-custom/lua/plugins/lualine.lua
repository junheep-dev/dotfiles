return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			options = {
				theme = "auto",
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {},
				lualine_x = { "encoding", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			extensions = { "neo-tree", "lazy", "fzf", "mason" },
		},
	},
}
