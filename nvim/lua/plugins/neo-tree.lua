return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>ee", "<Cmd>Neotree toggle<CR>", desc = "Neo-tree" },
    { "<leader>ef", "<Cmd>Neotree focus<CR>", desc = "Neo-tree (focus)" },
    { "<leader>eE", "<Cmd>Neotree reveal<CR>", desc = "Neo-tree (reveal file)" },
    { "<leader>eg", "<Cmd>Neotree left git_status<CR>", desc = "Git status" },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      width = 32,
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none", -- keep leader usable inside the tree
      },
    },
  },
}
