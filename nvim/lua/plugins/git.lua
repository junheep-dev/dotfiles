return {
  {
    "lewis6991/gitsigns.nvim",
    config = function(_, opts)
      require("gitsigns").setup(opts)
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },

  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      opts = {
        add_current_line_on_normal_mode = false,
      },
    },
    keys = {
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("n")
        end,
        desc = "Copy git url (gitlinker)",
        mode = { "n" },
      },
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("v")
        end,
        desc = "Copy git url (gitlinker)",
        mode = { "v" },
      },
    },
  },
}
