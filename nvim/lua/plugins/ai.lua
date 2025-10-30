return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        -- Disable auto suggestions. Need to manually trigger with <M-]>
        auto_trigger = false,
      },
    },
  },

  {
    "folke/sidekick.nvim",
    config = function(_, opts)
      require("sidekick").setup(opts)

      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        callback = function()
          -- Only equalize windows when opening or reopening a sidekick CLI terminal
          if vim.b.sidekick_cli then
            vim.defer_fn(function()
              vim.cmd("wincmd =")
            end, 0)
          end
        end,
      })
    end,
    opts = {
      cli = {
        win = {
          keys = {
            hide_dot = {
              "<a-.>",
              "hide",
              mode = "nt",
              desc = "Hide",
            },
            zoom = {
              "<a-,>",
              function()
                -- Exit terminal mode if in terminal mode, then toggle zoom
                local mode = vim.api.nvim_get_mode().mode
                local was_terminal = mode == "t"
                if was_terminal then
                  vim.cmd("stopinsert")
                end
                vim.schedule(function()
                  require("snacks").toggle.zoom():toggle()
                  -- Return to terminal mode if we were in terminal mode
                  if was_terminal then
                    vim.schedule(function()
                      vim.cmd("startinsert")
                    end)
                  end
                end)
              end,
              mode = "nt",
              desc = "Zoom terminal",
            },
          },
          split = {
            width = 0.4,
          },
        },
        tools = {
          claude_continue = { cmd = { "claude", "--continue" } },
        },
      },
    },
    keys = {
      {
        "<a-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle Claude",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Sidekick Toggle Claude",
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Sidekick Toggle Claude",
      },
      {
        "<leader>aC",
        function()
          require("sidekick.cli").toggle({ name = "claude_continue", focus = true })
        end,
        desc = "Sidekick Toggle Claude continue",
      },
    },
  },

  -- {
  --   "coder/claudecode.nvim",
  --   dependencies = { "folke/snacks.nvim" },
  --   opts = function()
  --     vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
  --       pattern = "*claude*",
  --       callback = function()
  --         vim.defer_fn(function()
  --           vim.cmd("wincmd =")
  --         end, 0)
  --       end,
  --     })
  --     return {
  --       focus_after_send = true,
  --       terminal = {
  --         split_width_percentage = 0.4,
  --         snacks_win_opts = {
  --           keys = {
  --             claude_hide = {
  --               "<M-,>",
  --               function(self)
  --                 self:hide()
  --               end,
  --               mode = "t",
  --               desc = "Hide",
  --             },
  --           },
  --         },
  --       },
  --     }
  --   end,
  --   keys = {
  --     { "<M-,>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code", mode = { "n", "x" } },
  --     { "<leader>a", nil, desc = "AI/Claude Code" },
  --     { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
  --     { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
  --     { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
  --     { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
  --     { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model (ClaudeCode)" },
  --     { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
  --     { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  --     {
  --       "<leader>as",
  --       "<cmd>ClaudeCodeTreeAdd<cr>",
  --       desc = "Add file",
  --       ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
  --     },
  --     -- Diff management
  --     { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
  --     { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  --   },
  -- },
}
