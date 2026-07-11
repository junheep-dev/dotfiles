return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    -- Provides inline suggestions AND runs the "copilot" LSP client that
    -- sidekick.nvim's NES reuses (no separate copilot-language-server needed).
    opts = {
      -- Manual mode: no ghost text until summoned with <M-]> / <M-[>.
      suggestion = {
        auto_trigger = false,
        hide_during_completion = true,
        keymap = {
          accept = false, -- accepted via the <Tab> smart-tab in mini.lua
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
    },
  },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        win = {
          split = { width = 0.5 },
        },
        tools = {
          claude_continue = { cmd = { "claude", "--continue" } },
        },
      },
    },
    keys = {
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "n", "x" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Select Prompt",
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Toggle Claude",
      },
      {
        "<leader>aC",
        function()
          require("sidekick.cli").toggle({ name = "claude_continue", focus = true })
        end,
        desc = "Toggle Claude Continue",
      },
    },
  },
}
