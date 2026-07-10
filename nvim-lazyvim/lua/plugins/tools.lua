return {
  -- https://github.com/edkolev/tmuxline.vim
  -- Generate tmux theme from vim statusline colors
  {
    "edkolev/tmuxline.vim",
    cmd = { "Tmuxline", "TmuxlineSnapshot" },
  },

  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        dir_path = "",
        relative_to_current_file = true,
        drag_and_drop = {
          enabled = false,
        },
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    opts = {
      files = {
        fzf_opts = {
          ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
        },
      },
      grep = {
        fzf_opts = {
          ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
        },
      },
      keymap = {
        fzf = {
          ["up"] = "prev-history",
          ["down"] = "next-history",
          ["ctrl-p"] = "up",
          ["ctrl-n"] = "down",
        },
      },
    },
  },
}
