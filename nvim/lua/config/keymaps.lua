-- Loaded on the VeryLazy event (see config.lazy).
-- Only dependency-free core keymaps live here. Plugin-specific keymaps
-- (lazygit, bufdelete, format, toggles, pickers, ...) go in each plugin's
-- spec `keys = {}` as those plugins are added.
local map = vim.keymap.set

-- better up/down (respect wrapped lines)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- move to window using <ctrl> hjkl
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- resize window using <ctrl-shift> arrow keys (plain ctrl-arrows clash with macOS Mission Control)
map("n", "<C-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- smart <C-w>o: nvim 0.12's :only closes floats/terminals too, so close only
-- ordinary split windows and keep floats, terminals, and snacks/sidekick panes.
map("n", "<C-w>o", function()
  local cur = vim.api.nvim_get_current_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= cur then
      local buf = vim.api.nvim_win_get_buf(win)
      local is_float = vim.api.nvim_win_get_config(win).relative ~= ""
      local ft = vim.bo[buf].filetype
      local keep = is_float or vim.bo[buf].buftype == "terminal" or ft:match("^snacks_") or ft:match("sidekick")
      if not keep then
        pcall(vim.api.nvim_win_close, win, false)
      end
    end
  end
end, { desc = "Only (keep floats/terminals)" })

-- clear search with <esc>
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- saner n/N: always search the same direction + center
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- smart <Tab>: snippet tabstop → sidekick NES → Copilot accept → literal Tab.
-- Not tied to any one plugin; the require()s are deferred to press time, so
-- lazy.nvim loads sidekick/copilot on first use (dependency-free at definition).
map({ "i", "n" }, "<Tab>", function()
  if vim.snippet.active({ direction = 1 }) then
    vim.snippet.jump(1)
    return ""
  end
  if require("sidekick").nes_jump_or_apply() then
    return ""
  end
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
    return ""
  end
  return "<Tab>"
end, { expr = true, desc = "Smart Tab" })

-- switch to last (alternate) buffer
map("n", "<leader>ba", "<cmd>b#<cr>", { desc = "Alternate Buffer" })

-- lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- quickfix / location list
map("n", "<leader>eq", function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen")
end, { desc = "Quickfix List" })
map("n", "<leader>eQ", function()
  vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose" or "lopen")
end, { desc = "Location List" })

-- diagnostics
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
