local M = {}

function M.get_normal_win_count()
  local normal_wins = vim.tbl_filter(function(win)
    local config = vim.api.nvim_win_get_config(win)
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
    return config.relative == "" and filetype ~= "neo-tree"
  end, vim.api.nvim_tabpage_list_wins(0))
  return #normal_wins
end

return M
