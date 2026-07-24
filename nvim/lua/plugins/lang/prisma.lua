-- prismals wraps `prisma format` and advertises documentFormattingProvider, so
-- no conform formatter is registered for `prisma`: conform falls back to LSP
-- formatting. (prettier needs the third-party prettier-plugin-prisma; the
-- built-in formatter is the same engine and needs nothing extra.)
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "prisma" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "prisma-language-server" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { prismals = {} } },
  },
}
