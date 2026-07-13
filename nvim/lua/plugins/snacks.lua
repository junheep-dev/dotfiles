-- Open a file from lazygit in the current window and close the lazygit float.
-- lazygit's os.edit calls this (via `nvim --server $NVIM --remote-send`) instead
-- of the default nvim-remote preset, which opens a new tab and leaves the float
-- open. Deferred with vim.schedule so it runs after lazygit's edit call returns
-- (closing the float inline races with lazygit and fails to open the buffer).
function _G.SnacksLazygitEdit(file, line)
  local float_win = vim.api.nvim_get_current_win()
  vim.schedule(function()
    if vim.api.nvim_win_is_valid(float_win) then
      pcall(vim.api.nvim_win_close, float_win, false)
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
    return self:is_floating() and "<c-" .. dir .. ">"
      or vim.schedule(function()
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
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      terminal = {
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
            -- Enter normal mode in one keystroke, like the sidekick terminal.
            -- snacks' default is double-<esc>, but that is an expr mapping that
            -- calls stopinsert; stopinsert deferred inside an expr mapping leaves
            -- you in terminal mode until the next key, which then gets swallowed.
            -- A plain (non-expr) stopinsert switches to normal mode immediately.
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
        -- Override the nvim-remote preset (new tab + float stays open) so `e`
        -- closes the float and opens the file in the current window. See
        -- _G.SnacksLazygitEdit above. lazygit already wraps {{filename}} in
        -- double quotes, so it lands as a Lua string literal as-is.
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
