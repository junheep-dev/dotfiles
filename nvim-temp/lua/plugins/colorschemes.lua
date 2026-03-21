return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
  },
  { "sainnhe/gruvbox-material", lazy = true },
  { "sainnhe/sonokai", lazy = true },
  { "projekt0n/github-nvim-theme", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },

  {
    name = "theme-hotreload",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyReload",
        callback = function()
          vim.schedule(function()
            local colorscheme = vim.g.colorscheme or "tokyonight"

            -- Clear all highlight groups before applying new theme
            vim.cmd("highlight clear")
            if vim.fn.exists("syntax_on") then
              vim.cmd("syntax reset")
            end

            -- Reset background to default so colorscheme can set it properly
            vim.o.background = "dark"

            -- Load the colorscheme plugin
            pcall(function()
              require("lazy.core.loader").colorscheme(colorscheme)
            end)

            vim.defer_fn(function()
              pcall(vim.cmd.colorscheme, colorscheme)
              vim.cmd("redraw!")
            end, 5)
          end)
        end,
      })
    end,
  },
}
