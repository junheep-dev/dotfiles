return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.stdpath("config") .. "/nvim.markdownlint.json", "-" },
        },
      },
    },
    config = function(_, opts)
      local lint = require("lint")

      -- Merge linters_by_ft
      for ft, linters in pairs(opts.linters_by_ft) do
        lint.linters_by_ft[ft] = linters
      end

      -- Merge linter configs
      for name, config in pairs(opts.linters or {}) do
        if type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], config)
        else
          lint.linters[name] = config
        end
      end

      -- Debounced linting
      local timer = nil
      local function debounced_lint()
        if timer then
          timer:stop()
        end
        timer = vim.defer_fn(function()
          lint.try_lint()
        end, 100)
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = debounced_lint,
      })
    end,
  },
}
