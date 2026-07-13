-- Keep files out of the sidekick terminal window. It is pinned with winfixbuf
-- (see cli.win.wo below), so opening a file there would fail. When a picker is
-- launched while the CLI is focused, mini.pick's target window is that pinned
-- split; retarget a real editor window on MiniPickStart so the file lands there.
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniPickStart",
  group = vim.api.nvim_create_augroup("junheep_sidekick_pick", { clear = true }),
  callback = function()
    local target = MiniPick.get_picker_state().windows.target
    if not (target and vim.api.nvim_win_is_valid(target) and vim.wo[target].winfixbuf) then
      return
    end
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if
        w ~= target
        and not vim.wo[w].winfixbuf
        and vim.api.nvim_win_get_config(w).zindex == nil
        and vim.bo[vim.api.nvim_win_get_buf(w)].buftype == ""
      then
        MiniPick.set_picker_target_window(w)
        return
      end
    end
  end,
})
-- Track the sidekick split's width as a fraction of the editor, and reapply it
-- whenever Neovim itself resizes. sidekick pins the split with winfixwidth, so
-- on a VimResized it keeps its absolute width and the drift breaks the ratio.
-- Capture manual drags (columns unchanged) so a hand-tuned ratio survives too.
do
  local group = vim.api.nvim_create_augroup("junheep_sidekick_resize", { clear = true })
  local ratio = nil -- last known sidekick width / columns; nil until first seen
  local applied_columns = vim.o.columns
  local applied_width = nil -- sidekick width we set programmatically; not a drag

  local function sidekick_wins()
    return vim.tbl_filter(function(w)
      return vim.w[w].sidekick_cli ~= nil
    end, vim.api.nvim_list_wins())
  end

  -- Share the editor evenly around the sidekick split. sidekick is winfixwidth,
  -- so `wincmd =` keeps its pinned width and equalizes only the other windows.
  local function equalize()
    vim.cmd("wincmd =")
  end

  -- Remember the ratio only on genuine manual resizes (editor width unchanged).
  vim.api.nvim_create_autocmd("WinResized", {
    group = group,
    callback = function()
      if vim.o.columns ~= applied_columns then
        return -- this WinResized is a side effect of an nvim resize; ignore
      end
      for _, w in ipairs(sidekick_wins()) do
        local width = vim.api.nvim_win_get_width(w)
        if width ~= applied_width then
          -- a genuine manual drag, not the echo of our own set_width; capturing
          -- the floored width we just applied would drift the ratio each resize
          ratio = width / vim.o.columns
          applied_width = nil
        end
      end
    end,
  })

  -- On an nvim resize, restore the sidekick ratio, then re-equalize the editor
  -- windows. Doing the equalize here makes the final layout correct regardless
  -- of ordering against the generic VimResized `wincmd =` autocmd.
  vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
      applied_columns = vim.o.columns
      local wins = sidekick_wins()
      if #wins == 0 then
        return -- no sidekick; let the generic resize autocmd handle it
      end
      local r = ratio or (require("sidekick.config").cli.win.split.width or 0.5)
      if r <= 1 then -- fraction; absolute widths are left to sidekick
        applied_width = math.floor(vim.o.columns * r)
        for _, w in ipairs(wins) do
          vim.api.nvim_win_set_width(w, applied_width)
        end
      end
      equalize()
    end,
  })

  -- sidekick opens with an explicit width, so Neovim skips equalalways and the
  -- other windows come out uneven. Equalize whenever the split shows...
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(ev)
      if vim.bo[ev.buf].filetype == "sidekick_terminal" then
        vim.schedule(equalize)
      end
    end,
  })

  -- ...or is closed.
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    callback = function(ev)
      local win = tonumber(ev.match)
      if win and vim.w[win].sidekick_cli ~= nil then
        vim.schedule(equalize)
      end
    end,
  })
end
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
          -- pin the terminal so <C-o>/<C-i> (jumplist) and stray :edits can't
          -- replace it; the MiniPickStart hook above keeps pickers off it too
          wo = { winfixbuf = true },
          keys = {
            -- sidekick binds <C-p> (terminal mode) to its prompt picker, which
            -- shadows the CLI's own <C-p> history nav. Disable it so <C-p>
            -- passes through to the CLI.
            prompt = false,
          },
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
          require("sidekick.cli").toggle({ filter = { installed = true } })
        end,
        desc = "Sidekick Toggle CLI",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").focus({ filter = { installed = true } })
        end,
        desc = "Focus CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        desc = "Select CLI",
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
    },
  },
}
