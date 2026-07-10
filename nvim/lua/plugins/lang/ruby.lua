local function warn_if_missing(cmd, hint)
  if vim.fn.executable(cmd) == 0 then
    vim.notify(("[ruby.lua] `%s` not found — %s"):format(cmd, hint), vim.log.levels.WARN)
  end
end

-- ruby_lsp has rubocop built in (diagnostics + formatting, project-Gemfile-aware
-- via its own bundle detection) whenever rubocop is in the project's Gemfile, so
-- no separate rubocop LSP server or conform formatter is needed here: conform
-- falls back to LSP formatting since no formatter is registered for `ruby`.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ruby" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          before_init = function()
            warn_if_missing("ruby-lsp", "install with `gem install ruby-lsp`")
          end,
          init_options = {
            addonSettings = {
              ["Ruby LSP Rails"] = {
                enablePendingMigrationsPrompt = false,
              },
            },
          },
        },
      },
    },
  },
}
