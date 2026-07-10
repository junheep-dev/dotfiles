return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- https://cmp.saghen.dev/recipes.html#hide-copilot-on-suggestion
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          require("copilot.suggestion").dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
          -- Enable when want to trigger copilot automatically after cmp menu closes
          -- require("copilot.suggestion").next()
        end,
      })

      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
        preset = "super-tab",
        ["<M-]>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.hide()
            end
            require("copilot.suggestion").next()
          end,
        },
        ["<M-[>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.hide()
            end
            require("copilot.suggestion").prev()
          end,
        },
      })

      return opts
    end,
  },
}
