-- Theme system (ported from LazyVim + omarchy theme-hotreload).
--
-- All switcher themes are installed (lazy = true, so no startup cost) and the
-- active one is chosen by `vim.g.active_colorscheme`, which theme.sh sets via
-- lua/plugins/theme.lua (gitignored). That file lives under plugins/ so lazy's
-- change_detection watches it: swapping it on disk fires `User LazyReload`, and
-- the manager below re-applies the colorscheme live -- no restart needed.

-- Highlight groups whose background is stripped so the terminal shows through.
-- Scoped to our stack (core UI + mini.nvim floats); no neotree/telescope here.
local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "SignColumn",
  "LineNr",
  "CursorLineNr",
  "EndOfBuffer",
  "FoldColumn",
  "Folded",
  -- mini.nvim floats
  "MiniFilesNormal",
  "MiniFilesBorder",
  "MiniFilesTitle",
  "MiniPickNormal",
  "MiniPickBorder",
  "MiniPickPrompt",
  "MiniNotifyNormal",
  "MiniNotifyBorder",
}

local function apply_transparency()
  for _, name in ipairs(transparent_groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok then
      hl.bg = nil
      hl.ctermbg = nil
      pcall(vim.api.nvim_set_hl, 0, name, hl)
    end
  end
end

local function active_colorscheme()
  -- re-run plugins/theme.lua fresh so a swap is picked up even if lazy has not
  -- re-imported it yet; the file's side effect sets vim.g.active_colorscheme
  package.loaded["plugins.theme"] = nil
  pcall(require, "plugins.theme")
  local name = vim.g.active_colorscheme
  if type(name) == "string" and name ~= "" then
    return name
  end
  return "tokyonight"
end

local function apply_theme()
  local name = active_colorscheme()
  -- clear stale highlights from the previous theme before switching
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.background = "dark"
  -- load the (lazy) plugin that provides this colorscheme, then apply it
  require("lazy.core.loader").colorscheme(name)
  pcall(vim.cmd.colorscheme, name)
end

return {
  -- Theme plugins: installed but not loaded at startup (loaded on demand by the
  -- manager). Per-theme config (opts/setup/g:vars) lives in each theme's file
  -- under themes/<name>/neovim.lua and is merged in when that theme is active.
  { "folke/tokyonight.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "projekt0n/github-nvim-theme", lazy = true },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = function()
      -- The default grey Visual (bg3 #3c3836) is too dim on the hard bg. Bump it
      -- to #504945 -- the hard palette's own bg5 -- via a ColorScheme autocmd,
      -- since applying the colorscheme resets highlights afterwards.
      -- pattern-guarded so only gruvbox-material is affected.
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("gruvbox_visual", { clear = true }),
        pattern = "gruvbox-material",
        callback = function()
          vim.api.nvim_set_hl(0, "Visual", { bg = "#504945" })
        end,
      })
    end,
  },
  { "rebelot/kanagawa.nvim", lazy = true },

  -- Manager: a local "plugin" (config dir) that applies the active theme on
  -- startup and re-applies it on every LazyReload (i.e. theme.sh disk change).
  {
    name = "theme-manager",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000, -- apply theme before other UI plugins load
    config = function()
      -- keep transparency in sync with any colorscheme change (startup, switch,
      -- or manual :colorscheme)
      vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_transparency })
      apply_theme()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyReload",
        callback = function()
          vim.schedule(function()
            apply_theme()
            vim.cmd("redraw!")
          end)
        end,
      })
    end,
  },
}
