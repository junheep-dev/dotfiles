return {
  {
    "nvim-mini/mini.input",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.cursorword",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.indentscope",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.starter",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.notify",
    version = "*",
    lazy = false,
    opts = {},
    keys = {
      { "<leader>un", function() require("mini.notify").show_history() end, desc = "Notification History" },
    },
  },
  {
    "nvim-mini/mini.pick",
    version = "*",
    opts = {},
    keys = {
      { "<leader>ff", "<Cmd>Pick files<CR>", desc = "Files" },
      { "<leader>fg", "<Cmd>Pick grep_live<CR>", desc = "Grep Live" },
      { "<leader>fG", '<Cmd>Pick grep pattern="<cword>"<CR>', desc = "Grep Current Word" },
      { "<leader>fb", "<Cmd>Pick buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<Cmd>Pick help<CR>", desc = "Help Tags" },
      { "<leader>fr", "<Cmd>Pick resume<CR>", desc = "Resume" },
    },
  },
  {
    "nvim-mini/mini.extra",
    version = "*",
    opts = {},
    keys = {
      { "<leader>fd", '<Cmd>Pick diagnostic scope="all"<CR>', desc = "Diagnostic Workspace" },
      { "<leader>fD", '<Cmd>Pick diagnostic scope="current"<CR>', desc = "Diagnostic Buffer" },
      { "<leader>fs", '<Cmd>Pick lsp scope="workspace_symbol_live"<CR>', desc = "Symbols Workspace" },
      { "<leader>fS", '<Cmd>Pick lsp scope="document_symbol"<CR>', desc = "Symbols Document" },
      { "<leader>fR", '<Cmd>Pick lsp scope="references"<CR>', desc = "References (LSP)" },
    },
  },
  {
    "nvim-mini/mini.jump",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.jump2d",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.files",
    version = "*",
    opts = {},
    keys = {
      { "<leader>ef", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, desc = "Explorer (current file)" },
      { "<leader>ed", function() require("mini.files").open(vim.uv.cwd()) end, desc = "Explorer (cwd)" },
    },
  },
  {
    "nvim-mini/mini.hipatterns",
    version = "*",
    opts = function()
      local hipatterns = require("mini.hipatterns")
      return {
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
    end,
  },
  {
    "nvim-mini/mini.statusline",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.clue",
    version = "*",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          { mode = "n", keys = "<leader>" },
          { mode = "x", keys = "<leader>" },
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = { "n", "x" }, keys = "g" },
          { mode = { "n", "x" }, keys = "z" },
          { mode = "n", keys = "<C-w>" },
        },
        clues = {
          { mode = "n", keys = "<leader>b", desc = "+buffer" },
          { mode = "n", keys = "<leader>c", desc = "+code" },
          { mode = "n", keys = "<leader>e", desc = "+explore" },
          { mode = "n", keys = "<leader>f", desc = "+file" },
          { mode = "n", keys = "<leader>t", desc = "+tabs" },
          { mode = "n", keys = "<leader>u", desc = "+ui" },
          miniclue.gen_clues.square_brackets(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.z(),
          miniclue.gen_clues.windows(),
        },
      })
    end,
  },
}
