return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "nvim-mini/mini.completion" },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      vim.lsp.config("*", {
        capabilities = require("mini.completion").get_lsp_capabilities(),
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("junheep_lsp_attach", { clear = true }),
        callback = function(args)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
            buffer = args.buf,
            desc = "Goto Definition",
          })
          -- these replace the core gr*/grx keymaps mini.operators claims for "gr" (replace)
          vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Actions" })
          vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = args.buf, desc = "Implementation" })
          vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { buffer = args.buf, desc = "Lens" })
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = args.buf, desc = "Rename" })
          vim.keymap.set("n", "<leader>lR", vim.lsp.buf.references, { buffer = args.buf, desc = "References" })
          vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, { buffer = args.buf, desc = "Type Definition" })
          vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        virtual_lines = { current_line = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      for server, config in pairs(opts.servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },
}
