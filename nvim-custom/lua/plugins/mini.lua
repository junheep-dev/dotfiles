return {
  {
    "nvim-mini/mini.diff",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini-git",
    main = "mini.git",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.bracketed",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.completion",
    version = "*",
    lazy = false,
    opts = {
      lsp_completion = {
        source_func = "omnifunc",
        auto_setup = false,
      },
    },
    keys = {
      {
        "<Tab>",
        function()
          if vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
            return ""
          end
          if require("sidekick").nes_jump_or_apply() then
            return ""
          end
          if vim.lsp.inline_completion.get() then
            return ""
          end
          return "<Tab>"
        end,
        mode = "i",
        expr = true,
        desc = "Smart Tab",
      },
    },
  },
  {
    "nvim-mini/mini.cmdline",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.icons",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.pairs",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.surround",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.ai",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.comment",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.trailspace",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.splitjoin",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.move",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.sessions",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.visits",
    version = "*",
    lazy = false,
    opts = {},
    keys = {
      {
        "<leader>vc",
        function()
          local sort_latest = require("mini.visits").gen_sort.default({ recency_weight = 1 })
          require("mini.extra").pickers.visit_paths(
            { cwd = "", filter = "core", sort = sort_latest },
            { source = { name = "Core Visits (All)" } }
          )
        end,
        desc = "Core Visits (All)",
      },
      {
        "<leader>vC",
        function()
          local sort_latest = require("mini.visits").gen_sort.default({ recency_weight = 1 })
          require("mini.extra").pickers.visit_paths(
            { cwd = nil, filter = "core", sort = sort_latest },
            { source = { name = "Core Visits (Cwd)" } }
          )
        end,
        desc = "Core Visits (Cwd)",
      },
      {
        "<leader>vv",
        function()
          require("mini.visits").add_label("core")
        end,
        desc = "Add Core Label",
      },
      {
        "<leader>vV",
        function()
          require("mini.visits").remove_label("core")
        end,
        desc = "Remove Core Label",
      },
      {
        "<leader>vl",
        function()
          require("mini.visits").add_label()
        end,
        desc = "Add Label",
      },
      {
        "<leader>vL",
        function()
          require("mini.visits").remove_label()
        end,
        desc = "Remove Label",
      },
    },
  },
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
      {
        "<leader>un",
        function()
          require("mini.notify").show_history()
        end,
        desc = "Notification History",
      },
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
    "nvim-mini/mini.operators",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.files",
    version = "*",
    opts = {},
    keys = {
      {
        "<leader>ef",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
        end,
        desc = "Explorer (current file)",
      },
      {
        "<leader>ed",
        function()
          require("mini.files").open(vim.uv.cwd())
        end,
        desc = "Explorer (cwd)",
      },
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
    "nvim-mini/mini.tabline",
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
          { mode = "n", keys = "<leader>a", desc = "+ai" },
          { mode = "n", keys = "<leader>b", desc = "+buffer" },
          { mode = "n", keys = "<leader>c", desc = "+code" },
          { mode = "n", keys = "<leader>e", desc = "+explore" },
          { mode = "n", keys = "<leader>f", desc = "+file" },
          { mode = "n", keys = "<leader>t", desc = "+tabs" },
          { mode = "n", keys = "<leader>u", desc = "+ui" },
          { mode = "n", keys = "<leader>v", desc = "+visits" },
          miniclue.gen_clues.square_brackets(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.z(),
          miniclue.gen_clues.windows(),
        },
      })
    end,
  },
}
