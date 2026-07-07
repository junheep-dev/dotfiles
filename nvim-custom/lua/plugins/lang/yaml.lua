return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "yaml" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "yaml-language-server", "prettierd" } },
  },
  { "b0o/SchemaStore.nvim" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          before_init = function(_, config)
            config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = {
                enable = false,
                url = "",
              },
            },
          },
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = true
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { yaml = { "prettierd" } },
    },
  },
}
