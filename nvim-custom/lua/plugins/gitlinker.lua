return {
	{
		"ruifm/gitlinker.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			{
				"<leader>gy",
				function()
					require("gitlinker").get_buf_range_url("n")
				end,
				desc = "Copy git url",
				mode = "n",
			},
			{
				"<leader>gy",
				function()
					require("gitlinker").get_buf_range_url("v")
				end,
				desc = "Copy git url",
				mode = "v",
			},
		},
	},
}
