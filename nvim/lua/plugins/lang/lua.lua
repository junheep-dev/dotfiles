return {
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { lua = { "stylua" } } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "stylua" } },
  },
}
