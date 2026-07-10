return {
  {
    "snacks.nvim",
    opts = {
      -- Disable scroll animation
      scroll = { enabled = false },
      -- ImageMagick(brew install imagemagick) is required for image support
      image = {
        doc = {
          enabled = true,
        },
      },
    },
  },

  {
    "neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { ".git" },
        },
      },
    },
  },

  -- https://github.com/petertriho/nvim-scrollbar
  {
    "petertriho/nvim-scrollbar",
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    -- For hugo template
    opts = { ensure_installed = { "gotmpl" } },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        -- Disable default time display
        lualine_z = {},
      },
    },
  },
}
