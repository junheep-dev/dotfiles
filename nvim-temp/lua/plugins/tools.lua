return {
  -- https://github.com/ibhagwan/fzf-lua
  -- Fuzzy finder
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "echasnovski/mini.icons" },
    keys = {
      -- find
      { "<leader><space>", function() require("fzf-lua").files({ cwd = require("utils").root() }) end, desc = "Find files (root)" },
      { "<leader>,", function() require("fzf-lua").buffers({ sort_lastused = true, show_flags = true }) end, desc = "Switch buffer" },
      { "<leader>/", function() require("fzf-lua").live_grep({ cwd = require("utils").root() }) end, desc = "Grep (root)" },
      { "<leader>:", function() require("fzf-lua").command_history() end, desc = "Command history" },
      { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
      { "<leader>fc", function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find config files" },
      { "<leader>ff", function() require("fzf-lua").files({ cwd = require("utils").root() }) end, desc = "Find files (root)" },
      { "<leader>fF", function() require("fzf-lua").files() end, desc = "Find files (cwd)" },
      { "<leader>fg", function() require("fzf-lua").git_files() end, desc = "Git files" },
      { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recent files" },
      { "<leader>fR", function() require("fzf-lua").oldfiles({ cwd_only = true }) end, desc = "Recent files (cwd)" },
      -- git
      { "<leader>gc", function() require("fzf-lua").git_log() end, desc = "Git commits" },
      { "<leader>gs", function() require("fzf-lua").git_status() end, desc = "Git status" },
      -- search
      { "<leader>sa", function() require("fzf-lua").autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() require("fzf-lua").grep_curbuf() end, desc = "Grep buffer" },
      { "<leader>sc", function() require("fzf-lua").command_history() end, desc = "Command history" },
      { "<leader>sC", function() require("fzf-lua").commands() end, desc = "Commands" },
      { "<leader>sd", function() require("fzf-lua").diagnostics_document() end, desc = "Diagnostics (document)" },
      { "<leader>sD", function() require("fzf-lua").diagnostics_workspace() end, desc = "Diagnostics (workspace)" },
      { "<leader>sg", function() require("fzf-lua").grep({ cwd = require("utils").root() }) end, desc = "Grep (root)" },
      { "<leader>sG", function() require("fzf-lua").grep() end, desc = "Grep (cwd)" },
      { "<leader>sh", function() require("fzf-lua").helptags() end, desc = "Help tags" },
      { "<leader>sH", function() require("fzf-lua").highlights() end, desc = "Highlights" },
      { "<leader>sj", function() require("fzf-lua").jumps() end, desc = "Jumps" },
      { "<leader>sk", function() require("fzf-lua").keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() require("fzf-lua").loclist() end, desc = "Location list" },
      { "<leader>sM", function() require("fzf-lua").manpages() end, desc = "Man pages" },
      { "<leader>sm", function() require("fzf-lua").marks() end, desc = "Marks" },
      { "<leader>sq", function() require("fzf-lua").quickfix() end, desc = "Quickfix" },
      { "<leader>sR", function() require("fzf-lua").resume() end, desc = "Resume" },
      { "<leader>ss", function() require("fzf-lua").lsp_document_symbols() end, desc = "LSP document symbols" },
      { "<leader>sS", function() require("fzf-lua").lsp_workspace_symbols() end, desc = "LSP workspace symbols" },
      { "<leader>sw", function() require("fzf-lua").grep_cword({ cwd = require("utils").root() }) end, desc = "Grep word (root)" },
      { "<leader>sW", function() require("fzf-lua").grep_cword() end, desc = "Grep word (cwd)" },
      { "<leader>sw", function() require("fzf-lua").grep_visual({ cwd = require("utils").root() }) end, mode = "v", desc = "Grep selection (root)" },
      { "<leader>sW", function() require("fzf-lua").grep_visual() end, mode = "v", desc = "Grep selection (cwd)" },
      { '<leader>s"', function() require("fzf-lua").registers() end, desc = "Registers" },
      { "<leader>uC", function() require("fzf-lua").colorschemes({ winopts = { height = 0.45, width = 0.30 } }) end, desc = "Colorschemes with preview" },
    },
    opts = {
      "default-title",
      fzf_colors = true,
      defaults = {
        formatter = "path.dirname_first",
      },
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
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select()
    end,
  },

  -- https://github.com/gbprod/yanky.nvim
  -- Better yank/paste
  {
    "gbprod/yanky.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = {
        timer = 150,
      },
    },
    keys = {
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
      { "<leader>p", function() require("fzf-lua").yanky() end, mode = { "n", "x" }, desc = "Yank history" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after (leave cursor)" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before (leave cursor)" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle yank forward" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle yank backward" },
    },
  },

  -- https://github.com/folke/persistence.nvim
  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>qS", function() require("persistence").select() end, desc = "Select session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
    },
  },

  -- https://github.com/edkolev/tmuxline.vim
  -- Generate tmux theme from vim statusline colors
  {
    "edkolev/tmuxline.vim",
    cmd = { "Tmuxline", "TmuxlineSnapshot" },
  },

  -- https://github.com/HakonHarnes/img-clip.nvim
  -- Paste images into markdown
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

  -- https://github.com/nvim-lua/plenary.nvim
  -- Lua utility library
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- https://github.com/MeanderingProgrammer/render-markdown.nvim
  -- Render markdown in buffer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons",
    },
    opts = {
      code = {
        border = "thick",
      },
    },
  },
}
