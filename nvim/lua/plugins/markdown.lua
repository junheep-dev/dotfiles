return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.stdpath("config") .. "/nvim.markdownlint.json", "-" },
        },
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        -- Use thick border for code blocks to prevent height shifting
        -- when switching between normal and insert modes
        border = "thick",
      },
    },
  },
}
