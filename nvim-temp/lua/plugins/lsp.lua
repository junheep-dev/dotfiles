return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local utils = require("utils")
      local icons = utils.icons.diagnostics

      -- Diagnostics
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.HINT] = icons.Hint,
            [vim.diagnostic.severity.INFO] = icons.Info,
          },
        },
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      })

      -- LspAttach keymaps and settings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(event)
          local buf = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end

          map("n", "gd", function()
            require("fzf-lua").lsp_definitions()
          end, "Goto Definition")
          map("n", "gr", function()
            require("fzf-lua").lsp_references()
          end, "References")
          map("n", "gI", function()
            require("fzf-lua").lsp_implementations()
          end, "Goto Implementation")
          map("n", "gy", function()
            require("fzf-lua").lsp_typedefs()
          end, "Goto Type Definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>cA", function()
            vim.lsp.buf.code_action({
              context = { only = { "source" }, diagnostics = {} },
            })
          end, "Source Action")

          -- Disable inlay hints
          if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(false, { bufnr = buf })
          end

          -- LSP fold support
          if client.supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
          end
        end,
      })

      -- Check and install ruby-lsp asynchronously
      vim.system({ "gem", "list", "ruby-lsp" }, {}, function(result)
        if result.code == 0 and not result.stdout:match("^ruby%-lsp%s") then
          vim.notify("ruby-lsp gem not found, installing...", vim.log.levels.INFO)
          vim.system({ "gem", "install", "ruby-lsp", "--no-document" }, {}, function(install_result)
            if install_result.code == 0 then
              vim.notify("ruby-lsp gem installed successfully", vim.log.levels.INFO)
              vim.schedule(function()
                vim.cmd("LspStart ruby_lsp")
              end)
            else
              vim.notify("Failed to install ruby-lsp gem", vim.log.levels.ERROR)
            end
          end)
        end
      end)

      -- Server configurations (Neovim 0.11+ style)
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        vtsls = {
          filetypes = vim.lsp.config.vue_ls and {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
          } or nil,
          settings = {
            complete_function_calls = true,
            typescript = {
              preferences = {
                autoImportFileExcludePatterns = {
                  "node_modules/@anthropic-ai/sdk",
                },
              },
            },
          },
        },
        vue_ls = {
          init_options = {
            typescript = {
              tsdk = utils.get_pkg_path("vtsls", "node_modules/typescript/lib"),
            },
          },
        },
        tailwindcss = {},
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        taplo = {},
        prismals = {},
        typos_lsp = {
          init_options = {
            diagnosticSeverity = "Hint",
          },
        },
        ruby_lsp = {
          mason = false,
          cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
          init_options = {
            addonSettings = {
              ["Ruby LSP Rails"] = {
                enablePendingMigrationsPrompt = false,
              },
            },
          },
        },
        rubocop = {
          mason = false,
          cmd = { "bundle", "exec", "rubocop", "--lsp" },
        },
      }

      local server_names = {}
      for name, config in pairs(servers) do
        -- Skip mason=false servers from mason-lspconfig
        if config.mason ~= false then
          vim.lsp.config(name, config)
        else
          -- For non-mason servers, strip the mason key before passing config
          local cfg = vim.tbl_extend("force", {}, config)
          cfg.mason = nil
          vim.lsp.config(name, cfg)
        end
        table.insert(server_names, name)
      end

      vim.lsp.enable(server_names)
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = { "stylua", "shfmt", "prettier" },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    opts = {
      automatic_enable = true,
    },
  },

  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    ft = { "json", "jsonc", "yaml" },
  },

}
