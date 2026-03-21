return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader><space>", function() require("fzf-lua").files() end, desc = "Find files" },
      { "<leader>,", function() require("fzf-lua").buffers({ sort_lastused = true }) end, desc = "Switch buffer" },
      { "<leader>/", function() require("fzf-lua").live_grep() end, desc = "Grep" },
      { "<leader>:", function() require("fzf-lua").command_history() end, desc = "Command history" },
      { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files" },
      { "<leader>fg", function() require("fzf-lua").git_files() end, desc = "Git files" },
      { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recent files" },
      { "<leader>sg", function() require("fzf-lua").live_grep() end, desc = "Grep" },
      { "<leader>sw", function() require("fzf-lua").grep_cword() end, desc = "Grep word" },
      { "<leader>sw", function() require("fzf-lua").grep_visual() end, mode = "v", desc = "Grep selection" },
      { "<leader>sh", function() require("fzf-lua").helptags() end, desc = "Help tags" },
      { "<leader>sk", function() require("fzf-lua").keymaps() end, desc = "Keymaps" },
      { "<leader>sR", function() require("fzf-lua").resume() end, desc = "Resume" },
    },
    opts = {},
  },
}
