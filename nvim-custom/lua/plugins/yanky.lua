return {
	{
		"gbprod/yanky.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			highlight = {
				timer = 150,
			},
		},
		keys = {
			{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" },
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
			{ "<leader>p", function() require("fzf-lua").yanky() end, mode = { "n", "x" }, desc = "Yank history" },
			{ "[y", "<Plug>(YankyCycleForward)", desc = "Cycle yank forward" },
			{ "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle yank backward" },
		},
	},
}
