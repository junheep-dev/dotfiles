return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json", "json5" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "json-lsp", "prettierd" } },
  },
  { "b0o/SchemaStore.nvim" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          before_init = function(_, config)
            config.settings.json.schemas = config.settings.json.schemas or {}
            vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        json = { "prettierd" },
        jsonc = { "prettierd" },
      },
    },
  },
}
