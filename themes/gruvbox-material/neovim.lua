return {
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.g.gruvbox_material_enable_italic = true
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox-material",
		},
	},
}
