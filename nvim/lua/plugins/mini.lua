-- version = "*" pins each module to its latest stable tag (mini follows
-- semver), overriding the global `defaults.version = false` (= track HEAD).
-- mini's main branch is explicitly "beta testing phase" per its docs.
return {
  {
    "nvim-mini/mini.diff",
    version = "*",
    lazy = false,
    opts = {
      -- show hunks as colored signs in the signcolumn (default is 'number',
      -- which colors line numbers instead); gitsigns-style bar for add/change
      view = {
        style = "sign",
      },
    },
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay()
        end,
        desc = "Toggle Overlay",
      },
    },
  },
  {
    "nvim-mini/mini-git",
    main = "mini.git",
    version = "*",
    lazy = false,
    opts = {},
    keys = {
      { "<leader>ga", "<Cmd>Git diff --cached<CR>", desc = "Added Diff" },
      { "<leader>gA", "<Cmd>Git diff --cached -- %<CR>", desc = "Added Diff Buffer" },
      { "<leader>gc", "<Cmd>Git commit<CR>", desc = "Commit" },
      { "<leader>gC", "<Cmd>Git commit --amend<CR>", desc = "Commit Amend" },
      { "<leader>gd", "<Cmd>Git diff<CR>", desc = "Diff" },
      { "<leader>gD", "<Cmd>Git diff -- %<CR>", desc = "Diff Buffer" },
      { "<leader>gl", [[<Cmd>Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order<CR>]], desc = "Log" },
      {
        "<leader>gL",
        [[<Cmd>Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order --follow -- %<CR>]],
        desc = "Log Buffer",
      },
      {
        "<leader>gs",
        function()
          require("mini.git").show_at_cursor()
        end,
        mode = { "n", "x" },
        desc = "Show At Cursor",
      },
    },
  },
  {
    "nvim-mini/mini.bracketed",
    version = "*",
    opts = {},
  },
  {
    "nvim-mini/mini.bufremove",
    version = "*",
    opts = {},
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
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
    lazy = false,
    opts = {},
    keys = {
      {
        "<leader>ot",
        function()
          require("mini.trailspace").trim()
        end,
        desc = "Trim Trailspace",
      },
    },
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
    -- load on startup so autowrite persists the active session on exit
    lazy = false,
    opts = {},
    keys = {
      {
        "<leader>sn",
        function()
          vim.ui.input({ prompt = "Session name: " }, require("mini.sessions").write)
        end,
        desc = "New Session",
      },
      { "<leader>sw", "<Cmd>lua MiniSessions.write()<CR>", desc = "Write Current Session" },
      { "<leader>sr", '<Cmd>lua MiniSessions.select("read")<CR>', desc = "Read Session" },
      { "<leader>sd", '<Cmd>lua MiniSessions.select("delete")<CR>', desc = "Delete Session" },
      { "<leader>sR", "<Cmd>lua MiniSessions.restart()<CR>", desc = "Restart (Preserve Session)" },
    },
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
      {
        "<leader>fv",
        '<Cmd>Pick visit_paths cwd=""<CR>',
        desc = "Visit Paths (All)",
      },
      {
        "<leader>fV",
        "<Cmd>Pick visit_paths<CR>",
        desc = "Visit Paths (Cwd)",
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
        "<leader>en",
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
    -- load on startup (keys would otherwise lazy-load) so setup() replaces
    -- vim.ui.select from the very first select prompt
    lazy = false,
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
      { "<leader>fa", '<Cmd>Pick git_hunks scope="staged"<CR>', desc = "Added Hunks (All)" },
      { "<leader>fA", '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', desc = "Added Hunks (Buf)" },
      { "<leader>fm", "<Cmd>Pick git_hunks<CR>", desc = "Modified Hunks (All)" },
      { "<leader>fM", '<Cmd>Pick git_hunks path="%"<CR>', desc = "Modified Hunks (Buf)" },
      { "<leader>fc", "<Cmd>Pick git_commits<CR>", desc = "Commits (All)" },
      { "<leader>fC", '<Cmd>Pick git_commits path="%"<CR>', desc = "Commits (Buf)" },
      { "<leader>f/", '<Cmd>Pick history scope="/"<CR>', desc = '"/" History' },
      { "<leader>f:", '<Cmd>Pick history scope=":"<CR>', desc = '":" History' },
      { "<leader>fH", "<Cmd>Pick hl_groups<CR>", desc = "Highlight Groups" },
      { "<leader>fl", '<Cmd>Pick buf_lines scope="all"<CR>', desc = "Lines (All)" },
      { "<leader>fL", '<Cmd>Pick buf_lines scope="current"<CR>', desc = "Lines (Buf)" },
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
          { mode = "n", keys = "<leader>e", desc = "+explore" },
          { mode = "n", keys = "<leader>f", desc = "+file" },
          { mode = "n", keys = "<leader>g", desc = "+git" },
          { mode = "n", keys = "<leader>l", desc = "+language" },
          { mode = "n", keys = "<leader>o", desc = "+other" },
          { mode = "n", keys = "<leader>s", desc = "+session" },
          { mode = "n", keys = "<leader>t", desc = "+terminal" },
          { mode = "n", keys = "<leader>v", desc = "+visits" },
          miniclue.gen_clues.square_brackets(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.z(),
          miniclue.gen_clues.windows(),
        },
        window = {
          delay = 200,
        },
      })
    end,
  },
}
