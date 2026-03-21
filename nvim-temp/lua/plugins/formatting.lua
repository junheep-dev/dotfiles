return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        css = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        vue = { "prettier" },
        svelte = { "prettier" },
        graphql = { "prettier" },
        markdown = { "prettier" },
        ruby = { "rubocop" },
      },
      format_on_save = function(bufnr)
        local buf_autoformat = vim.b[bufnr].autoformat
        if buf_autoformat == false then
          return
        end
        if buf_autoformat == nil and not vim.g.autoformat then
          return
        end
        return { timeout_ms = 3000, lsp_fallback = true }
      end,
      formatters = {
        rubocop = {
          command = "bundle",
          prepend_args = { "exec", "rubocop" },
        },
      },
    },
  },
}
