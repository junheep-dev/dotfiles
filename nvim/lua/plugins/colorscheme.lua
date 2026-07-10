return {
  {
    "folke/tokyonight.nvim",
    lazy = false, -- main theme: load on startup, not lazily
    priority = 1000, -- load before other plugins so highlights aren't clobbered
    opts = { style = "moon" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
