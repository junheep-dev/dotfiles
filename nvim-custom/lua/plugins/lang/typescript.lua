return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typescript", "tsx", "javascript", "jsdoc" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "vtsls" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { vtsls = {} } },
  },
}
