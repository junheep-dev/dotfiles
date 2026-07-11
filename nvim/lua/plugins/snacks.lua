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

return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
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
    },
  },
}
