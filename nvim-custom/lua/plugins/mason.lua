return {
	{
		"mason-org/mason.nvim",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")

			-- Re-trigger FileType after an install so the new LSP server attaches automatically
			mr:on("package:install:success", function()
				vim.schedule(function()
					vim.api.nvim_exec_autocmds("FileType", { buffer = vim.api.nvim_get_current_buf() })
				end)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local pkg = mr.get_package(tool)
					if not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end,
	},
}
