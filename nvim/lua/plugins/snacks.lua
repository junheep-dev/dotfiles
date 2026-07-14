function _G.SnacksLazygitEdit(file, line)
  local lazygit_win = vim.api.nvim_get_current_win()
  vim.schedule(function()
    if vim.api.nvim_win_is_valid(lazygit_win) then
      pcall(vim.api.nvim_win_close, lazygit_win, false)
    end
    vim.cmd.edit(vim.fn.fnameescape(file))
    if line then
      pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(line) or 1, 0 })
    end
  end)
end

-- Navigate out of a terminal window with <C-hjkl>. In a floating terminal there
-- is nothing to move to, so pass the key through; in a split, move to the window
-- in that direction. Same trick LazyVim uses.
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      nes = { enable = false },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      terminal = {
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
            normal_mode = {
              "<C-q>",
              function()
                vim.cmd("stopinsert")
              end,
              desc = "Enter normal mode",
              mode = "t",
            },
          },
        },
      },
      lazygit = {
        config = {
          os = {
            edit = "nvim --server $NVIM --remote-send '<C-\\><C-n><Cmd>lua SnacksLazygitEdit({{filename}})<CR>'",
            editAtLine = "nvim --server $NVIM --remote-send '<C-\\><C-n><Cmd>lua SnacksLazygitEdit({{filename}}, {{line}})<CR>'",
          },
        },
      },
    },
    keys = {
      {
        "<leader>gg",
        function()
          require("snacks").lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<c-/>",
        function()
          require("snacks").terminal()
        end,
        desc = "Terminal",
        mode = { "n", "t" },
      },
      {
        "<c-_>",
        function()
          require("snacks").terminal()
        end,
        desc = "which_key_ignore",
        mode = { "n", "t" },
      },
      {
        "<leader>tt",
        function()
          require("snacks").terminal(nil, { win = { position = "right" } })
        end,
        desc = "Terminal (vsplit)",
      },
      {
        "<leader>tT",
        function()
          require("snacks").terminal(nil, { win = { position = "bottom" } })
        end,
        desc = "Terminal (split)",
      },
    },
  },
}
