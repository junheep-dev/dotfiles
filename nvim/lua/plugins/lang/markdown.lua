-- markdown/markdown_inline treesitter parsers are bundled by core, so there's
-- no ensure_installed entry here (nothing to install).
return {
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { marksman = {} } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "marksman" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { markdown = { "prettierd" } },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
