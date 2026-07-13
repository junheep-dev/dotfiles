return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "lua", "luadoc" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "stylua", "lua-language-server" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { lua_ls = {} } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { lua = { "stylua" } },
      -- Force 2-space indent without a repo stylua.toml (CLI flags win over any config file)
      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
      },
    },
  },
  -- Neovim runtime + `vim` global awareness when editing config files
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
