return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typescript", "tsx", "javascript", "jsdoc" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "vtsls", "prettierd" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { vtsls = {} } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
      },
    },
  },
}
