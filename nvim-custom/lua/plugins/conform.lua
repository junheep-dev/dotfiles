return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason-org/mason.nvim" },
    lazy = false,
    keys = {
      {
        "<leader>lf",
        function()
          require("conform").format()
        end,
        mode = { "n", "x" },
        desc = "Format",
      },
    },
    opts = {
      -- Will be added by each lua file under /lang directory
      formatters_by_ft = {},
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
          return
        end
        return { timeout_ms = 500 }
      end,
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
