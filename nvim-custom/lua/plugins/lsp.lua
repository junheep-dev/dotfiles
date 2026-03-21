return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
				callback = function(event)
					local buf = event.buf
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
					end

					map("n", "gd", function()
						require("fzf-lua").lsp_definitions()
					end, "Goto Definition")
					map("n", "gr", function()
						require("fzf-lua").lsp_references()
					end, "References")
					map("n", "gI", function()
						require("fzf-lua").lsp_implementations()
					end, "Goto Implementation")
					map("n", "gy", function()
						require("fzf-lua").lsp_typedefs()
					end, "Goto Type Definition")
					map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
					map("n", "K", vim.lsp.buf.hover, "Hover")
					map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
				end,
			})

			local servers = {
				lua_ls = {},
			}

			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
			end
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		opts = {
			ensure_installed = { "lua_ls" },
			automatic_enable = false,
		},
	},
}
