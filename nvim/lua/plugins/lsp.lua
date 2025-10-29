return {
  -- see https://github.com/LazyVim/LazyVim/issues/3284
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Disable inlay hints
      inlay_hints = {
        enabled = false,
      },
      servers = { typos_lsp = {} },
      setup = {
        typos_lsp = function(_)
          local lspconfig = require("lspconfig")
          lspconfig.typos_lsp.setup({
            init_options = {
              -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
              diagnosticSeverity = "Hint",
            },
          })
          return true -- This prevents LazyVim's automatic setup
        end,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
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

      opts.servers.ruby_lsp = {
        -- https://shopify.github.io/ruby-lsp/editors.html#lazyvim-lsp
        mason = false,
        cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
      }
      opts.setup.ruby_lsp = function(_)
        local lspconfig = require("lspconfig")
        lspconfig.ruby_lsp.setup({
          init_options = {
            addonSettings = {
              ["Ruby LSP Rails"] = {
                enablePendingMigrationsPrompt = false,
              },
            },
          },
        })
        return true -- This prevents LazyVim's automatic setup
      end

      opts.servers.rubocop = {
        mason = false,
        cmd = { "bundle", "exec", "rubocop", "--lsp" },
      }

      return opts
    end,
  },
}
