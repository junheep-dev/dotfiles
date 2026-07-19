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
-- Sidekick floating-window control. The float is fully described by the four
-- config.cli.win.float fractions {width, height, col, row} (col/row are
-- positions within the leftover space: 0=top/left, 1=bottom/right). SidekickFloat
-- keeps the open float in sync with those fractions and backs the <C-'> shape
-- cycle (sidebar right/left/full). Defined at startup (this file is imported
-- eagerly for its spec).
_G.SidekickFloat = {}

-- Two size presets: the default right sidebar and a near-full reading view.
-- full shares the sidebar's height/row so switching only changes the width.
SidekickFloat.presets = {
  sidebar = { width = 0.4, height = 0.92, col = 0.98, row = 0.3 },
  full = { width = 0.92, height = 0.92, col = 0.5, row = 0.3 },
}

-- Recompute the open float's geometry from the current config fractions. Also
-- used by the VimResized handler so the float keeps its ratio/position on resize.
function SidekickFloat.apply()
  local f = require("sidekick.config").cli.win.float
  local lines, cols = vim.o.lines, vim.o.columns
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(w)
    if vim.w[w].sidekick_cli ~= nil and cfg.relative ~= "" then
      cfg.width = math.floor(cols * f.width)
      cfg.height = math.floor(lines * f.height)
      cfg.row = math.floor((lines - cfg.height) * f.row)
      cfg.col = math.floor((cols - cfg.width) * f.col)
      vim.api.nvim_win_set_config(w, cfg)
    end
  end
end

-- Merge float-fraction overrides into the config, switch the CLI to the floating
-- layout if it is currently a split (or open it), and apply the geometry live.
local function set_float(overrides)
  local Config = require("sidekick.config")
  for k, v in pairs(overrides) do
    Config.cli.win.float[k] = v
  end
  require("sidekick.cli.state").with(function(state)
    local t = state and state.terminal
    if not t then
      return
    end
    t.opts.float = vim.deepcopy(Config.cli.win.float) -- sync the terminal snapshot
    if t.opts.layout ~= "float" then
      t.opts.layout = "float"
      if t:is_open() then
        t:hide()
      end
      t:show()
      t:focus()
    elseif t:is_open() then
      SidekickFloat.apply()
    else
      t:show()
      t:focus()
    end
  end, { filter = { installed = true } })
end

-- Snap the float to a named size preset (sidebar | full).
function SidekickFloat.tile(name)
  local p = SidekickFloat.presets[name]
  if p then
    set_float(p)
  end
end

-- Snap the float to a left or right sidebar. Both use the sidebar preset's size;
-- the left variant mirrors the right's edge padding (col = 1 - sidebar.col) so
-- the gap from the screen edge is identical on both sides.
function SidekickFloat.side(dir)
  local sb = SidekickFloat.presets.sidebar
  set_float({
    width = sb.width,
    height = sb.height,
    row = sb.row,
    col = dir == "left" and (1 - sb.col) or sb.col,
  })
end

-- Cross-mode float-shape cycle: right sidebar -> left sidebar -> full -> wrap.
-- Bound to <C-'> so one key (n+t) reshapes the float without a <leader> prefix.
SidekickFloat._shape = 0
function SidekickFloat.cycle()
  local steps = {
    function()
      SidekickFloat.side("right")
    end,
    function()
      SidekickFloat.side("left")
    end,
    function()
      SidekickFloat.tile("full")
    end,
  }
  SidekickFloat._shape = (SidekickFloat._shape % #steps) + 1
  steps[SidekickFloat._shape]()
end
-- Track the sidekick split's width as a fraction of the editor, and reapply it
-- whenever Neovim itself resizes. sidekick pins the split with winfixwidth, so
-- on a VimResized it keeps its absolute width and the drift breaks the ratio.
-- Capture manual drags (columns unchanged) so a hand-tuned ratio survives too.
do
  local group = vim.api.nvim_create_augroup("junheep_sidekick_resize", { clear = true })
  local ratio = nil -- last known sidekick width / columns; nil until first seen
  local applied_columns = vim.o.columns
  local applied_width = nil -- sidekick width we set programmatically; not a drag

  -- sidekick SPLIT windows only (floats excluded via relative == ""). The ratio
  -- tracking / width reapply below is split-specific; floats are relaid out from
  -- their own fractions by SidekickFloat.apply().
  local function sidekick_wins()
    return vim.tbl_filter(function(w)
      return vim.w[w].sidekick_cli ~= nil and vim.api.nvim_win_get_config(w).relative == ""
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
      -- floats: recompute from fractions so the sidebar keeps ratio + position
      SidekickFloat.apply()
      -- splits: restore the tracked width ratio, then equalize the others
      local wins = sidekick_wins()
      if #wins == 0 then
        return -- no sidekick split; let the generic resize autocmd handle it
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
  -- other windows come out uneven. Equalize whenever the split shows... Only
  -- splits take layout space; a float sits above the grid, so equalizing on a
  -- float open/close would needlessly reset hand-sized editor splits. Guard both
  -- handlers on relative == "". BufWinEnter can't assume the current window is
  -- the sidekick one (it opens with enter=false), so resolve the buffer's window.
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    callback = function(ev)
      local win = vim.fn.bufwinid(ev.buf)
      if
        vim.bo[ev.buf].filetype == "sidekick_terminal"
        and win ~= -1
        and vim.api.nvim_win_get_config(win).relative == ""
      then
        vim.schedule(equalize)
      end
    end,
  })

  -- ...or is closed. The window is still valid here, so its config is readable.
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    callback = function(ev)
      local win = tonumber(ev.match)
      if win and vim.w[win].sidekick_cli ~= nil and vim.api.nvim_win_get_config(win).relative == "" then
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
      nes = { enabled = false },
      cli = {
        win = {
          -- open as a floating sidebar by default (sidekick's default is "right"
          -- split); <c-,> still toggles to a split when wanted.
          layout = "float",
          split = { width = 0.5 },
          -- floating layout as a right-anchored sidebar. col=0.98 leaves a small
          -- gap from the right edge (col is a fraction of the leftover space,
          -- 1=flush right); width/height are editor fractions. border makes it
          -- readable and surfaces the " Sidekick " title (a minimal window
          -- hides the title without one).
          float = { border = "single", width = 0.4, height = 0.92, col = 0.98, row = 0.3 },
          -- Show the running tool in the float border title (e.g. "Sidekick ·
          -- Claude Code" instead of a static " Sidekick "). Runs per-terminal at
          -- init on the snapshot open_win reads, so each tool gets its own title.
          config = function(terminal)
            local tool = terminal.tool and terminal.tool.name
            if not tool then
              return
            end
            local labels = { claude = "Claude Code", claude_continue = "Claude Code" }
            local label = labels[tool] or tool:sub(1, 1):upper() .. tool:sub(2)
            terminal.opts.float.title = " Sidekick - " .. label .. " "
          end,
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
        desc = "Detach a CLI Session",
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
        desc = "Sidekick Start Claude --continue",
      },
      {
        "<c-,>",
        function()
          require("sidekick.cli.state").with(function(state)
            local t = state and state.terminal
            if not t then
              return
            end
            -- flip between floating and the right split, then reopen in place.
            -- open_win() re-reads opts.layout, so hide->show swaps the window
            -- while keeping the CLI process (and its session) alive.
            t.opts.layout = t.opts.layout == "float" and "right" or "float"
            t:hide()
            t:show()
            t:focus()
          end, { filter = { installed = true } })
        end,
        desc = "Sidekick Toggle Layout",
        mode = { "n", "t" },
      },
      {
        -- Toggle focus in/out of the CLI. Works from terminal mode too, so you
        -- can drop back to the editor and jump back in without reaching for the
        -- <leader> maps. Reimplements sidekick.cli.focus() instead of calling it
        -- directly: that version always startinsert()s on focus, forcing insert
        -- mode even if the terminal was last left in normal mode. Just moving
        -- the current window (like <C-h>/<C-l> window nav already does) lets the
        -- terminal's own WinEnter autocmd restore whichever mode it was left in.
        "<c-;>",
        function()
          require("sidekick.cli.state").with(function(state)
            local t = state and state.terminal
            if not t then
              return
            end
            if t:is_focused() then
              t:blur()
            elseif t:is_running() then
              vim.api.nvim_set_current_win(t.win)
            end
          end, {
            attach = true,
            filter = { installed = true },
            focus = false,
            show = true,
          })
        end,
        desc = "Sidekick Focus Toggle",
        mode = { "n", "t" },
      },
      {
        -- Cycle the float shape (right sidebar -> left sidebar -> full) from any
        -- mode, so it's reachable while typing in the terminal without <leader>.
        "<c-'>",
        function()
          SidekickFloat.cycle()
        end,
        desc = "Sidekick Cycle Float Shape",
        mode = { "n", "t" },
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
