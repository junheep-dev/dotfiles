-- VSCode-style side-by-side diff, review explorer and merge resolution.
-- Complements gitsigns (in-buffer hunks) and mini.git (raw `Git diff`)
-- rather than replacing them: this is the whole-changeset review view.
-- The C diff binary is downloaded on first use, so no compiler is needed.
--
-- Keymaps are left at their defaults except the two that are bare <leader>
-- prefixes: those shadow the +buffer / +explore clue groups and make every
-- <leader>b / <leader>e press wait out timeoutlen. The <leader>h* (hunk) and
-- <leader>c* (conflict) defaults keep their own namespace, which this config
-- uses nowhere else -- moving them onto <leader>gh* only made gitsigns win
-- the collision in the working-tree pane and leave the diff view stale.
return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  keys = {
    { "<leader>gv", "<Cmd>CodeDiff<CR>", desc = "Review" },
  },
  opts = {
    diff = { layout = "inline" },
    keymaps = {
      view = {
        toggle_explorer = "<leader>ge",
        focus_explorer = "<leader>gE",
      },
    },
  },
  config = function(_, opts)
    require("codediff").setup(opts)

    -- Name the <leader>h / <leader>c groups for mini.clue. Config clues are
    -- registered whether or not a mapping exists behind them (see
    -- H.clues_get_all), so a global clue would advertise a dead group in every
    -- buffer; buffer-local clues concat onto the global ones instead.
    local clues = {
      { mode = "n", keys = "<leader>h", desc = "+hunk" },
      { mode = "n", keys = "<leader>c", desc = "+conflict" },
    }
    local diff_tabs = {}

    -- The working-tree pane shows the real file buffer, which outlives the diff
    -- tab, so the clue has to be cleared again when it is entered elsewhere.
    local function apply(buf)
      local active = diff_tabs[vim.api.nvim_get_current_tabpage()]
      vim.b[buf].miniclue_config = active and { clues = clues } or nil
      -- mini.clue triggers must be the latest buffer-local mappings (see
      -- :h mini.clue caveats); codediff maps its keys after they were set
      if active and package.loaded["mini.clue"] then
        require("mini.clue").ensure_buf_triggers(buf)
      end
    end

    local group = vim.api.nvim_create_augroup("junheep_codediff_clue", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = { "CodeDiffOpen", "CodeDiffClose" },
      callback = function(ev)
        local opened = ev.match == "CodeDiffOpen"
        diff_tabs[ev.data.tabpage] = opened or nil
        -- on close the tabpage is already gone; BufEnter clears those buffers
        if opened then
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(ev.data.tabpage)) do
            apply(vim.api.nvim_win_get_buf(win))
          end
        end
      end,
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "TabEnter" }, {
      group = group,
      callback = function(ev)
        apply(ev.buf)
      end,
    })
  end,
}
