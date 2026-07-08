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
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    opts = {
      code = {
        -- thick border keeps code block height stable across normal/insert mode
        border = "thick",
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
